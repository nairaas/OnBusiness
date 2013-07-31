//
//  JSONConverter.m
//  Insight
//
//  Created by Naira Sahakyan on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ATJSONToCoreDataParser.h"
#import "OperationHelper.h"
#import "BTAppDelegate.h"
//#import "Constants.h"
//#import "Project.h"
//#import "User.h"

static NSString *kObjectTypeKey = @"objCode";
static NSString *const kAssignedToIDKey = @"assignedToID";

@interface ATJSONToCoreDataParser (Impl)

+ (NSArray *)parseArray:(NSArray *)data toManagedObjectsWithEntity:(NSEntityDescription *)entity isNewObjects:(BOOL)isNewObjects;
+ (NSManagedObject *)parseDictionary:(NSDictionary *)data toManagedObjectsWithEntity:(NSEntityDescription *)entity isNewObject:(BOOL)isNewObject;
+ (void)parseReport:(id)report withName:(NSString *)reportName forManagedObjectWithEntity:(NSEntityDescription *)entity ID:(NSString *)ID;
+ (void)fillStaticEntity:(NSEntityDescription *)entity fromArray:(NSArray *)data;

@end

@interface ATJSONToCoreDataParser ()

//+ (NSDictionary *)objectsMapping;
+ (NSEntityDescription *)entityOfObject:(NSString *)objectType;
//+ (NSArray *)filterData:(NSArray *)data forEntity:(NSEntityDescription *)entity;
//+ (NSArray *)adjustPortfoliosData:(NSArray *)portfolios;
//+ (void)deleteProjects;
//+ (void)deletePorfolios;

@end

@implementation ATJSONToCoreDataParser

+ (id)parseDictionary:(NSDictionary *)data to:(NSString *)destinationObjectType {
	BTAppDelegate *app = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
	@try {
		NSEntityDescription *entity = [ATJSONToCoreDataParser entityOfObject:destinationObjectType];
		if (entity) {
			NSManagedObject *object = [self parseDictionary:data toManagedObjectsWithEntity:entity isNewObject:NO];
			[app saveContext];
			[app.managedObjectContext reset];
			return [object objectID];
//			return object;
		}
	}
	@catch (NSException *exception) {
		NSLog(@"parseDictionary - NSException: %@", exception.description);
		[app.managedObjectContext reset];
	}
	return [NSDictionary dictionaryWithDictionary:data];
}

/*
+ (NSArray *)parseArray:(NSArray *)data isNewObjects:(BOOL)isNewObjects {
	BTAppDelegate *app = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
	@try {
		if ([data count] > 0) {
			NSDictionary *d = [data objectAtIndex:0];
			NSEntityDescription *entity = [ATJSONToCoreDataParser entityOfData:d];
			if (entity) {
				NSArray *filteredData = [ATJSONToCoreDataParser filterData:data forEntity:entity];
				NSArray *a = [self parseArray:filteredData toManagedObjectsWithEntity:entity isNewObjects:isNewObjects];
				[app saveContext];
				[app.managedObjectContext reset];
				return a;
			}
			return [NSArray arrayWithArray:data];
		}	
	}
	@catch (NSException *exception) {
		NSLog(@"parseArray - NSException: %@", exception.description);
		[app.managedObjectContext reset];
	}
	return [NSArray array];
}
 */

/*
+ (void)parseReport:(id)report withType:(ATReportType)type name:(NSString *)reportName forManagedObjectWithName:(NSString *)name ID:(NSString *)ID {
	@autoreleasepool {
		BTAppDelegate *app = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
		@try {
			NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:app.managedObjectContext];
			switch (type) {
				case ATGeneralReport:
					[self parseReport:report withName:reportName forManagedObjectWithEntity:entity ID:ID];
					break;
				case ATTrendingReport:
					[self parseTrendingReports:report withName:reportName forManagedObjectWithEntity:entity ID:ID];
					break;
				case ATHoursReport:
					[ATJSONToCoreDataParser parseHoursReport:report withName:reportName forManagedObjectWithEntity:entity ID:ID];
					break;
				default:
					break;
			}
			[app saveContext];
		}
		@catch (NSException *exception) {
			NSLog(@"parseReport - NSException: %@", exception.description);
		}
		@finally {
			[app.managedObjectContext reset];
		}
	}
}
 */

