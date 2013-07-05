//
//  ATAPIUpdateObjectOperation.m
//  AtTaskConnector
//
//  Created by Naira Sahakyan on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ATAPIUpdateObjectOperation.h"
#import "NSMutableString+AtTaskConnector.h"

static NSString *kUpdateFields = @"updateFields";

@implementation ATAPIUpdateObjectOperation

- (id)initWithObjectCode:(NSString *)objectCode updateData:(NSDictionary *)updateData fields:(NSArray *)fields {
	return [self initWithObjectCode:objectCode updateData:updateData fields:fields
				  completionHandler:nil failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode updateData:(NSDictionary *)updateData fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler {
	return [self initWithObjectCode:objectCode updateData:updateData fields:fields completionHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode updateData:(NSDictionary *)updateData fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler {
	self = [super initWithObjectCode:objectCode fields:fields completionHandler:completionHandler
					  failureHandler:failureHandler];
	if (self) {
		[self setOperationInputValue:updateData forKey:kUpdateFields];
	}
	return self;
}

#pragma mark - Custom accessors

- (NSString *)updateData {
	return [self operationInputValueForKey:kUpdateFields];
}

- (void)setUpdateData:(NSDictionary *)updateData {
	[self setOperationInputValue:updateData forKey:kUpdateFields];
}

#pragma mark - Provide info for request creation

- (NSString *)URIQuery {
	NSMutableString *query = [[NSMutableString alloc] initWithString:[super URIQuery]];
	NSDictionary *updateData = self.updateData;
	if ([updateData count] > 0) {
		for (NSString *key in [updateData allKeys]) {
			id value = [updateData objectForKey:key];
			if (![value isKindOfClass:[NSString class]] && [value respondsToSelector:@selector(stringValue)]) {
				value = [value stringValue];
			}
			[query appendURLParameterWithName:key value:value];
		}
	}
	return [query copy];
}

- (NSString *)HTTPMethod {
	return kHTTPMethodPut;
}

@end