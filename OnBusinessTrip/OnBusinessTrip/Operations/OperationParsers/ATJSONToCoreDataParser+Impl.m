//
//  ATJSONToCoreDataParser+Impl.m
//  View
//
//  Created by Mariam Hakobyan on 3/19/13.
//  Copyright (c) 2013 AtTask. All rights reserved.
//

#import "ATJSONToCoreDataParser.h"

#import "BTAppDelegate.h"
#import "Constants.h"
#import "DateUtil.h"
//#import "Priority.h"
//#import "Status.h"

#import "NSData+Conversion.h"

static NSString *const kEntityID = @"id";
static NSString *const kStatus = @"status";
static NSString *const kPriority = @"priority";

@interface ATJSONToCoreDataParser (Impl)

+ (NSArray *)parseArray:(NSArray *)data toManagedObjectsWithEntity:(NSEntityDescription *)entity isNewObjects:(BOOL)isNewObjects;
+ (NSManagedObject *)parseDictionary:(NSDictionary *)data toManagedObjectsWithEntity:(NSEntityDescription *)entity isNewObject:(BOOL)isNewObject;
+ (void)parseReport:(id)report withName:(NSString *)reportName forManagedObjectWithEntity:(NSEntityDescription *)entity ID:(NSString *)ID;
+ (void)fillStaticEntity:(NSEntityDescription *)entity fromArray:(NSArray *)data;

@end

@interface ATJSONToCoreDataParser (Impl_)

+ (NSManagedObject *)managedObjectWithEntity:(NSEntityDescription *)entity IDKey:(NSString *)key IDValue:(NSString *)IDValue shouldInsertNew:(BOOL)shouldInsertNew;

+ (void)setAttributesToManagedObject:(NSManagedObject *)object fromData:(NSDictionary *)data;
+ (void)updateManagedObject:(NSManagedObject *)object withValue:(id)value forAttribute:(NSString *)attribute
   fromAttributesDictionary:(NSDictionary *)attributes;

+ (void)setRelationShipsToManagedObject:(NSManagedObject *)object fromData:(NSDictionary *)data;
+ (void)setOneToOneRelationShip:(NSString *)relationship toManagedObject:(NSManagedObject *)object fromData:(NSDictionary *)data;
+ (void)setOneToManyRelationShip:(NSString *)relationship toManagedObject:(NSManagedObject *)object fromData:(NSDictionary *)data;

+ (void)fillPriorityEntity:(NSEntityDescription *)entity fromArray:(NSArray *)data;
+ (void)fillStatusEntity:(NSEntityDescription *)entity fromArray:(NSArray *)data;

//+ (BOOL)doesPriority:(Priority *)p containsIn:(NSArray *)array;
//+ (BOOL)doesStatus:(Status *)s containsIn:(NSArray *)array;

@end

@implementation ATJSONToCoreDataParser (Impl)

#pragma mark - Public methods

+ (NSArray *)parseArray:(NSArray *)data toManagedObjectsWithEntity:(NSEntityDescription *)entity isNewObjects:(BOOL)isNewObjects {
	NSMutableArray *a = [[NSMutableArray alloc] init];
	for (NSDictionary *d in data) {
		NSManagedObject *obj = [self parseDictionary:d toManagedObjectsWithEntity:entity isNewObject:isNewObjects];
		if (obj) {
			[a addObject:obj.objectID];
		}
	}
	return a;
}

