//
//  ATJSONCoreDataParser.m
//  Insight
//
//  Created by Naira Sahakyan on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ATJSONCoreDataParser.h"
#import "ATJSONToCoreDataParser.h"
#import "ATCoreDataToJSONParser.h"

@implementation ATJSONCoreDataParser

+ (id)parseData:(id)data {
	id result = nil;
	if ([data isKindOfClass:[NSArray class]]) {
		// TODO: Review if isNewObjects with NO is right option, maybe we can use YES which will be faster
		result = [ATJSONToCoreDataParser parseArray:data isNewObjects:NO];
	} else if ([data isKindOfClass:[NSDictionary class]]) {
		result = [ATJSONToCoreDataParser parseDictionary:data];
	}
	return result;
}

+ (id)parseObject:(id)object {
	return [ATCoreDataToJSONParser parseObject:object];
}

@end
