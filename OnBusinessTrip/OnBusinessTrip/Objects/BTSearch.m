//
//  BTSearch.m
//  OnBusinessTrip
//
//  Created by Naira on 6/8/13.
//
//

#import "BTSearch.h"

@implementation BTSearch

@synthesize ageFrom = _ageFrom;
@synthesize ageTo = _ageTo;
@synthesize dating = _dating;
@synthesize social = _social;
@synthesize gender = _gender;
@synthesize userID = _userID;

+ (BTSearch *)getInstance {
    static BTSearch *instance = nil;
    if (!instance) {
        @synchronized(instance) {
            instance = [[BTSearch alloc] init];
        }
    }
    return instance;
}

- (void)defaultSearch {
    self.ageFrom = 18;
    self.ageTo = 65;
    self.dating = YES;
    self.social = YES;
    self.gender = 1;
}

@end
