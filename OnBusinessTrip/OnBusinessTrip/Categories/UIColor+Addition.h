//
//  ColorUtil.h
//  AtTask
//
//  Created by Mikayel Aghasyan on 11/18/10.
//  Copyright 2010 AtTask. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIColor (Addition)

+ (UIColor *)colorWithWhite:(int)white;
+ (UIColor *)colorWithRed:(int)red withGreen:(int)green withBlue:(int)blue;

+ (NSString *)redBarStartColor;
+ (NSString *)redBarEndColor;
+ (NSString *)redBarStrokeColor;
+ (NSString *)yellowBarStartColor;
+ (NSString *)yellowBarEndColor;
+ (NSString *)yellowBarStrokeColor;
+ (NSString *)greenBarStartColor;
+ (NSString *)greenBarEndColor;
+ (NSString *)greenBarStrokeColor;
+ (NSString *)orangeBarStartColor;
+ (NSString *)orangeBarEndColor;
+ (NSString *)orangeBarStrokeColor;
+ (NSString *)purpleBarStartColor;
+ (NSString *)purpleBarEndColor;
+ (NSString *)purpleBarStrokeColor;
+ (NSString *)blueBarStartColor;
+ (NSString *)blueBarEndColor;
+ (NSString *)blueBarStrokeColor;
+ (NSString *)darkOrangeBarStartColor;
+ (NSString *)darkOrangeBarEndColor;
+ (NSString *)darkOrangeBarStrokeColor;
+ (NSString *)darkBlueBarEndColor;
+ (NSString *)greyBarColor;
+ (NSString *)greyBarStrokeColor;

+ (UIColor *)avatarBorderColor;
+ (UIColor *)unassignedAvatarBorderColor;
+ (UIColor *)blankAvatarBorderColor;

@end

@interface UIColor(HexString)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length;

- (NSString *)hexValue;

@end
