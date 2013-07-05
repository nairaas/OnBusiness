//
//  ATOperationHelper.m
//  Insight
//
//  Created by Mariam Hakobyan on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OperationHelper.h"

//#import "Constants.h"

@implementation OperationHelper

+ (void)invokeSelector:(SEL)sel onTarget:(id)target withObject:(id)object forID:(NSString *)ID {
	if (sel != nil && target != nil && [target respondsToSelector:sel]) {
		NSMethodSignature *signature = [[target class] instanceMethodSignatureForSelector:sel];
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
		[invocation setTarget:target];
		[invocation setSelector:sel];
		if (!object) {
			object = [NSNull null];
		}
		if (signature.numberOfArguments > 3) {
			[invocation setArgument:&object atIndex:2];
			if (ID) {
				[invocation setArgument:&ID atIndex:3];
			}
		} else if (signature.numberOfArguments > 2) {
			if (ID) {
				[invocation setArgument:&ID atIndex:2];
			} else {
				[invocation setArgument:&object atIndex:2];
			}
		}
		[invocation invoke];
	}
}
/*
+ (NSManagedObject *)objectWithID:(NSManagedObjectID *)ID {
	NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	return [context objectWithID:ID];
}

+ (NSArray *)objectsWithIDs:(NSArray *)IDs {
	NSMutableArray *a = [[NSMutableArray alloc] init];
	for (NSManagedObjectID *i in IDs) {
		[a addObject:[self objectWithID:i]];
	}
	return a;
}

+ (Project *)projectWithID:(NSString *)projectID {
	AppDelegate *del = [[UIApplication sharedApplication] delegate];
	NSFetchRequest *projectRequest = [[NSFetchRequest alloc] initWithEntityName:kProjectEntityName];
	[projectRequest setPredicate:[NSPredicate predicateWithFormat:@"projectID = %@", projectID]];
	NSError * __autoreleasing error = nil;
	NSArray *result = [del.managedObjectContext executeFetchRequest:projectRequest error:&error];
	if (error) {
		NSLog(@"Fetching projects failed with error: %@", error);
	}
	if ([result count] > 0) {
		return [result objectAtIndex:0];
	}
	return nil;
}

+ (User *)userWithID:(NSString *)userID {
	AppDelegate *del = [[UIApplication sharedApplication] delegate];
	NSFetchRequest *userRequest = [[NSFetchRequest alloc] initWithEntityName:kUserEntityName];
	[userRequest setPredicate:[NSPredicate predicateWithFormat:@"userID = %@", userID]];
	NSError * __autoreleasing error = nil;
	NSArray *result = [del.managedObjectContext executeFetchRequest:userRequest error:&error];
	if (error) {
		NSLog(@"Fetching projects failed with error: %@", error);
	}
	if ([result count] > 0) {
		return [result objectAtIndex:0];
	}
	return nil;
}
*/

@end