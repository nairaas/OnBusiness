//
//  ATAPIBatchOperation.m
//  AtTaskConnector
//
//  Created by Mariam Hakobyan on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ATAPIBatchOperation.h"
#import "NSMutableString+AtTaskConnector.h"

static NSString *const kInputOperations = @"operations";

@implementation ATAPIBatchOperation

- (id)initWithOperations:(NSArray *)operations {
	return [self initWithOperations:operations completionHandler:nil failureHandler:nil];
}

- (id)initWithOperations:(NSArray *)operations completionHandler:(ATOperationHandler)completionHandler {
	return [self initWithOperations:operations completionHandler:completionHandler failureHandler:nil];
}

- (id)initWithOperations:(NSArray *)operations completionHandler:(ATOperationHandler)completionHandler failureHandler:(ATOperationHandler)failureHandler {
	self = [super initWithCompletionHandler:completionHandler failureHandler:failureHandler];
	if (self) {
		[self setOperationInputValue:operations forKey:kInputOperations];
	}
	return self;
}

#pragma mark - Custom accessors

- (NSArray *)operations {
	return [self operationInputValueForKey:kInputOperations];
}

- (void)setOperations:(NSArray *)operations {
	[self setOperationInputValue:operations	forKey:kInputOperations];
}

#pragma mark - Provide info for request creation

- (NSString *)URIPath {
	NSMutableString *path = [[NSMutableString alloc] initWithString:[super URIPath]];
	[path appendString:@"/batch"];
	return [path copy];
}

- (NSString *)URIQuery {
	NSMutableString *query = [[NSMutableString alloc] initWithString:[super URIQuery]];
	NSArray *operations = self.operations;
	NSString *uri = nil;
	for (ATAPIOperation *op in operations) {
		uri = [[NSString alloc] initWithFormat:@"%@?%@", [op URIPath], [op URIQuery]];
		[query appendURLParameterWithName:@"uri" value:uri];
	}
	return [query copy];
}

- (NSString *)HTTPMethod {
	return kHTTPMethodGet;
}

@end