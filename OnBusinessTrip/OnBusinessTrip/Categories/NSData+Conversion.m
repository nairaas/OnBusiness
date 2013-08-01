//
//  NSData+Conversion.m
//  AtTask
//
//  Created by Mikayel Aghasyan on 10/13/10.
//  Copyright 2010 AtTask. All rights reserved.
//

#import "NSData+Conversion.h"


@implementation NSData (Conversion)

+ (NSData *)dataWithString:(NSString *)val {
	return [val dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSData *)dataWithBool:(BOOL)val {
	return [NSData dataWithBytes:&val length:sizeof(BOOL)];
}

- (BOOL)boolValue {
	BOOL result;
	NSValue *val = [NSValue value:[self bytes] withObjCType:@encode(BOOL)];
	[val getValue:&result];
	return result;
}

- (id)unarchivedObjectForKey:(NSString *)key {
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:self];
	id obj = [unarchiver decodeObjectForKey:key];
	[unarchiver finishDecoding];
	return obj;
}

+ (NSData *)dataWithArchivedObject:(id)object forKey:(NSString *)key {
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:object forKey:key];
	[archiver finishEncoding];
	return data;
}

@end