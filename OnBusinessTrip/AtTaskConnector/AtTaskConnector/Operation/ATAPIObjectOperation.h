//
//  ATAPIObjectOperation.h
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/28/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATAPIOperation.h"

@interface ATAPIObjectOperation : ATAPIOperation

@property (nonatomic, copy) NSString *objectCode;
@property (nonatomic, copy) NSArray *fields;

- (id)initWithObjectCode:(NSString *)objectCode;
- (id)initWithObjectCode:(NSString *)objectCode
	   completionHandler:(ATOperationHandler)completionHandler;
- (id)initWithObjectCode:(NSString *)objectCode
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler;
- (id)initWithObjectCode:(NSString *)objectCode fields:(NSArray *)fields;
- (id)initWithObjectCode:(NSString *)objectCode fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler;
- (id)initWithObjectCode:(NSString *)objectCode fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler;

@end
