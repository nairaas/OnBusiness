//
//  ATNetworkOperationManager.h
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/15/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	ATServiceAuthenticationMethodHeader,
	ATServiceAuthenticationMethodParameter
} ATServiceAuthenticationMethod;

@class ATNetworkOperation;

typedef void (^ATNetworkOperationCompletionHandler)();

@interface ATNetworkOperationManager : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

//@property (nonatomic, copy) NSString *sessionID;
@property (nonatomic, copy) NSString *serviceHost;
@property (nonatomic, readonly) NSString *normalizedServiceHost;

@property (nonatomic, assign) ATServiceAuthenticationMethod authenticationMethod;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, assign) BOOL usePostForAPI;
@property (nonatomic, copy) NSString *systemLanguage;
@property (nonatomic, copy) NSString *userAgent;

@property (nonatomic, copy) NSString *apiPath;
@property (nonatomic, copy) NSString *apiVersion;

@property (nonatomic, assign) Class dataParser;

- (void)submitNetworkOperation:(ATNetworkOperation *)operation;

@end
