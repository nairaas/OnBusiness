//
//  ATNetworkOperation.h
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/15/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATOperation.h"

extern NSString *const kHTTPMethodGet;
extern NSString *const kHTTPMethodPut;
extern NSString *const kHTTPMethodPost;
extern NSString *const kHTTPMethodDelete;
extern NSString *const kHTTPMethodHead;

@interface ATNetworkOperation : ATOperation

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, readonly) NSData *data;
@property (nonatomic, strong) NSURLConnection *connection;

- (NSString *)URIPath;
- (NSString *)URIQuery;
- (NSString *)HTTPMethod;
- (NSDictionary *)HTTPHeaders;
- (id)HTTPBody;

- (void)appendData:(NSData *)data;
- (NSURLRequest *)willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response;

- (void)propagateOutput;

- (BOOL)parseData:(Class)parser;

- (NSString *)HTTPHeaderForKey:(NSString *)key;

@end