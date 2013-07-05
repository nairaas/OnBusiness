//
//  ATAPIReportOperation.m
//  AtTaskConnector
//
//  Created by Mariam Hakobyan on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ATAPIReportOperation.h"
#import "NSMutableString+AtTaskConnector.h"

@implementation ATAPIReportOperation

static NSString *const kInputCriteria = @"criteria";

- (id)initWithObjectCode:(NSString *)objectCode criteria:(NSDictionary *)criteria fields:(NSArray *)fields {
	return [self initWithObjectCode:objectCode criteria:criteria fields:fields completionHandler:nil failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode criteria:(NSDictionary *)criteria fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler {
	return [self initWithObjectCode:objectCode criteria:criteria fields:fields completionHandler:completionHandler failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode criteria:(NSDictionary *)criteria fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler {
	self = [super initWithObjectCode:objectCode fields:nil completionHandler:completionHandler failureHandler:failureHandler];
	if (self) {
		[self setOperationInputValue:criteria forKey:kInputCriteria];
	}
	return self;
}

#pragma mark - Custom accessors

- (NSDictionary *)criteria {
	return [self operationInputValueForKey:kInputCriteria];
}

- (void)setCriteria:(NSDictionary *)criteria {
	[self setOperationInputValue:criteria forKey:kInputCriteria];
}

#pragma mark - Provide info for request creation

- (NSString *)URIPath {
	NSMutableString *path = [[NSMutableString alloc] initWithString:[super URIPath]];
	[path appendString:@"/report"];
	return [path copy];
}

- (NSString *)URIQuery {
	NSMutableString *query = [[NSMutableString alloc] initWithString:[super URIQuery]];
	NSDictionary *criteria = self.criteria;
	if ([criteria count] > 0) {
		for (NSString *key in [criteria allKeys]) {
			id value = [criteria objectForKey:key];
			[query appendURLParameterWithName:key value:value];
		}
	}
	return [query copy];
}

- (NSString *)HTTPMethod {
	return kHTTPMethodGet;
}

@end
