//
//  ATAPILoginOperation.m
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/27/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATAPILoginOperation.h"
#import "NSMutableString+AtTaskConnector.h"

static NSString *const kInputUsername = @"email";
static NSString *const kInputPassword = @"password";

static NSString *const kParameterUsername = @"username";
static NSString *const kParameterPassword = @"password";

static NSString *const kOutputSessionID = @"sessionID";

@implementation ATAPILoginOperation

- (id)initWithUsername:(NSString *)username password:(NSString *)password {
	return [self initWithUsername:username password:password completionHandler:nil failureHandler:nil];
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password
	 completionHandler:(ATOperationHandler)completionHandler {
	return [self initWithUsername:username password:password completionHandler:completionHandler failureHandler:nil];
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password
	 completionHandler:(ATOperationHandler)completionHandler
		failureHandler:(ATOperationHandler)failureHandler {
	self = [super initWithCompletionHandler:completionHandler failureHandler:failureHandler];
	if (self) {
		[self setOperationInputValue:username forKey:kInputUsername];
		[self setOperationInputValue:password forKey:kInputPassword];
        self.inputData = [NSDictionary dictionaryWithObjectsAndKeys:username, kInputUsername, password, kInputPassword, @"obt-ios-app-client", @"client_id", @"cf8cc52e-0016-438c-9866-356fc21060b", @"client_secret", @"password", @"grant_type", nil];
	}
	return self;
}

#pragma mark - Custom accessors

- (NSString *)username {
	return [self operationInputValueForKey:kInputUsername];
}

- (void)setUsername:(NSString *)username {
	[self setOperationInputValue:username forKey:kInputUsername];
}

- (NSString *)password {
	return [self operationInputValueForKey:kInputPassword];
}

- (void)setPassword:(NSString *)password {
	[self setOperationInputValue:password forKey:kInputPassword];
}

- (NSDictionary *)sessionAttributes {
	id result = self.output;
	if ([result isKindOfClass:[NSDictionary class]]) {
		return (NSDictionary *)result;
	}
	return nil;
}

- (NSString *)sessionID {
	NSString *sessionID = nil;
	NSDictionary *sessionAttributes = self.sessionAttributes;
	if (sessionAttributes) {
		sessionID = [sessionAttributes objectForKey:kOutputSessionID];
	}
	return sessionID;
}

#pragma mark - Provide info for request creation

- (NSString *)URIPath {
	return [NSString stringWithFormat:@"%@/oauth/token", [super URIPath]];
}

/*
- (NSString *)URIQuery {
	NSMutableString *query = [[NSMutableString alloc] initWithString:[super URIQuery]];
	NSString *username = self.username;
	if (username) {
		[query appendURLParameterWithName:kParameterUsername value:username];
	}
	NSString *password = self.password;
	if (password) {
		[query appendURLParameterWithName:kParameterPassword value:password];
	}
	[query appendURLParameterWithName:@"timeToLive" value:@"86400"];
	return [query copy];
}*/

- (NSString *)HTTPMethod {
	return kHTTPMethodPost;
}

- (NSString *)HTTPHeaderForKey:(NSString *)key {
	if ([key isEqualToString:@"Content-Type"]) {
		return @"application/x-www-form-urlencoded";
	}
	return nil;
}

@end
