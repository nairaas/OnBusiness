//
//  Search.h
//  OnBusinessTrip
//
//  Created by Naira on 7/28/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Search : NSManagedObject

@property (nonatomic, retain) NSNumber * ageFrom;
@property (nonatomic, retain) NSNumber * ageTo;
@property (nonatomic, retain) NSNumber * dating;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSNumber * userId;

@end
