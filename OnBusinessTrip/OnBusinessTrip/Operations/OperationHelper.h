//
//  ATOperationHelper.h
//  Insight
//
//  Created by Mariam Hakobyan on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Project;
@class User;

@interface OperationHelper : NSObject

+ (void)invokeSelector:(SEL)sel onTarget:(id)target withObject:(id)object forID:(NSString *)ID;

+ (NSManagedObject *)objectWithID:(NSManagedObjectID *)ID;
+ (NSArray *)objectsWithIDs:(NSArray *)IDs;

+ (Project *)projectWithID:(NSString *)projectID;
+ (User *)userWithID:(NSString *)userID;

@end
