//
//  ATAPICreateObjectOperation.m
//  AtTaskConnector
//
//  Created by Naira Sahakyan on 21/06/13.
//

#import "ATAPIPostOperation.h"
#import "NSMutableString+AtTaskConnector.h"


@implementation ATAPIPostOperation

- (id)initWithURIPath:(NSString *)path inputData:(NSDictionary *)inputData {
	return [self initWithURIPath:path inputData:inputData
			   completionHandler:nil failureHandler:nil];
}

- (id)initWithURIPath:(NSString *)path inputData:(NSDictionary *)inputData
	completionHandler:(ATOperationHandler)completionHandler {
	return [self initWithURIPath:path inputData:inputData completionHandler:completionHandler failureHandler:nil];
}

- (id)initWithURIPath:(NSString *)path inputData:(id)inputData
	completionHandler:(ATOperationHandler)completionHandler
	   failureHandler:(ATOperationHandler)failureHandler {
	self = [super initWithURIPath:path completionHandler:completionHandler failureHandler:failureHandler];
	if (self) {
		[self setInputData:inputData];
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