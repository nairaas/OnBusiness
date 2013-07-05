//
//  ATAPIBatchOperation.h
//  AtTaskConnector
//
//  Created by Mariam Hakobyan on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ATAPIOperation.h"

@interface ATAPIBatchOperation : ATAPIOperation

@property (nonatomic, strong) NSArray *operations;

- (id)initWithOperations:(NSArray *)operations;
- (id)initWithOperations:(NSArray *)operations completionHandler:(ATOperationHandler)completionHandler;
- (id)initWithOperations:(NSArray *)operations completionHandler:(ATOperationHandler)completionHandler failureHandler:(ATOperationHandler)failureHandler;

@end
