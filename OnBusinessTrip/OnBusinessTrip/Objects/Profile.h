//
//  Profile.h
//  OnBusinessTrip
//
//  Created by Naira on 7/28/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Profile : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSDate * birthDate;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * occupation;
@property (nonatomic, retain) NSNumber * profileID;
@property (nonatomic, retain) NSNumber * locationId;

@end
