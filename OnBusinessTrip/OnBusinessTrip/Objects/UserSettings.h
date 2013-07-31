//
//  UserSettings.h
//  OnBusinessTrip
//
//  Created by Naira on 7/28/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserSettings : NSManagedObject

@property (nonatomic, retain) NSNumber * messageNotify;
@property (nonatomic, retain) NSNumber * newMatchNotify;
@property (nonatomic, retain) NSNumber * updateNotify;
@property (nonatomic, retain) NSNumber * userId;

@end
