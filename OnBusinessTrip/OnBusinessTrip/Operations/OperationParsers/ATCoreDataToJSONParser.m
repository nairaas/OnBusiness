//
//  ATToJSONConverter.m
//  Insight
//
//  Created by Naira Sahakyan on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ATCoreDataToJSONParser.h"

@interface ATCoreDataToJSONParser ()

+ (NSDictionary *)parseManagedObject:(NSManagedObject *)object;
+ (NSArray *)parseArray:(NSArray *)objects;

@end

@implementation ATCoreDataToJSONParser

+ (id)parseObject:(id)object {
	if ([object isKindOfClass:[NSManagedObject class]]) {
		return [ATCoreDataToJSONParser parseManagedObject:object];
	}
	if ([object isKindOfClass:[NSDictionary class]]) {
		return [[NSDictionary alloc] initWithDictionary:object];
	}
	if ([object isKindOfClass:[NSArray class]]) {
		return [ATCoreDataToJSONParser parseArray:object];
	}
	return nil;
}

#pragma mark - Private methods

+ (NSArray *)parseArray:(NSArray *)objects {
	NSMutableArray *result = [[NSMutableArray alloc] init];
	for (id object in objects) {
		if ([object isKindOfClass:[NSManagedObject class]]) {
			[result addObject:[ATCoreDataToJSONParser parseManagedObject:object]];
		} else if ([object isKindOfClass:[NSDictionary class]]) {
			NSDictionary *d = [[NSDictionary alloc] initWithDictionary:object];
			[result addObject:d];
		}
	}
	return [NSArray arrayWithArray:result];
}

+ (NSDictionary *)parseManagedObject:(NSManagedObject *)object {
	NSDictionary *attributesByName = [[object entity] attributesByName];
	NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:[object dictionaryWithValuesForKeys:[attributesByName allKeys]]];
	NSDictionary *relationshipsByName = [[object entity] relationshipsByName];
    for (NSString *relationshipName in [relationshipsByName allKeys]) {
        NSRelationshipDescription *description = [relationshipsByName objectForKey:relationshipName];
        if (![description isToMany]) {
            [result setObject:[ATCoreDataToJSONParser parseManagedObject:[object valueForKey:relationshipName]] forKey:relationshipName];
        } else {
			NSSet *relationshipObjects = [object valueForKey:relationshipName];
			NSMutableArray *relationshipArray = [[NSMutableArray alloc] init];
			for (NSManagedObject *relationshipObject in relationshipObjects) {
				[relationshipArray addObject:[ATCoreDataToJSONParser parseManagedObject:relationshipObject]];
			}
			[result setObject:relationshipArray forKey:relationshipName];
		}
    }
	return [NSDictionary dictionaryWithDictionary:result];
}

@end