//
//  ATAPIDeleteObjectOperation.m
//  AtTaskConnector
//
//  Created by Mariam Hakobyan on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ATAPIDeleteObjectOperation.h"
#import "NSMutableString+AtTaskConnector.h"

static NSString *const kInputID = @"ID";
static NSString *const kForceDelete = @"force";

@implementation ATAPIDeleteObjectOperation

- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID force:(BOOL) force {
	return [self initWithObjectCode:objectCode ID:ID force:force completionHandler:nil failureHandler:nil];
}
- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID force:(BOOL) force
	   completionHandler:(ATOperationHandler)completionHandler {
	return [self initWithObjectCode:objectCode ID:ID force:force completionHandler:completionHandler failureHandler:nil];
}
- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID force:(BOOL) force
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler {
	self = [super initWithObjectCode:objectCode fields:nil completionHandler:completionHandler failureHandler:failureHandler];
	if (self) {
		[self setOperationInputValue:ID forKey:kInputID];
		NSNumber *n = [[NSNumber alloc] initWithBool:force];
		[self setOperationInputValue:n forKey:kForceDelete];
	}
	return self;
}

#pragma mark - Custom accessors

- (NSString *)ID {
	return [self operationInputValueForKey:kInputID];
}

- (void)setID:(NSString *)ID {
	[self setOperationInputValue:ID forKey:kInputID];
}
		 
- (BOOL)force {
	return [[self operationInputValueForKey:kForceDelete] boolValue];
}

- (void)setForce:(BOOL)force {
	NSNumber *n = [[NSNumber alloc] initWithBool:force];
	[self setOperationInputValue:n forKey:kForceDelete];
}

#pragma mark - Provide info for request creation

- (NSString *)URIPath {
	NSMutableString *path = [[NSMutableString alloc] initWithString:[super URIPath]];
	NSString *ID = self.ID;
	if (ID) {
		[path appendFormat:@"/%@", ID];
	}
	return [path copy];
}

- (NSString *)URIQuery {
	NSMutableString *query = [[NSMutableString alloc] initWithString:[super URIQuery]];
	if (self.force) {
		[query appendURLParameterWithName:@"force" value:@"true"];
	}
	return [query copy];
}

- (NSString *)HTTPMethod {
	return kHTTPMethodDelete;
}

@end