/*
+ (void)parseProjectsData:(NSArray *)data {
	@autoreleasepool {
		BTAppDelegate *app = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
		@try {
			[self deletePorfolios];
			[self deleteProjects];
			NSEntityDescription *statusEntity = [NSEntityDescription entityForName:kStatusEntityName inManagedObjectContext:app.managedObjectContext];
			NSEntityDescription *priorityEntity = [NSEntityDescription entityForName:kPriorityEntityName inManagedObjectContext:app.managedObjectContext];
			NSEntityDescription *portfolioEntity = [NSEntityDescription entityForName:kPortfolioEntityName inManagedObjectContext:app.managedObjectContext];
			NSEntityDescription *projectEntity = [NSEntityDescription entityForName:kProjectEntityName inManagedObjectContext:app.managedObjectContext];
			NSArray *statuses = [[data objectAtIndex:0] objectForKey:kReceivedDataKey];
			NSArray *priorities = [[data objectAtIndex:1] objectForKey:kReceivedDataKey];
			NSArray *portfolios = [[data objectAtIndex:2] objectForKey:kReceivedDataKey];
			NSArray *projects = [[data objectAtIndex:3] objectForKey:kReceivedDataKey];
			[self fillStaticEntity:statusEntity fromArray:statuses];
			[self fillStaticEntity:priorityEntity fromArray:priorities];
			[self parseArray:[self adjustPortfoliosData:portfolios] toManagedObjectsWithEntity:portfolioEntity isNewObjects:YES];
			[self parseArray:projects toManagedObjectsWithEntity:projectEntity isNewObjects:YES];
			[app saveContext];
		}
		@catch (NSException *exception) {
			NSLog(@"parseProjectsData - NSException: %@", exception.description);
		}
		@finally {
			[app.managedObjectContext reset];
		}
	}
}
 */

/*
+ (void)parseTasksData:(NSArray *)data forProjectWithID:(NSString *)pID {
	@autoreleasepool {
		AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		@try {
			NSArray *cTasks = [[data objectAtIndex:0] objectForKey:kReceivedDataKey];
			NSArray *uTasks = [[data objectAtIndex:1] objectForKey:kReceivedDataKey];
			NSArray *mTasks = [[data objectAtIndex:2] objectForKey:kReceivedDataKey];
			NSEntityDescription *taskEntity = [NSEntityDescription entityForName:kTaskEntityName inManagedObjectContext:app.managedObjectContext];
			NSArray *cTasksIDs = [self parseArray:cTasks toManagedObjectsWithEntity:taskEntity isNewObjects:YES];
			NSArray *uTasksIDs = [self parseArray:uTasks toManagedObjectsWithEntity:taskEntity isNewObjects:NO];
			NSArray *mTasksIDs = [self parseArray:mTasks toManagedObjectsWithEntity:taskEntity isNewObjects:NO];
			NSMutableArray *upcomingTasksIDs = [[NSMutableArray alloc] init];
			for (NSInteger i = [cTasksIDs count] - 1; i >=0; --i) {
				[upcomingTasksIDs addObject:[cTasksIDs objectAtIndex:i]];
			}
			for (id t in uTasksIDs) {
				[upcomingTasksIDs addObject:t];
			};
			Project *p = [ATOperationHelper projectWithID:pID];
			[p saveUpcomingTasksArray:[ATOperationHelper objectsWithIDs:upcomingTasksIDs]];
			[p saveMilestoneTasksArray:[ATOperationHelper objectsWithIDs:mTasksIDs]];
			[app saveContext];
		}
		@catch (NSException *exception) {
			NSLog(@"parseTasksData - NSException: %@", exception.description);
		}
		@finally {
			[app.managedObjectContext reset];
		}
	}
}
*/
/*
+ (void)parseTeamData:(NSArray *)data forProjectWithID:(NSString *)pID {
	@autoreleasepool {
		AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		@try {
			Project *p = [ATOperationHelper projectWithID:pID];
			NSDictionary *assignments = [[data objectAtIndex:0] objectForKey:kReceivedDataKey];
			NSString *ownerID = p.owner.userID;
			NSMutableSet *teamMembersSet = [[NSMutableSet alloc] init];
			BOOL containsOwner = NO;
			if ([assignments count] != 0) {
				NSDictionary *hours = [[data objectAtIndex:1] objectForKey:kReceivedDataKey];
				for (NSDictionary *assignment in [assignments allValues]) {
					NSString *assignedToID = [assignment objectForKey:kAssignedToIDKey];
					if (![assignedToID isEqual:[NSNull null]]) {
						User *user = [ATOperationHelper userWithID:assignedToID];
						if (user) {
							TeamMember *m = [ATJSONToCoreDataParser teamMemberFromUser:user assignedToID:assignedToID assignmentData:assignment hoursData:hours];
							[teamMembersSet addObject:m];
							if (!containsOwner && ownerID && [ownerID isEqualToString:assignedToID]) {
								containsOwner = YES;
							}
						} else {
							NSLog(@"Missing user info for ID: %@", assignedToID);
						}
					}
				}
			}
			if (!containsOwner && ownerID) {
				TeamMember *m = [ATJSONToCoreDataParser teamMemberFromUser:p.owner assignedToID:nil assignmentData:nil hoursData:nil];
				[teamMembersSet addObject:m];
			}
			NSArray *team = [self sortTeamMembersSet:teamMembersSet forOwnerID:ownerID];
			[p saveTeamMembersArray:team];
			[app saveContext];
		}
		@catch (NSException *exception) {
			NSLog(@"parseTeamData - NSException: %@", exception.description);
		}
		@finally {
			[app.managedObjectContext reset];
		}
	}
}
 */

