//
//  ATNetworkOperationManager.m
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/15/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATNetworkOperationManager.h"
#import "ATNetworkOperation.h"
#import "ATAPIOperation.h"
#import "ATAPILoginOperation.h"
#import "ATAPILogoutOperation.h"
#import "NSMutableString+AtTaskConnector.h"
#import "ATConnectorErrorConstants.h"
#import "ATAvatarLoadingOperation.h"
#import "ATDataParser.h"

static NSInteger const kHTTPStatusCodeUnauthorized = 401;

static NSString *const kSessionIDHeaderName = @"SessionID";
static NSString *const kSessionIDParameterName = @"sessionID";
static NSString *const kMethodParameterName = @"method";

//TODO refactor suffix handling
static NSString *const kHostSuffix = @".attask-ondemand.com";

@interface ATNetworkOperationManager ()

@property (nonatomic, strong) NSMutableSet *waitingNetworkOperations;
@property (nonatomic, strong) NSMutableDictionary *activeConnections;
@property (nonatomic, strong) NSOperationQueue *responseHandlingQueue;

@property (nonatomic, strong) NSString *originalServiceHost;
@property (nonatomic, strong) ATAPILoginOperation *loginOperation;

- (ATAPILoginOperation *)createLoginOperation;
- (void)submitLoginOperation:(ATAPILoginOperation *)operation;
- (void)queueNetworkOperation:(ATNetworkOperation *)operation;

- (void)startNetworkOperation:(ATNetworkOperation *)operation;
- (void)networkOperationSucceed:(ATNetworkOperation *)operation;
- (void)networkOperationFailed:(ATNetworkOperation *)operation;

- (NSURLRequest *)URLRequestForOperation:(ATNetworkOperation *)operation;

- (BOOL)isInvalidHost:(NSError *)error;
- (BOOL)isHostSuffixNeeded;

@end


@implementation ATNetworkOperationManager

@synthesize sessionID = _sessionID;
@synthesize serviceHost = _serviceHost;

@synthesize username = _username;
@synthesize password = _password;

@synthesize authenticationMethod = _authenticationMethod;
@synthesize usePostForAPI = _usePostForAPI;
@synthesize systemLanguage = _systemLanguage;
@synthesize userAgent = _userAgent;

@synthesize apiPath = _apiPath;
@synthesize apiVersion = _apiVersion;

@synthesize dataParser = _dataParser;

@synthesize waitingNetworkOperations = _waitingNetworkOperations;
@synthesize activeConnections = _activeConnections;
@synthesize responseHandlingQueue = _responseHandlingQueue;

@synthesize loginOperation = _loginOperation;

@synthesize originalServiceHost = _originalServiceHost;

#pragma mark - Initialization

- (id)init {
	self = [super init];
	if (self) {
//		_waitingNetworkOperations = [[NSMutableSet alloc] init];
//		_activeConnections = [[NSMutableDictionary alloc] init];
//		_responseHandlingQueue = [[NSOperationQueue alloc] init];
	}
	return self;
}

- (void)dealloc {
	for (ATOperation *o in _waitingNetworkOperations) {
		[o removeObserver:self forKeyPath:kOperationStateKeyPath];
	}
}

#pragma mark - Custom accessors

- (NSMutableSet *)waitingNetworkOperations {
	if (!_waitingNetworkOperations) {
		_waitingNetworkOperations = [[NSMutableSet alloc] init];
	}
	return _waitingNetworkOperations;
}

- (NSMutableDictionary *)activeConnections {
	if (!_activeConnections) {
		_activeConnections = [[NSMutableDictionary alloc] init];
	}
	return _activeConnections;
}

- (NSOperationQueue *)responseHandlingQueue {
	if (!_responseHandlingQueue) {
		_responseHandlingQueue = [[NSOperationQueue alloc] init];
	}
	return _responseHandlingQueue;
}

- (NSString *)normalizedServiceHost {
	NSMutableString *result = [[NSMutableString alloc] init];
	if (![self.serviceHost hasPrefix:@"http://"] && ![self.serviceHost hasPrefix:@"https://"]) {
		[result appendString:@"https://"];
	}
	[result appendString:self.serviceHost];
	NSString *host = [[NSString alloc] initWithString:result];
	self.serviceHost = host;
	return self.serviceHost;
}

#pragma mark - Operation submission

- (void)submitNetworkOperation:(ATNetworkOperation *)operation {
	if ([operation isKindOfClass:[ATAPILoginOperation class]]) {
		[self submitLoginOperation:(ATAPILoginOperation *)operation];
	} else if ([operation isKindOfClass:[ATAPILogoutOperation class]]) {
		self.sessionID = nil;
	} else {
		[self queueNetworkOperation:operation];
	}
}

