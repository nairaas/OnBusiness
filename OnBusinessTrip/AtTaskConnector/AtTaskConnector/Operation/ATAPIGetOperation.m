//
//  ATAPIObjectOperation.m
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/28/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATAPIGetOperation.h"
#import "NSMutableString+AtTaskConnector.h"

//static NSString *const kInputObjectCode = @"objCode";
//static NSString *const kInputField = @"fields";
//
//static NSString *const kParameterFields = @"fields";

@implementation ATAPIGetOperation

- (id)initWithURIPath:(NSString *)path {
	return [self initWithURIPath:path query:nil completionHandler:nil failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)path
	   completionHandler:(ATOperationHandler)completionHandler {
	return [self initWithURIPath:path query:nil completionHandler:completionHandler failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)path
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler {
	return [self initWithURIPath:path query:nil completionHandler:completionHandler failureHandler:failureHandler];
}

- (id)initWithObjectCode:(NSString *)path query:(id)query {
	return [self initWithURIPath:path query:query completionHandler:nil failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)path query:(id)query
	   completionHandler:(ATOperationHandler)completionHandler {
	return [self initWithURIPath:path query:query completionHandler:completionHandler failureHandler:nil];
}

- (id)initWithURIPath:(NSString *)path query:(id)query
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler {
	self = [super initWithURIPath:path completionHandler:completionHandler failureHandler:failureHandler];
	if (self) {
		[self setInputData:query];
	}
	return self;
}

#pragma mark - Custom accessors

//- (NSString *)objectCode {
//	return [self operationInputValueForKey:kInputObjectCode];
//}

//- (void)setObjectCode:(NSString *)objectCode {
//	[self setOperationInputValue:objectCode forKey:kInputObjectCode];
//}

//- (NSArray *)fields {
//	return [self operationInputValueForKey:kInputField];
//}

//- (void)setFields:(NSArray *)fields {
//	[self setOperationInputValue:fields forKey:kInputField];
//}

#pragma mark - Provide info for request creation

//- (NSString *)URIPath {
//	NSMutableString *path = [[NSMutableString alloc] initWithString:[super URIPath]];
//	NSString *objectCode = self.objectCode;
//	if (objectCode) {
//		[path appendFormat:@"/%@", objectCode];
//	}
//	return [_URIPath copy];
//}

- (NSString *)URIQuery {
	NSMutableString *query = [[NSMutableString alloc] initWithString:[super URIQuery]];
//	NSArray *fields = self.fields;
	if (self.inputData) {
		[query appendURLParameterWithName:nil value:self.inputData];
	}
	return [query copy];
}

@end