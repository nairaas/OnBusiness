//
//  BTApplicationContext.m
//  OnBusinessTrip
//
//  Created by Naira on 7/13/13.
//
//

#import "BTApplicationContext.h"

@implementation BTApplicationContext

@synthesize guestUsername = _guestUsername;
@synthesize guestPassword = _guestPassword;

@synthesize loggedIn = _loggedIn;

- (id)init {
	self = [super init];
	if (self) {
		_guestUsername = @"mobile-client";
		_guestPassword = @"0btpa$$w0rd";
		_loggedIn = NO;
	}
	return self;
}

+ (BTApplicationContext *)sharedInstance {
    static BTApplicationContext *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BTApplicationContext alloc] init];
    });
    return instance;
}

@end
