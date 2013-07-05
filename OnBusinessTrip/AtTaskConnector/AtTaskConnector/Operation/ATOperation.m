//
//  ATOperation.m
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/8/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATOperation.h"

NSString *const kOperationStateKeyPath = @"operationState";

@interface ATOperation ()

@property (strong, nonatomic) NSMutableDictionary *internalOperationInput;
@property (strong, nonatomic) NSMutableDictionary *internalOperationOutput;
@property (strong, nonatomic) NSMutableDictionary *internalOperationDependencies;

- (void)adjustOperationState;
- (void)propagateInputsFromOperation:(ATOperation *)anOperation;
- (void)removeOperationDependency:(ATOperation *)anOperation;

@end

@implementation ATOperation

@synthesize operationState = _operationState;
@synthesize completionHandler = _completionHandler;
@synthesize failureHandler = _failureHandler;

@synthesize internalOperationInput = _internalOperationInput;
@synthesize internalOperationOutput = _internalOperationOutput;
@synthesize internalOperationDependencies = _internalOperationDependencies;

@synthesize error = _error;

- (id)init {
	return [self initWithCompletionHandler:nil failureHandler:nil];
}

- (id)initWithCompletionHandler:(ATOperationHandler)completionHandler {
	return [self initWithCompletionHandler:completionHandler failureHandler:nil];
}

- (id)initWithCompletionHandler:(ATOperationHandler)completionHandler failureHandler:(ATOperationHandler)failureHandler {
	self = [super init];
	if (self) {
		_operationState = ATOperationStateReady;
		_completionHandler = completionHandler;
		_failureHandler = failureHandler;
	}
	return self;
}

- (NSMutableDictionary *)internalOperationInput {
	if (!_internalOperationInput) {
		_internalOperationInput = [[NSMutableDictionary alloc] init];
	}
	return _internalOperationInput;
}

- (NSMutableDictionary *)internalOperationOutput {
	if (!_internalOperationOutput) {
		_internalOperationOutput = [[NSMutableDictionary alloc] init];
	}
	return _internalOperationOutput;
}

- (NSMutableDictionary *)internalOperationDependencies {
	if (!_internalOperationDependencies) {
		_internalOperationDependencies = [[NSMutableDictionary alloc] init];
	}
	return _internalOperationDependencies;
}

- (NSDictionary *)operationInput {
	return [self.internalOperationInput copy];
}

- (NSDictionary *)operationOutput {
	return [self.internalOperationOutput copy];
}

- (NSDictionary *)operationDependencies {
	return [self.internalOperationDependencies copy];
}

- (id)operationInputValueForKey:(NSString *)aKey {
	if (aKey) {
		return [self.internalOperationInput objectForKey:aKey];
	}
	return nil;
}

- (void)setOperationInputValue:(id)aValue forKey:(NSString *)aKey {
	if (aKey && aValue) {
		[self.internalOperationInput setObject:aValue forKey:aKey];
	}
}

- (id)operationOutputValueForKey:(NSString *)aKey {
	if (aKey) {
		return [self.internalOperationOutput objectForKey:aKey];
	}
	return nil;
}

- (void)setOperationOutputValue:(id)aValue forKey:(NSString *)aKey {
	if (aKey && aValue) {
		[self.internalOperationOutput setObject:aValue forKey:aKey];
	}
}

- (NSDictionary *)operationDependencyMappingsForOperation:(ATOperation *)anOperation {
	if (anOperation) {
		NSValue *key = [NSValue valueWithNonretainedObject:anOperation];
		NSMutableDictionary *mappings = [self.internalOperationDependencies objectForKey:key];
		if (mappings) {
			return [mappings copy];
		}
	}
	return nil;
}

