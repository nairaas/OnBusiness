//
//  Trip.h
//  OnBusinessTrip
//
//  Created by Naira on 7/28/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Trip : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * locationId;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * tripID;
@property (nonatomic, retain) NSNumber * userId;

@end
