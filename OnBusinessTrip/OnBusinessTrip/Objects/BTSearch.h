//
//  BTSearch.h
//  OnBusinessTrip
//
//  Created by Naira on 6/8/13.
//
//

#import <Foundation/Foundation.h>

@interface BTSearch : NSObject

@property (nonatomic, assign) NSInteger ageFrom;
@property (nonatomic, assign) NSInteger ageTo;
@property (nonatomic, assign, getter = datingEnabled) BOOL dating;
@property (nonatomic, assign, getter = socialEnabled) BOOL social;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger userID;

+ (BTSearch *)getInstance;
- (void)defaultSearch;

@end
