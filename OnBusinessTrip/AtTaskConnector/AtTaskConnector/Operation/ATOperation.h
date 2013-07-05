//
//  ATOperation.h
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/8/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kOperationStateKeyPath;

typedef enum {
	ATOperationStateReady,
	ATOperationStateWaiting,
	ATOperationStateInProgress,
	ATOperationStateComplete,
	ATOperationStateFailed
} ATOperationState;

@class ATOperation;

typedef void (^ATOperationHandler)(ATOperation *);

@interface ATOperation : NSObject

@property (assign, nonatomic) ATOperationState operationState;
@property (copy, nonatomic) ATOperationHandler completionHandler;
@property (copy, nonatomic) ATOperationHandler failureHandler;

@property (nonatomic, copy) NSError *error;

- (id)initWithCompletionHandler:(ATOperationHandler)completionHandler;
- (id)initWithCompletionHandler:(ATOperationHandler)completionHandler failureHandler:(ATOperationHandler)failureHandler;

- (NSDictionary *)operationInput;
- (NSDictionary *)operationOutput;
- (NSDictionary *)operationDependencies;

- (id)operationInputValueForKey:(NSString *)aKey;
- (void)setOperationInputValue:(id)aValue forKey:(NSString *)aKey;

- (id)operationOutputValueForKey:(NSString *)aKey;
- (void)setOperationOutputValue:(id)aValue forKey:(NSString *)aKey;

- (NSDictionary *)operationDependencyMappingsForOperation:(ATOperation *)anOperation;
- (void)addOperationDependency:(ATOperation *)anOperation;
- (void)setOperationDependencyMappingFromOutputKeyPath:(NSString *)anOutputKeyPath
										toInputKeyPath:(NSString *)anInputKeyPath
										   onOperation:(ATOperation *)anOperation;

- (void)started;
- (void)succeeded;
- (void)failed;
- (void)reset;

@end
