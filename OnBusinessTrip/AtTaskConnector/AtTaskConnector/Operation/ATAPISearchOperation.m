//
//  ATAPISearchOperation.m
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/29/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATAPISearchOperation.h"
#import "NSMutableString+AtTaskConnector.h"

static NSString *const kInputNamedQuery = @"namedQuery";
static NSString *const kInputCriteria = @"criteria";

@implementation ATAPISearchOperation

- (id)initWithObjectCode:(NSString *)objectCode namedQuery:(NSString *)namedQuery
				criteria:(NSDictionary *)criteria fields:(NSArray *)fields {
	return [self initWithObjectCode:objectCode namedQuery:namedQuery criteria:criteria fields:fields
				  completionHandler:nil failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode namedQuery:(NSString *)namedQuery
				criteria:(NSDictionary *)criteria fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler {
	return [self initWithObjectCode:objectCode namedQuery:namedQuery criteria:criteria fields:fields
				  completionHandler:completionHandler failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode namedQuery:(NSString *)namedQuery
				criteria:(NSDictionary *)criteria fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler {
	self = [super initWithObjectCode:objectCode fields:fields completionHandler:completionHandler
					  failureHandler:failureHandler];
	if (self) {
		[self setOperationInputValue:namedQuery forKey:kInputNamedQuery];
		[self setOperationInputValue:criteria forKey:kInputCriteria];
	}
	return self;
}

#pragma mark - Custom accessors

- (NSString *)namedQuery {
	return [self operationInputValueForKey:kInputNamedQuery];
}

- (void)setNamedQuery:(NSString *)namedQuery {
	[self setOperationInputValue:namedQuery forKey:kInputNamedQuery];
}

- (NSDictionary *)criteria {
	return [self operationInputValueForKey:kInputCriteria];
}

- (void)setCriteria:(NSDictionary *)criteria {
	[self setOperationInputValue:criteria forKey:kInputCriteria];
}

#pragma mark - Provide info for request creation

- (NSString *)URIPath {
	NSMutableString *path = [[NSMutableString alloc] initWithString:[super URIPath]];
	NSString *namedQuery = self.namedQuery;
	if (namedQuery) {
		[path appendFormat:@"/%@", namedQuery];
	} else {
		[path appendString:@"/search"];
	}
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