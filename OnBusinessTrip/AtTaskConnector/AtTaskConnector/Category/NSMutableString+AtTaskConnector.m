//
//  NSMutableString+AtTaskConnector.m
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/28/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "NSMutableString+AtTaskConnector.h"

@implementation NSMutableString (AtTaskConnector)

- (void)appendURLParameterWithName:(NSString *)name value:(id)value {
	if ([name isEqualToString:@"updates"] && [value isKindOfClass:[NSDictionary class]]) {
		NSError *error = nil;
		NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value options:0 error:&error];
		if (error) {
			NSLog(@"Error creating JSON Updates: %@", error.localizedDescription);
			return;
		}
		NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
		[self appendURLParameterWithName:name value:jsonString];
	}
	if ([value isKindOfClass:[NSArray class]]) {
		for (id item in (NSArray *)value) {
			[self appendURLParameterWithName:name value:item];
		}
	} else if ([value isKindOfClass:[NSString class]]) {
		if ([self length] > 0) {
			[self appendString:@"&"];
		}
		[self appendFormat:@"%@=%@", name, [self URLEncodeValue:value]];
	}
}

- (NSString *)URLEncodeValue:(NSString *)value {
	CFStringRef legalChars = CFSTR("!*'();:@&=+$,/?#[]");
	CFStringRef encodedValue = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)value, NULL, legalChars, kCFStringEncodingUTF8);
	NSString *result = (__bridge_transfer NSString *)encodedValue;
	//CFRelease(encodedValue);
	return result;
}

@end
