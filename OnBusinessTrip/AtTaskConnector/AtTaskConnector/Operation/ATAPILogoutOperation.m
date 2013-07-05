//
//  ATAPILogoutOperation.m
//  AtTaskConnector
//
//  Created by Mariam Hakobyan on 12/19/12.
//
//

static NSString *const kInputSessionID = @"sessionID";
static NSString *const kParameterSessionID = @"sessionID";

#import "ATAPILogoutOperation.h"
#import "NSMutableString+AtTaskConnector.h"

@implementation ATAPILogoutOperation

- (id)initWithSessionID:(NSString *)sessionID {
	return [self initWithSessionID:(NSString *)sessionID completionHandler:nil failureHandler:nil];
}

- (id)initWithSessionID:(NSString *)sessionID completionHandler:(ATOperationHandler)completionHandler {
	return [self initWithSessionID:(NSString *)sessionID completionHandler:completionHandler failureHandler:nil];
}

- (id)initWithSessionID:(NSString *)sessionID completionHandler:(ATOperationHandler)completionHandler failureHandler:(ATOperationHandler)failureHandler {
	self = [super initWithCompletionHandler:completionHandler failureHandler:failureHandler];
	if (self) {
		[self setOperationInputValue:sessionID forKey:kInputSessionID];
	}
	return self;
}

#pragma mark - Custom accessors

- (NSString *)sessionID {
	return [self operationInputValueForKey:kInputSessionID];
}

- (void)setSessionID:(NSString *)sessionID {
	[self setOperationInputValue:sessionID forKey:kInputSessionID];
}

#pragma mark - Provide info for request creation

- (NSString *)URIPath {
	return [NSString stringWithFormat:@"%@/logout", [super URIPath]];
}

- (NSString *)URIQuery {
	NSMutableString *query = [[NSMutableString alloc] initWithString:[super URIQuery]];
	NSString *sessionID = self.sessionID;
	if (sessionID) {
		[query appendURLParameterWithName:kParameterSessionID value:sessionID];
	}
	return [query copy];
}

- (NSString *)HTTPMethod {
	return kHTTPMethodGet;
}

@end