- (ATAPILoginOperation *)createLoginOperation {
	return [[ATAPILoginOperation alloc] initWithUsername:self.username password:self.password];
}

- (void)generateNextHost {
//	if (![self isReloginNeeded] || ![self isHostSuffixNeeded]) {
//		return nil;
//	}
	self.originalServiceHost = self.serviceHost;
	NSMutableString *newHost = [[NSMutableString alloc] initWithString:self.serviceHost];
	if ([newHost hasSuffix:@"."]) {
		NSRange r;
		r.length = 1;
		r.location = [self.serviceHost length] - 1;
		[newHost deleteCharactersInRange:r];
//		newHost = [self.serviceHost substringToIndex:([self.serviceHost length] - 1)];
	}
//	newHost = [newHost stringByAppendingString:kHostSuffix];
	[newHost appendString:kHostSuffix];
	self.serviceHost = [[NSString alloc] initWithString:newHost];
}

- (void)submitLoginOperation:(ATAPILoginOperation *)operation {
	self.loginOperation = operation;
	self.username = operation.username;
	self.password = operation.password;
	for (ATNetworkOperation *anOperation in self.waitingNetworkOperations) {
		if (![anOperation isKindOfClass:[ATAPILogoutOperation class]]) {
			[anOperation addOperationDependency:operation];
		}
	}
	NSArray *keys = [self.activeConnections allKeys];
	for (NSValue *key in keys) {
		ATNetworkOperation *anOperation = [self.activeConnections objectForKey:key];
		if (![anOperation isKindOfClass:[ATAPILogoutOperation class]]) {
			NSURLConnection *connection = [key nonretainedObjectValue];
			[connection cancel];
			[anOperation addOperationDependency:operation];
			[anOperation reset];
			[self submitNetworkOperation:anOperation];
			[self.activeConnections removeObjectForKey:key];
		}
	}
	[self queueNetworkOperation:self.loginOperation];
}

- (void)queueNetworkOperation:(ATNetworkOperation *)operation {
	ATOperationState operationState = operation.operationState;
	if (operationState == ATOperationStateReady) {
		[self startNetworkOperation:operation];
	} else if (operationState == ATOperationStateWaiting) {
		[operation addObserver:self forKeyPath:kOperationStateKeyPath options:0 context:NULL];
		[self.waitingNetworkOperations addObject:operation];
	}
}

- (void)startNetworkOperation:(ATNetworkOperation *)operation {
	operation.request = [self URLRequestForOperation:operation];
	operation.connection = [[NSURLConnection alloc] initWithRequest:operation.request delegate:self];
//	NSLog(@"Req: %@", operation.request);
	[operation started];
	[self.activeConnections setObject:operation forKey:[NSValue valueWithNonretainedObject:operation.connection]];
}

- (void)networkOperationSucceed:(ATNetworkOperation *)operation {
	NSValue *key = [NSValue valueWithNonretainedObject:operation.connection];
	[self.activeConnections removeObjectForKey:key];
	[operation succeeded];
}

- (void)networkOperationFailed:(ATNetworkOperation *)operation {
	NSValue *key = [NSValue valueWithNonretainedObject:operation.connection];
	[self.activeConnections removeObjectForKey:key];
	[operation failed];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:kOperationStateKeyPath] && [object isKindOfClass:[ATNetworkOperation class]]) {
		ATNetworkOperation *operation = (ATNetworkOperation *)object;
		if (operation.operationState == ATOperationStateReady) {
			[self.waitingNetworkOperations removeObject:operation];
			[operation removeObserver:self forKeyPath:kOperationStateKeyPath];
			[self startNetworkOperation:operation];
		}
	}
//	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - URL connection creation

