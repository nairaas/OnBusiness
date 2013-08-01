//
//  NSData+Conversion.h
//  AtTask
//
//  Created by Mikayel Aghasyan on 10/13/10.
//  Copyright 2010 AtTask. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (Conversion)

+ (NSData *)dataWithString:(NSString *)val;
+ (NSData *)dataWithBool:(BOOL)val;

- (BOOL)boolValue;
- (id)unarchivedObjectForKey:(NSString *)key;
+ (NSData *)dataWithArchivedObject:(id)object forKey:(NSString *)key;

@end

