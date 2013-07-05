//
//  NSMutableString+AtTaskConnector.h
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/28/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (AtTaskConnector)

- (void)appendURLParameterWithName:(NSString *)name value:(id)value;
- (NSString *)URLEncodeValue:(NSString *)value;

@end
