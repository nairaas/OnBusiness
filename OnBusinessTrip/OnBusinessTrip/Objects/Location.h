//
//  Location.h
//  OnBusinessTrip
//
//  Created by Naira on 7/28/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * state;

@end