+ (NSManagedObject *)parseDictionary:(NSDictionary *)data toManagedObjectsWithEntity:(NSEntityDescription *)entity isNewObject:(BOOL)isNewObject {
	NSManagedObject *o = nil;
	BTAppDelegate *app = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (isNewObject) {
		o = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:app.managedObjectContext];
	} else {
		NSString *IDKey = [[NSString alloc] initWithFormat:@"%@%@", [[entity name] lowercaseString], [kEntityID uppercaseString]];
		NSString *ID = [data objectForKey:kEntityID];
		if (ID) {
			o = [self managedObjectWithEntity:entity IDKey:IDKey IDValue:ID shouldInsertNew:YES];
		} else {
			NSDictionary *attributes = [entity attributesByName];
			NSArray *attributesNames = [attributes allKeys];
			if (![attributesNames containsObject:IDKey]) {
				o = [self managedObjectWithEntity:entity IDKey:nil IDValue:nil shouldInsertNew:YES];
			}
		}
	}
	if (o) {
		[self setAttributesToManagedObject:o fromData:data];
		[self setRelationShipsToManagedObject:o fromData:data];
	}
	NSLog(@"OOOO: %@", o);
	return o;
}

/*
+ (void)parseReport:(id)report withName:(NSString *)reportName forManagedObjectWithEntity:(NSEntityDescription *)entity ID:(NSString *)ID {
	if (ID) {
		NSString *IDKey = [[NSString alloc] initWithFormat:@"%@%@", [[entity name] lowercaseString], kEntityID];
		NSManagedObject *o = [self managedObjectWithEntity:entity IDKey:IDKey IDValue:ID shouldInsertNew:NO];
		if (o) {
			[o setValue:[NSData dataWithArchivedObject:report forKey:reportName] forKey:reportName];
		}
	}
}
 */

#pragma mark - Private methods

+ (NSManagedObject *)managedObjectWithEntity:(NSEntityDescription *)entity IDKey:(NSString *)key IDValue:(NSString *)IDValue shouldInsertNew:(BOOL)shouldInsertNew {
	BTAppDelegate *app = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (key) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		fetchRequest.includesPropertyValues = NO;
		[fetchRequest setEntity:entity];
		NSMutableString *strFormat = [[NSMutableString alloc] initWithFormat:@"(%@ == ", key];
		[strFormat appendString:@"%@)"];
		fetchRequest.predicate = [NSPredicate predicateWithFormat:strFormat, IDValue];
		NSError * __autoreleasing error = nil;
		NSArray *result = [app.managedObjectContext executeFetchRequest:fetchRequest error:&error];
		if (!error && 0 < [result count]) {
			return [result objectAtIndex:0];
		}
	}
	if (shouldInsertNew) {
		return [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:app.managedObjectContext];
	}
	return nil;
}

+ (void)setAttributesToManagedObject:(NSManagedObject *)object fromData:(NSDictionary *)data {
	NSDictionary *attributes = [[object entity] attributesByName];
	NSString *entityName = [[[object entity] name] lowercaseString];
	NSString *IDAttribute = [[NSString alloc] initWithFormat:@"%@%@", entityName, kEntityID];
	id value = [data objectForKey:kEntityID];
	[self updateManagedObject:object withValue:value forAttribute:IDAttribute fromAttributesDictionary:attributes];
	NSString *newAttr = nil;
	for (NSString *attribute in attributes) {
		value = [data objectForKey:attribute];
		if (nil == value && [attribute hasPrefix:entityName]) {
			newAttr = [attribute stringByReplacingOccurrencesOfString:entityName withString:@""];
			value = [data objectForKey:[newAttr lowercaseString]];
		}
		[self updateManagedObject:object withValue:value forAttribute:attribute fromAttributesDictionary:attributes];
	}
}