- (void)addOperationDependency:(ATOperation *)anOperation {
	if (anOperation) {
		NSValue *key = [NSValue valueWithNonretainedObject:anOperation];
		NSMutableDictionary *mappings = [self.internalOperationDependencies objectForKey:key];
		if (!mappings) {
			NSMutableDictionary *dependencies = [[NSMutableDictionary alloc] init];
			[self.internalOperationDependencies setObject:dependencies forKey:key];
			[anOperation addObserver:self forKeyPath:kOperationStateKeyPath options:NSKeyValueObservingOptionInitial context:NULL];
		}
	}
}

- (void)setOperationDependencyMappingFromOutputKeyPath:(NSString *)anOutputKeyPath
										toInputKeyPath:(NSString *)anInputKeyPath
										   onOperation:(ATOperation *)anOperation {
	if (anOutputKeyPath && anInputKeyPath && anOperation) {
		NSValue *key = [NSValue valueWithNonretainedObject:anOperation];
		[self addOperationDependency:anOperation];
		NSMutableDictionary *mappings = [self.internalOperationDependencies objectForKey:key];
		NSMutableArray *outputMappings = [mappings objectForKey:anOutputKeyPath];
		if (!outputMappings) {
			outputMappings = [[NSMutableArray alloc] init];
			[mappings setObject:outputMappings forKey:anOutputKeyPath];
		}
		[outputMappings addObject:anInputKeyPath];
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:kOperationStateKeyPath] && [object isKindOfClass:[ATOperation class]]) {
		//[self adjustOperationState];
		ATOperation *anOperation = (ATOperation *)object;
		if (anOperation.operationState > ATOperationStateInProgress) {
			[self adjustOperationState];
			if (anOperation.operationState == ATOperationStateComplete) {
				[self propagateInputsFromOperation:anOperation];
			}
			[self removeOperationDependency:anOperation];
		}
	}
//	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)adjustOperationState {
	if (self.operationState < ATOperationStateInProgress) {
		ATOperationState newState = ATOperationStateReady;
		for (NSValue *key in [self.internalOperationDependencies allKeys]) {
			ATOperation *anOperation = [key nonretainedObjectValue];
			if (anOperation.operationState < ATOperationStateComplete) {
				newState = ATOperationStateWaiting;
				break;
			} else if (anOperation.operationState == ATOperationStateFailed) {
				self.error = anOperation.error;
				[self failed];
				return;
			}
		}
		self.operationState = newState;
	}
}

- (void)propagateInputsFromOperation:(ATOperation *)anOperation {
	NSValue *key = [NSValue valueWithNonretainedObject:anOperation];
	NSDictionary *mappings = [self.internalOperationDependencies objectForKey:key];
	NSDictionary *anOutput = nil;
	id aValue = nil;
	for (NSString *anOutputKeyPath in [mappings allKeys]) {
		anOutput = [anOperation operationOutput];
		aValue = [anOutput valueForKeyPath:anOutputKeyPath];
		if (aValue) {
			for (NSString *anInputKeyPath in [mappings objectForKey:anOutputKeyPath]) {
				[self.internalOperationInput setValue:aValue forKeyPath:anInputKeyPath];
			}
		}
	}
}

- (void)removeOperationDependency:(ATOperation *)anOperation {
	NSValue *key = [NSValue valueWithNonretainedObject:anOperation];
	[anOperation removeObserver:self forKeyPath:kOperationStateKeyPath];
	[self.internalOperationDependencies removeObjectForKey:key];
}

- (void)started {
	self.operationState = ATOperationStateInProgress;
}

- (void)succeeded {
	self.operationState = ATOperationStateComplete;
	if (self.completionHandler) {
		self.completionHandler(self);
	}
}

- (void)failed {
	self.operationState = ATOperationStateFailed;
	if (self.failureHandler) {
		self.failureHandler(self);
	}
}

- (void)reset {
	self.error = nil;
	[self.internalOperationOutput removeAllObjects];
	self.operationState = ATOperationStateReady;
	[self adjustOperationState];
}

@end
