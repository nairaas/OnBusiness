//
//  ColorUtil.m
//  AtTask
//
//  Created by Mikayel Aghasyan on 11/18/10.
//  Copyright 2010 AtTask. All rights reserved.
//

#import "ColorUtil.h"

static const CGFloat kMaxColorValue = 255.0;

@implementation ColorUtil

+ (UIColor *)colorWithWhite:(int)white {
	double w = (double)white / kMaxColorValue;
	return [UIColor colorWithWhite:w alpha:1];
}

+ (UIColor *)colorWithRed:(int)red withGreen:(int)green withBlue:(int)blue {
	double r = (double)red / kMaxColorValue;
	double g = (double)green / kMaxColorValue;
	double b = (double)blue / kMaxColorValue;
	return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

+ (NSString *)redBarStartColor {
	return @"D62727";
}

+ (NSString *)redBarEndColor {
	return @"EB3C3C";
}

+ (NSString *)redBarStrokeColor {
	return @"ED6969";
}

+ (NSString *)yellowBarStartColor {
	return @"E6BE33";	
}

+ (NSString *)yellowBarEndColor {
	return @"EDCD4D";
}

+ (NSString *)yellowBarStrokeColor {
	return @"F4E382";
}

+ (NSString *)greenBarStartColor {
	return @"88C934";
}
+ (NSString *)greenBarEndColor {
	return @"A1E34A";
}

+ (NSString *)greenBarStrokeColor {
	return @"C1EE75";
}

+ (NSString *)orangeBarStartColor {
	return @"F49835";
}

+ (NSString *)orangeBarEndColor {
	return @"FCAC56";
}

+ (NSString *)orangeBarStrokeColor {
	return @"FFC070";
}

+ (NSString *)purpleBarStartColor {
	return @"9346B7";
}

+ (NSString *)purpleBarEndColor {
	return @"A860C9";
}

+ (NSString *)purpleBarStrokeColor {
	return @"B687CA";
}

+ (NSString *)blueBarStartColor {
	return @"398CBF";
}

+ (NSString *)blueBarEndColor {
	return @"60ADF9";
}

+ (NSString *)blueBarStrokeColor {
	return @"77C1D8";
}

+ (NSString *)darkOrangeBarStartColor {
	return @"F49D36";
}

+ (NSString *)darkOrangeBarEndColor {
	return @"FFB054";
}

+ (NSString *)darkOrangeBarStrokeColor {
	return @"FFC274";
}

+ (NSString *)darkBlueBarEndColor {
	return @"60AFD9";
}

+ (NSString *)greyBarColor {
	return @"484848";
}

+ (NSString *)greyBarStrokeColor {
	return @"D9D9D9";
}

+ (UIColor *)avatarBorderColor {
	return [ColorUtil colorWithRed:141 withGreen:152 withBlue:156];
//	return [ColorUtil colorWithRed:111 withGreen:123 withBlue:128];
}

+ (UIColor *)unassignedAvatarBorderColor {
	return [ColorUtil colorWithRed:125 withGreen:133 withBlue:137];
}


+ (UIColor *)blankAvatarBorderColor {
	return [ColorUtil colorWithRed:181 withGreen:196 withBlue:202];
}

@end

@implementation UIColor(HexString)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha = 0;
	CGFloat red = 0;
	CGFloat blue = 0;
	CGFloat green = 0;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue  = [self colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red   = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue  = [self colorComponentFrom:colorString start:3 length:1];          
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue  = [self colorComponentFrom:colorString start:4 length:2];                      
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red   = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];                      
            break;
        default:
//			NSLog(@"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString);
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
	NSString *str = [[NSString alloc] initWithFormat:@"%@%@", substring, substring];
    NSString *fullHex = length == 2 ? substring : str;
    unsigned int hexComponent;
	NSScanner *scanner = [[NSScanner alloc] initWithString:fullHex];
    [scanner scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

- (NSString *)hexFromInteger:(NSInteger)i {
	NSString *str = [[NSString alloc] initWithFormat:@"%x", i];
	if ([str length] == 1) {
		str = [[NSString alloc] initWithFormat:@"0%@", str];
	}
	return str;
}

- (NSString *)hexValue {
	CGFloat red = 0;
	CGFloat green = 0;
	CGFloat blue = 0;
	[self getRed:&red green:&green blue:&blue alpha:nil];
	NSMutableString *str = [[NSMutableString alloc] init];
	[str appendFormat:@"%@%@%@", [self hexFromInteger:(red * kMaxColorValue)], [self hexFromInteger:(green * kMaxColorValue)], [self hexFromInteger:(blue * kMaxColorValue)]];
	return [NSString stringWithString:str];
}

@end