+ (void)updateManagedObject:(NSManagedObject *)object withValue:(id)value forAttribute:(NSString *)attribute
   fromAttributesDictionary:(NSDictionary *)attributes {
	if (nil == value || [value isKindOfClass:[NSNull class]]) {
		return;
	}
	NSAttributeDescription *attrDescription = [attributes objectForKey:attribute];
	if (nil == attrDescription) {
		return;
	}
	if ([value isKindOfClass:[NSString class]]) {
		switch ([attrDescription attributeType]) {
			case NSDateAttributeType:
				[object setValue:[DateUtil dateFromRESTAPI:value] forKey:attribute];
				break;
			case NSInteger16AttributeType:
			case NSInteger32AttributeType:
			case NSInteger64AttributeType: {
				NSNumber *n = [[NSNumber alloc] initWithInt:[value integerValue]];
				[object setValue:n forKey:attribute];
				break;
			}
			case NSDecimalAttributeType: {
				NSDecimalNumber *n = [[NSDecimalNumber alloc] initWithDecimal:[value decimalValue]];
				[object setValue:n forKey:attribute];
				break;
			}
			case NSDoubleAttributeType: {
				NSNumber *n = [[NSNumber alloc] initWithDouble:[value doubleValue]];
				[object setValue:n forKey:attribute];
				break;
			}
			case NSFloatAttributeType: {
				NSNumber *n = [[NSNumber alloc] initWithFloat:[value floatValue]];
				[object setValue:n forKey:attribute];
				break;
			}
			case NSBooleanAttributeType: {
				NSNumber *n = [[NSNumber alloc] initWithBool:[value boolValue]];
				[object setValue:n forKey:attribute];
				break;
			}
			default:
				[object setValue:value forKey:attribute];
				break;
		}
	} else if ([value isKindOfClass:[NSDictionary class]] && [attrDescription attributeType] == NSBinaryDataAttributeType) {
		[object setValue:[NSData dataWithArchivedObject:value forKey:attribute] forKey:attribute];
	} else {
		[object setValue:value forKey:attribute];
	}
}

+ (void)setRelationShipsToManagedObject:(NSManagedObject *)object fromData:(NSDictionary *)data {
	NSDictionary *relationships = [[object entity] relationshipsByName];
	NSRelationshipDescription *relDescription = nil;
	for (NSString *relationship in relationships) {
		relDescription = [relationships objectForKey:relationship];
		if ([relDescription isToMany]) {
			[self setOneToManyRelationShip:relationship toManagedObject:object fromData:data];
		} else {
			[self setOneToOneRelationShip:relationship toManagedObject:object fromData:data];
		}
	}
}

+ (void)setOneToOneRelationShip:(NSString *)relationship toManagedObject:(NSManagedObject *)object fromData:(NSDictionary *)data {
	NSDictionary *relationships = [[object entity] relationshipsByName];
	NSRelationshipDescription *relDescription = [relationships objectForKey:relationship];
	NSManagedObject *child = nil;
	if ([relationship isEqualToString:kPriority] || [relationship isEqualToString:kStatus]) {
		NSString *value = [data valueForKey:relationship];
		if (value) {
			child = [self managedObjectWithEntity:[relDescription destinationEntity] IDKey:kValueKey IDValue:value shouldInsertNew:YES];
			if ([relationship isEqualToString:kStatus] && ![child valueForKey:kValueKey]) {
				NSString *ext = [value substringFromIndex:[value length] - 2];
				if ([ext isEqualToString:kPendingApprovalStatusIdentifier] || [ext isEqualToString:kPendingIssuesStatusIdentifier]) {
					[child setValue:value forKey:kValueKey];
					NSManagedObject *st = [self managedObjectWithEntity:[relDescription destinationEntity]
																IDKey:kValueKey
															  IDValue:[value substringToIndex:[value length] - 2]
													  shouldInsertNew:YES];
					NSString *extStr = [ext isEqualToString:kPendingApprovalStatusIdentifier] ? kPendingApprovalStatusLabel : kPendingIssuesStatusLabel;
					NSString *val = [[NSString alloc] initWithFormat:@"%@ - %@", [st valueForKey:kLabelKey], extStr];
					[child setValue:val forKey:kLabelKey];
				}
			}
		}
	} else {
		NSMutableDictionary *childDictionary = [data objectForKey:relationship];
		if (childDictionary && ![childDictionary isKindOfClass:[NSNull class]]) {
			child = [self parseDictionary:childDictionary toManagedObjectsWithEntity:[relDescription destinationEntity] isNewObject:NO];
		}
	}
	if (child) {
		[object setValue:child forKey:relationship];
	}
}

