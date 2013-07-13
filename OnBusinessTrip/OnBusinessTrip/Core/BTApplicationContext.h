//
//  BTApplicationContext.h
//  OnBusinessTrip
//
//  Created by Naira on 7/13/13.
//
//

#import <Foundation/Foundation.h>

@interface BTApplicationContext : NSObject

@property (nonatomic, strong) NSString *guestUsername;
@property (nonatomic, strong) NSString *guestPassword;

+ (BTApplicationContext *)sharedInstance;

@end