#pragma mark - Private methods

/*
+ (NSDictionary *)objectsMapping {
	static NSDictionary *objMapping = nil;
	if (objMapping == nil) {
		NSArray *objects = [[NSArray alloc] initWithObjects:kProjectEntityName, kUserEntityName, kTaskEntityName, kUpdateEntityName, kDocumentEntityName, kNoteEntityName, kPortfolioEntityName, nil];
		NSArray *keys = [[NSArray alloc] initWithObjects:@"PROJ", @"USER", @"TASK", @"UPDATE", @"DOCU", @"NOTE", @"PORT", nil];
		objMapping = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	}
	return objMapping;
}
 */

+ (NSEntityDescription *)entityOfObject:(NSString *)objectType {
	BTAppDelegate *app = [[UIApplication sharedApplication] delegate];
	NSEntityDescription *entity = [NSEntityDescription entityForName:objectType
											  inManagedObjectContext:app.managedObjectContext];
	return entity;
}

/*
+ (NSArray *)filterData:(NSArray *)data forEntity:(NSEntityDescription *)entity {
	NSMutableArray *filteredData = [[NSMutableArray alloc] init];
	if ([[entity name] isEqualToString:kUpdateEntityName]) {
		for (NSDictionary *d in data) {
			if ([[d objectForKey:@"updateType"] isEqual:@"note"] &&
				[[[d objectForKey:@"updateNote"] objectForKey:@"objID"] isEqual:[NSNull null]]) {
				[filteredData addObject:d];
			}
		}
	} else {
		[filteredData addObjectsFromArray:data];
	}
	return filteredData;
}
*/

/*
+ (NSArray *)adjustPortfoliosData:(NSArray *)portfolios {
	NSMutableArray *a = [[NSMutableArray alloc] init];
	for (NSDictionary *d in portfolios) {
		NSMutableDictionary *d1 = [d mutableCopy];
		[d1 setValue:@"YES" forKey:kBelongsToBaseSetAttributeName];
		[a addObject:d1];
	}
	return a;
}
 */

/*
+ (void)deleteProjects {
	AppDelegate *app = [[UIApplication sharedApplication] delegate];
	NSFetchRequest *projectsRequest = [app.managedObjectModel fetchRequestTemplateForName:@"FetchAllProjects"];
	NSError * __autoreleasing error = nil;
	NSArray *projects = [app.managedObjectContext executeFetchRequest:projectsRequest error:&error];
	if (error) {
		NSLog(@"Fetching projects failed with error: %@", error);
	}
	for (id p in projects) {
		[app.managedObjectContext deleteObject:p];
	}
}
*/

/*
+ (void)deletePorfolios {
	AppDelegate *app = [[UIApplication sharedApplication] delegate];
	NSFetchRequest *portfoliosRequest = [app.managedObjectModel fetchRequestTemplateForName:@"FetchAllPortfolios"];
	NSError * __autoreleasing error = nil;
	NSArray *portfolios = [app.managedObjectContext executeFetchRequest:portfoliosRequest error:&error];
	if (error) {
		NSLog(@"Fetching projects failed with error: %@", error);
	}
	for (id p in portfolios) {
		[app.managedObjectContext deleteObject:p];
	}
}
 */

@end