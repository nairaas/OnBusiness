//
//  ATAPIObjectOperation.m
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/28/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATAPIObjectOperation.h"
#import "NSMutableString+AtTaskConnector.h"

static NSString *const kInputObjectCode = @"objCode";
static NSString *const kInputField = @"fields";

static NSString *const kParameterFields = @"fields";

@implementation ATAPIObjectOperation

- (id)initWithObjectCode:(NSString *)objectCode {
	return [self initWithObjectCode:objectCode fields:nil completionHandler:nil failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode
	   completionHandler:(ATOperationHandler)completionHandler {
	return [self initWithObjectCode:objectCode fields:nil completionHandler:completionHandler failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler {
	return [self initWithObjectCode:objectCode fields:nil completionHandler:completionHandler failureHandler:failureHandler];
}

- (id)initWithObjectCode:(NSString *)objectCode fields:(NSArray *)fields {
	return [self initWithObjectCode:objectCode fields:fields completionHandler:nil failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler {
	return [self initWithObjectCode:objectCode fields:fields completionHandler:completionHandler failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler {
	self = [super initWithCompletionHandler:completionHandler failureHandler:failureHandler];
	if (self) {
		[self setOperationInputValue:objectCode forKey:kInputObjectCode];
		[self setOperationInputValue:fields forKey:kInputField];
	}
	return self;
}

#pragma mark - Custom accessors

- (NSString *)objectCode {
	return [self operationInputValueForKey:kInputObjectCode];
}

- (void)setObjectCode:(NSString *)objectCode {
	[self setOperationInputValue:objectCode forKey:kInputObjectCode];
}

- (NSArray *)fields {
	return [self operationInputValueForKey:kInputField];
}

- (void)setFields:(NSArray *)fields {
	[self setOperationInputValue:fields forKey:kInputField];
}

#pragma mark - Provide info for request creation

- (NSString *)URIPath {
	NSMutableString *path = [[NSMutableString alloc] initWithString:[super URIPath]];
	NSString *objectCode = self.objectCode;
	if (objectCode) {
		[path appendFormat:@"/%@", objectCode];
	}
	return [path copy];
}

- (NSString *)URIQuery {
	NSMutableString *query = [[NSMutableString alloc] initWithString:[super URIQuery]];
	NSArray *fields = self.fields;
	if (fields) {
		[query appendURLParameterWithName:kParameterFields value:[fields componentsJoinedByString:@","]];
	}
	return [query copy];
}

@end