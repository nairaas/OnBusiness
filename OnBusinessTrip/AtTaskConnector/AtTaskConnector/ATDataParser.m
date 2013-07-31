//
//  ATDataParser.m
//  AtTaskConnector
//
//  Created by Naira Sahakyan on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ATDataParser.h"

@implementation ATDataParser

+ (id)parseData:(id)data to:(NSString *)destinationObjectType {
	return [data copy];
}

+ (id)parseObject:(id)object {
	return [NSDictionary dictionary];
}

@end
