//
//  ATAPILoginOperation.h
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/27/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATAPIOperation.h"

@interface ATAPILoginOperation : ATAPIOperation

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, readonly) NSDictionary *sessionAttributes;
@property (nonatomic, readonly) NSString *sessionID;

- (id)initWithUsername:(NSString *)username password:(NSString *)password;
- (id)initWithUsername:(NSString *)username password:(NSString *)password
	 completionHandler:(ATOperationHandler)completionHandler;
- (id)initWithUsername:(NSString *)username password:(NSString *)password
	 completionHandler:(ATOperationHandler)completionHandler
		failureHandler:(ATOperationHandler)failureHandler;


@end
