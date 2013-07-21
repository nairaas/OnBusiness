//
//  ATAPIOperation.h
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/26/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATNetworkOperation.h"

extern NSString *const kOutputData;

extern NSString *const kInputFields;

@interface ATAPIOperation : ATNetworkOperation

@property (nonatomic, strong) id inputData;
@property (nonatomic, strong) id output;

- (id)initWithURIPath:(NSString *)path completionHandler:(ATOperationHandler)completionHandler;
- (id)initWithURIPath:(NSString *)path completionHandler:(ATOperationHandler)completionHandler failureHandler:(ATOperationHandler)failureHandler;

@end
