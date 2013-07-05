//
//  ATAPICreateObjectOperation.h
//  AtTaskConnector
//
//  Created by Mariam Hakobyan on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ATAPIObjectOperation.h"

@interface ATAPICreateObjectOperation : ATAPIObjectOperation


- (id)initWithObjectCode:(NSString *)objectCode inputData:(NSDictionary *)inputData fields:(NSArray *)fields;
- (id)initWithObjectCode:(NSString *)objectCode inputData:(NSDictionary *)inputData fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler;
- (id)initWithObjectCode:(NSString *)objectCode inputData:(id)inputData fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler;

@end
