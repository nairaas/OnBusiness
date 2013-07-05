//
//  ATAPIGetByIDOperation.h
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/27/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATAPIObjectOperation.h"

@interface ATAPIGetByIDOperation : ATAPIObjectOperation

@property (nonatomic, copy) NSString *ID;

- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID;
- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID
	   completionHandler:(ATOperationHandler)completionHandler;
- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler;
- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID fields:(NSArray *)fields;
- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler;
- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler;

@end
