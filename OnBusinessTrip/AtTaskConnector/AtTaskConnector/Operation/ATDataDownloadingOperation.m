//
//  ATDataDownloadingOperation.m
//  AtTaskConnector
//
//  Created by Naira on 11/30/12.
//
//

#import "ATDataDownloadingOperation.h"

@interface ATDataDownloadingOperation ()

@property (nonatomic, strong) NSString *HTTPMethod;
@property (nonatomic, strong) NSString *dataSourceURL;

@end

@implementation ATDataDownloadingOperation

@synthesize dataSourceURL = _dataSourceURL;
@synthesize HTTPMethod = _HTTPMethod;

- (id)initWithURL:(NSString *)url HTTPMethod:(NSString *)method completionHandler:(ATOperationHandler)completionHandler failureHandler:(ATOperationHandler)failureHandler {
	self = [super initWithCompletionHandler:completionHandler failureHandler:failureHandler];
	if (self) {
		_dataSourceURL = url;
		_HTTPMethod = method;
	}
	return self;
}

- (NSString *)URIPath {
	NSArray *comps = [self.dataSourceURL componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
	if ([comps count] > 0) {
		return [comps objectAtIndex:0];
	}
	return @"";
}

- (NSString *)HTTPMethod {
	return _HTTPMethod;
}

- (NSString *)URIQuery {
	NSArray *comps = [self.dataSourceURL componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
	if ([comps count] >= 2) {
		return [comps objectAtIndex:1];
	}
	return @"";
}

@end