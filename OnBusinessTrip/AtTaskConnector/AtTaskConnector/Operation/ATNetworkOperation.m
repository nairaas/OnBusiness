//
//  ATNetworkOperation.m
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/15/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATNetworkOperation.h"

NSString *const kHTTPMethodGet = @"GET";
NSString *const kHTTPMethodPut = @"PUT";
NSString *const kHTTPMethodPost = @"POST";
NSString *const kHTTPMethodDelete = @"DELETE";
NSString *const kHTTPMethodHead = @"HEAD";

@interface ATNetworkOperation ()

@property (nonatomic, strong) NSMutableData *internalData;
@property (nonatomic, strong) NSMutableSet *redirectURLs;

@end

@implementation ATNetworkOperation

@synthesize request = _request;
@synthesize response = _response;
@synthesize connection = _connection;

@synthesize internalData = _internalData;
@synthesize redirectURLs = _redirectURLs;

@synthesize URIPath = _URIPath;

#pragma mark - Custom accessors

- (NSMutableData *)internalData {
	if (!_internalData) {
		_internalData = [[NSMutableData alloc] init];
	}
	return _internalData;
}

- (NSData *)data {
	return [self.internalData copy];
}

#pragma mark - Provide info for request creation

- (NSString *)URIPath {
	if (nil != _URIPath) {
		return [_URIPath copy];
	}
	return @"";
}

- (NSString *)URIQuery {
	return @"";
}

- (NSString *)HTTPMethod {
	return @"";
}

- (NSDictionary *)HTTPHeaders {
	return nil;
}

- (id)HTTPBody {
	return nil;
}

#pragma mark - Connection events handling

- (void)appendData:(NSData *)data {
	[self.internalData appendData:data];
}

- (NSURLRequest *)willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
	NSURL *URL = [request URL];
	if ([self.redirectURLs containsObject:URL]) {
		return nil;
	}
	[self.redirectURLs addObject:URL];
	if (response) {
		NSMutableURLRequest *newRequest = [self.request mutableCopy]; // original request
		[newRequest setURL:URL];
		return newRequest;
	} else {
		return request;
	}
}

- (void)propagateOutput {
	// TODO
}

- (void)succeeded {
	[self propagateOutput];
	self.connection = nil;
	[super succeeded];
}

- (void)failed {
	self.connection = nil;
	[super failed];
}

- (void)reset {
	self.response = nil;
	self.internalData = nil;
	self.connection = nil;
	[super reset];
}

- (BOOL)parseData:(Class)parser {
	return YES;
}

- (NSString *)HTTPHeaderForKey:(NSString *)key {
	return nil;
}

@end