- (NSURLRequest *)URLRequestForOperation:(ATNetworkOperation *)operation {
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSMutableString *urlString = [[NSMutableString alloc] initWithString:self.normalizedServiceHost];
	if ([operation isKindOfClass:[ATAPIOperation class]]) {
		if (self.apiVersion && [self.apiVersion length] > 0) {
			[urlString appendFormat:@"%@/%@", self.apiPath, self.apiVersion];
		} else {
			[urlString appendString:self.apiPath];
		}
	}
	[urlString appendString:[operation URIPath]];
	NSMutableDictionary *HTTPHeaders = [[NSMutableDictionary alloc] init];
	[HTTPHeaders addEntriesFromDictionary:[operation HTTPHeaders]];
	NSMutableString *query = [[NSMutableString alloc] initWithString:[operation URIQuery]];
	NSString *HTTPMethod = [operation HTTPMethod];
	if (self.sessionID) {
		if (self.authenticationMethod == ATServiceAuthenticationMethodParameter) {
			[query appendURLParameterWithName:kSessionIDParameterName value:self.sessionID];
		} else {
			[HTTPHeaders setObject:self.sessionID forKey:kSessionIDHeaderName];
		}
	}
	BOOL usePost = (self.usePostForAPI && [operation isKindOfClass:[ATAPIOperation class]]);
	if (usePost) {
		[request setHTTPMethod:kHTTPMethodPost];
		[query appendURLParameterWithName:kMethodParameterName value:HTTPMethod];
	} else {
		[request setHTTPMethod:HTTPMethod];
	}
    [request setHTTPMethod:[operation HTTPMethod]];
//    request
	if (usePost) {
		if ([query length] > 0) {
            NSError *error;
            id input = [(ATAPIOperation *)operation inputData];
            if (input) {
                NSData *dd = nil;
 /*               if (![[(ATAPIOperation *)operation inputData] isKindOfClass:[NSData class]]) {
                    dd = [NSJSONSerialization dataWithJSONObject:[(ATAPIOperation *)operation inputData] options:0 error:&error];
                } else {
                    dd = [(ATAPIOperation *)operation inputData];
                }*/
				NSString *ss = @"client_id=obt-ios-app-client&client_secret=cf8cc52e-0016-438c-9866-356fc21060b&username=mobile-client&password=0btpa$$w0rd&grant_type=password";
				dd = [ss dataUsingEncoding:NSUTF8StringEncoding];
                [request setHTTPBody:dd];
            }

            //[request setHTTPBody:dd];
		}
	} else {
		if ([query length] > 0) {
			[urlString appendFormat:@"?%@", query];
		}
		[request setHTTPBody:[operation HTTPBody]];
	}
	NSURL *u = [[NSURL alloc] initWithString:urlString];
	[request setURL:u];
//	[HTTPHeaders setObject:@"gzip" forKey:@"Accept-Encoding"];
	NSString *contentType = [operation HTTPHeaderForKey:@"Content-Type"];
	if (contentType != nil) {
		[HTTPHeaders setObject:contentType forKey:@"Content-Type"];
	} else {
		[HTTPHeaders setObject:@"application/json" forKey:@"Content-Type"];
	}
    if ([[(ATAPIOperation *)operation inputData] isKindOfClass:[NSData class]]) {
        [HTTPHeaders setObject:@"multipart/form-data; boundary=-------------V2ymHFg03ehbqgZCaKO6jy" forKey:@"Content-Type"];
        NSString *postLength = [NSString stringWithFormat:@"%d", [[request HTTPBody] length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    }
	if (self.systemLanguage) {
		[HTTPHeaders setObject:self.systemLanguage forKey:@"Accept-Language"];
	}
	if (self.userAgent) {
		[HTTPHeaders setObject:self.userAgent forKey:@"User-Agent"];
	}
	[request setAllHTTPHeaderFields:[HTTPHeaders copy]];
//	return [request copy];
	return request;
}

#pragma mark - URL connection delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"FFF: %@", error);
	BOOL shouldStopRunLoop = YES;
	NSValue *opkey = [NSValue valueWithNonretainedObject:connection];
	ATNetworkOperation *operation = [self.activeConnections objectForKey:opkey];
	if ([operation isKindOfClass:[ATAPILoginOperation class]] && [self isInvalidHost:error] && [self isHostSuffixNeeded]) {
		NSValue *key = [NSValue valueWithNonretainedObject:operation.connection];
		[self.activeConnections removeObjectForKey:key];
		[self generateNextHost];
		if (self.loginOperation != nil) {
			shouldStopRunLoop = NO;
			ATAPILoginOperation *newLogin = [self createLoginOperation];
			newLogin.failureHandler = self.loginOperation.failureHandler;
			newLogin.completionHandler = self.loginOperation.completionHandler;
			[self submitLoginOperation:newLogin];
		}
	} else {
		switch ([error code]) {
			case -1003:
			case -1004:
				operation.error = [NSError errorWithDomain:kATConnectorErrorDomain code:kATConnectorHostNotFoundErrorCode userInfo:nil];
				break;
			default:
				operation.error = error;
				break;
		}
		//[self networkOperationFailed:operation];
		[self performSelectorOnMainThread:@selector(networkOperationFailed:) withObject:operation waitUntilDone:NO];
	}
	if (![[NSThread currentThread] isMainThread] && shouldStopRunLoop) {
		CFRunLoopStop(CFRunLoopGetCurrent());
	}
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
	// TODO
	return YES;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"willSendRequestForAuthenticationChallenge");

	[[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
	/*
	if ([challenge previousFailureCount] <= 2 ) {
		NSURLCredential *newCredential = [[NSURLCredential alloc] initWithUser:self.username password:self.password persistence:NSURLCredentialPersistenceForSession];
//		 credentialWithUser:self.username
//		 password:self.password
//		 persistence:NSURLCredentialPersistenceForSession];
		[[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
		[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
	} else {
//		NSLog(@"Failure count %d",[challenge previousFailureCount]);
	}
	 */
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"didReceiveAuthenticationChallenge");
}


#pragma mark - URL connection data delegate

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
	NSString *body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
	NSLog(@"-------SEND-------\nURL: %@\nBody: %@\n Method: %@ \n\n", [request URL], [request HTTPBody], request.HTTPMethod);
	NSValue *key = [NSValue valueWithNonretainedObject:connection];
	ATNetworkOperation *operation = [self.activeConnections objectForKey:key];
	if (nil != response && [operation isKindOfClass:[ATAPILoginOperation class]]) {
		NSURL *url = [request URL];
		NSMutableString *host = [[NSMutableString alloc] initWithFormat:@"%@://%@", url.scheme, url.host];
		if (nil != url.port) {
			[host appendFormat:@":%d", [url.port integerValue]];
		}
		self.serviceHost = [[NSString alloc] initWithString:host];
	}
	return [operation willSendRequest:request redirectResponse:response];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSValue *key = [NSValue valueWithNonretainedObject:connection];
	ATNetworkOperation *operation = [self.activeConnections objectForKey:key];
	operation.response = response;
	if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
		NSInteger sc = [(NSHTTPURLResponse *)response statusCode];
        NSLog(@"STatus Code: %d", sc);
		if (sc >= 400 && sc < 500) {
			operation.error = [NSError errorWithDomain:kATConnectorErrorDomain code:sc userInfo:nil];
		}
		switch (sc) {
			case 400:
				operation.error = [NSError errorWithDomain:kATConnectorErrorDomain code:kATConnectorNonStreamErrorCode userInfo:nil];
				break;
			case 401:
				operation.error = [NSError errorWithDomain:kATConnectorErrorDomain code:kATConnectorInvalidLoginErrorCode userInfo:nil];
				break;
			case 404:
				operation.error = [NSError errorWithDomain:kATConnectorErrorDomain code:kATConnectorHostNotFoundErrorCode userInfo:nil];
				break;
			default:
				break;
		}
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSValue *key = [NSValue valueWithNonretainedObject:connection];
	ATNetworkOperation *operation = [self.activeConnections objectForKey:key];
	[operation appendData:data];
	NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"-------RECIEVE------- \n%@", str);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"connectionDidFinishLoading");
	BOOL shouldStopRunLoop = YES;
	NSValue *key = [NSValue valueWithNonretainedObject:connection];
	ATNetworkOperation *operation = [self.activeConnections objectForKey:key];
	NSInteger sc = [(NSHTTPURLResponse *)operation.response statusCode];
	BOOL isLoginOperation = [operation isEqual:self.loginOperation];
	if (!isLoginOperation && (sc == kHTTPStatusCodeUnauthorized)) {
		shouldStopRunLoop = NO;
		self.sessionID = nil;
		[self submitLoginOperation:[self createLoginOperation]];
	} else {
		ATNetworkOperationManager * __weak theSelf = self;
		[self.responseHandlingQueue addOperationWithBlock:^() {
			@autoreleasepool {
				if ([operation parseData:self.dataParser]) {
					if (isLoginOperation) {
						theSelf.sessionID = [(ATAPILoginOperation *)operation sessionID];
						theSelf.loginOperation = nil;
					}
					[theSelf performSelectorOnMainThread:@selector(networkOperationSucceed:) withObject:operation waitUntilDone:NO];
				} else {
					[theSelf performSelectorOnMainThread:@selector(networkOperationFailed:) withObject:operation waitUntilDone:NO];
				}
			}
		}];
	}
	if (![[NSThread currentThread] isMainThread] && shouldStopRunLoop) {
		CFRunLoopStop(CFRunLoopGetCurrent());
	}
}

#pragma mark - Private methods

- (BOOL)isInvalidHost:(NSError *)error {
	return (error != nil && ([error code] == -1003 || [error code] == -1004));
}

- (BOOL)isHostSuffixNeeded {
	NSScanner *scanner = [[NSScanner alloc] initWithString:self.serviceHost];
	scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@""];
	if ([scanner scanUpToString:@"://" intoString:NULL], [scanner scanString:@"://" intoString:NULL],
		[scanner scanUpToString:@":" intoString:NULL], [scanner scanString:@":" intoString:NULL]) {
		return NO;
	}
	return ![self.serviceHost hasSuffix:kHostSuffix];
}

@end
