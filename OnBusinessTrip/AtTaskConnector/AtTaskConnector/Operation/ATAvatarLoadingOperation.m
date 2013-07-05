//
//  ATAvatarLoadingOperation.m
//  AtTaskConnector
//
//  Created by Naira Sahakyan on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ATAvatarLoadingOperation.h"

@interface ATAvatarLoadingOperation ()

@property (nonatomic, strong) NSDictionary *avatarSizes;

- (void)initAvatarSizes;

@end

@implementation ATAvatarLoadingOperation

@synthesize userID = _userID;
@synthesize avatarSizeType = _avatarSizeType;

@synthesize avatarSizes = _avatarSizes;

- (id)initWithUserID:(NSString *)uID avatarSize:(AvatarSizeType)size completionHandler:(ATOperationHandler)completionHandler
	  failureHandler:(ATOperationHandler)failureHandler {
	self = [super initWithCompletionHandler:completionHandler failureHandler:failureHandler];
	if (self) {
		[self initAvatarSizes];
		_userID = uID;
		_avatarSizeType = size;
	}
	return self;
}

- (NSString *)URIPath {
	return @"/attask/avatarDownload.cmd";
}

- (NSString *)URIQuery {
	NSNumber *type = [[NSNumber alloc] initWithInt:self.avatarSizeType];
	NSString *sizeType = [self.avatarSizes objectForKey:type];
	NSDate *currentDate = [[NSDate alloc] init];
	NSTimeInterval ts = [currentDate timeIntervalSince1970];
	NSString *query = [[NSString alloc] initWithFormat:@"ID=%@&time=%.0f&size=%@", self.userID, ts, sizeType];
	return query;
}

- (NSString *)HTTPMethod {
	return kHTTPMethodGet;
}

#pragma mark - Private methods

- (void)initAvatarSizes {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	NSNumber *tinySize = [[NSNumber alloc] initWithInt:ATAvatarTiny];
	[dict setObject:@"TINY" forKey:tinySize];
	NSNumber *smallSize = [[NSNumber alloc] initWithInt:ATAvatarSmall];
	[dict setObject:@"SMALL" forKey:smallSize];
	NSNumber *mediumSize = [[NSNumber alloc] initWithInt:ATAvatarMedium];
	[dict setObject:@"MEDIUM" forKey:mediumSize];
	NSNumber *largeSize = [[NSNumber alloc] initWithInt:ATAvatarLarge];
	[dict setObject:@"LARGE" forKey:largeSize];
	NSNumber *fullSize = [[NSNumber alloc] initWithInt:ATAvatarFull];
	[dict setObject:@"FULL" forKey:fullSize];
	_avatarSizes = [[NSDictionary alloc] initWithDictionary:dict];
}

@end