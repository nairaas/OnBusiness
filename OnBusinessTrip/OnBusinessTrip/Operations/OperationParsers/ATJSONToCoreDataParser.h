//
//  JSONConverter.h
//  Insight
//
//  Created by Naira Sahakyan on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	ATGeneralReport,
	ATTrendingReport,
	ATHoursReport
} ATReportType;

@interface ATJSONToCoreDataParser : NSObject

+ (id)parseDictionary:(NSDictionary *)data;
+ (NSArray *)parseArray:(NSArray *)data isNewObjects:(BOOL)isNewObjects;
+ (void)parseReport:(id)report withType:(ATReportType)type name:(NSString *)reportName forManagedObjectWithName:(NSString *)name ID:(NSString *)ID;
+ (void)parseProjectsData:(NSArray *)data;
+ (void)parseTasksData:(NSArray *)data forProjectWithID:(NSString *)pID;
+ (void)parseTeamData:(NSArray *)data forProjectWithID:(NSString *)pID;

@end