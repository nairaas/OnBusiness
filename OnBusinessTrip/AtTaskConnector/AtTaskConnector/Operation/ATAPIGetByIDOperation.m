//
//  ATAPIGetByIDOperation.m
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/27/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATAPIGetByIDOperation.h"

static NSString *const kInputID = @"ID";

@implementation ATAPIGetByIDOperation

- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID {
	return [self initWithObjectCode:objectCode ID:ID fields:nil completionHandler:nil failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID
	   completionHandler:(ATOperationHandler)completionHandler {
	return [self initWithObjectCode:objectCode ID:ID fields:nil completionHandler:completionHandler failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler {
	return [self initWithObjectCode:objectCode ID:ID fields:nil completionHandler:completionHandler failureHandler:failureHandler];
}

- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID fields:(NSArray *)fields {
	return [self initWithObjectCode:objectCode ID:ID fields:fields completionHandler:nil failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler {
	return [self initWithObjectCode:objectCode ID:ID fields:fields completionHandler:completionHandler failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler {
	self = [super initWithObjectCode:objectCode fields:fields completionHandler:completionHandler failureHandler:failureHandler];
	if (self) {
		[self setOperationInputValue:ID forKey:kInputID];
	}
	return self;
}

#pragma mark - Custom accessors

- (NSString *)ID {
	return [self operationInputValueForKey:kInputID];
}

- (void)setID:(NSString *)ID {
	[self setOperationInputValue:ID forKey:kInputID];
}

#pragma mark - Provide info for request creation

- (NSString *)URIPath {
	NSMutableString *path = [[NSMutableString alloc] initWithString:[super URIPath]];
	NSString *ID = self.ID;
	if (ID) {
		[path appendFormat:@"/%@", ID];
	}
	return [path copy];
}

- (NSString *)HTTPMethod {
	return kHTTPMethodGet;
}

@end