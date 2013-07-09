//
//  ATAPICreateObjectOperation.m
//  AtTaskConnector
//
//  Created by Mariam Hakobyan on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ATAPICreateObjectOperation.h"
#import "NSMutableString+AtTaskConnector.h"


@implementation ATAPICreateObjectOperation

- (id)initWithObjectCode:(NSString *)objectCode inputData:(NSDictionary *)inputData fields:(NSArray *)fields {
	return [self initWithObjectCode:objectCode inputData:inputData fields:fields
				  completionHandler:nil failureHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode inputData:(NSDictionary *)inputData fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler {
	return [self initWithObjectCode:objectCode inputData:inputData fields:fields completionHandler:nil];
}

- (id)initWithObjectCode:(NSString *)objectCode inputData:(id)inputData fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler {
	self = [super initWithObjectCode:objectCode fields:fields completionHandler:completionHandler
					  failureHandler:failureHandler];
	if (self) {
		[self setOperationInputValue:inputData forKey:kInputFields];
	}
	return self;
}


#pragma mark - Provide info for request creation

- (NSString *)URIQuery {
/*	NSMutableString *query = [[NSMutableString alloc] initWithString:[super URIQuery]];
	NSDictionary *inputData = self.inputData;
	if ([inputData count] > 0) {
		for (NSString *key in [inputData allKeys]) {
			id value = [inputData objectForKey:key];
			if (![value isKindOfClass:[NSString class]] && [value respondsToSelector:@selector(stringValue)]) {
				value = [value stringValue];
			}
			[query appendURLParameterWithName:key value:value];
		}
	}
	return [query copy];
 */
    return @"";
}

- (NSString *)HTTPMethod {
	return kHTTPMethodPost;
}

- (id)HTTPBody {
	return [NSJSONSerialization dataWithJSONObject:self.inputData options:0 error:nil];
}

@end