+ (void)setOneToManyRelationShip:(NSString *)relationship toManagedObject:(NSManagedObject *)object fromData:(NSDictionary *)data {
	NSDictionary *relationships = [[object entity] relationshipsByName];
	NSRelationshipDescription *relDescription = [relationships objectForKey:relationship];
	id relationshipValue = [object valueForKey:relationship];
	if ([relationshipValue isKindOfClass:[NSSet class]]) {
		NSMutableSet *relationshipSet = [object mutableSetValueForKey:relationship];
		NSArray *relationshipArray = [data objectForKey:relationship];
		NSManagedObject *child = nil;
		for (NSDictionary *dict in relationshipArray) {
			child = [self parseDictionary:dict toManagedObjectsWithEntity:[relDescription destinationEntity] isNewObject:NO];
			if (child) {
				[relationshipSet addObject:child];
			}
		}
	}
}

/*

+ (void)fillStaticEntity:(NSEntityDescription *)entity fromArray:(NSArray *)data {
	if ([[entity name] isEqualToString:kPriorityEntityName]) {
		[self fillPriorityEntity:entity fromArray:data];
	} else if ([[entity name] isEqualToString:kStatusEntityName]) {
		[self fillStatusEntity:entity fromArray:data];
	}
}

+ (void)fillPriorityEntity:(NSEntityDescription *)entity fromArray:(NSArray *)data {
	AppDelegate *app = [[UIApplication sharedApplication] delegate];
	NSFetchRequest *request = [app.managedObjectModel fetchRequestTemplateForName:@"FetchAllPriorities"];
	NSError * __autoreleasing error = nil;
	NSArray *result = [app.managedObjectContext executeFetchRequest:request error:&error];
	if (!error) {
		for (Priority *p in result) {
			if (![self doesPriority:p containsIn:data]) {
				[app.managedObjectContext deleteObject:p];
			}
		}
	}
	if (data && [data count] > 0) {
		NSManagedObject *priority = nil;
		for (NSDictionary *d in data) {
			priority = [self managedObjectWithEntity:entity IDKey:kValueKey IDValue:[d valueForKey:kValueKey] shouldInsertNew:YES];
			[self setAttributesToManagedObject:priority fromData:d];
		}
	}
}

+ (void)fillStatusEntity:(NSEntityDescription *)entity fromArray:(NSArray *)data {
	AppDelegate *app = [[UIApplication sharedApplication] delegate];
	NSFetchRequest *request = [app.managedObjectModel fetchRequestTemplateForName:@"FetchAllStatuses"];
	NSError * __autoreleasing error = nil;
	NSArray *result = [app.managedObjectContext executeFetchRequest:request error:&error];
	if (!error) {
		for (Status *s in result) {
			if (![self doesStatus:s containsIn:data]) {
				[app.managedObjectContext deleteObject:s];
			}
		}
	}
	if (data && [data count] > 0) {
		NSManagedObject *status = nil;
		NSNumber *n = nil;
		for (NSDictionary *d in data) {
			status = [self managedObjectWithEntity:entity IDKey:kValueKey IDValue:[d valueForKey:kValueKey] shouldInsertNew:YES];
			n = [[NSNumber alloc] initWithBool:YES];
			[status setValue:n forKey:kBelongsToBaseSetAttributeName];
			[self setAttributesToManagedObject:status fromData:d];
		}
	}
}
 */

/*
+ (BOOL)doesPriority:(Priority *)p containsIn:(NSArray *)array {
	for (NSDictionary *d in array) {
		if ([[d valueForKey:kValueKey] isEqual:p.value]) {
			return YES;
		}
	}
	return NO;
}

+ (BOOL)doesStatus:(Status *)s containsIn:(NSArray *)array {
	for (NSDictionary *d in array) {
		if ([[d valueForKey:kValueKey] isEqual:s.value]) {
			return YES;
		}
	}
	return NO;
}
 */

@end