//
//  ATDataParser.h
//  AtTaskConnector
//
//  Created by Naira Sahakyan on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATDataParser : NSObject

/**
 * Parses @param data to an object and returns created object
 * Default implementation returns a copy of @param data
 */
+ (id)parseData:(id)data to:(NSString *)destinationObjectType;

/**
 * Creates a data representation of @param object and returns it
 * Default implementation returns a copy of @param object
 */
+ (id)parseObject:(id)object;

@end
