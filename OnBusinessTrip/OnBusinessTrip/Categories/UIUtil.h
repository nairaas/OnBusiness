//
//  UIUtil.h
//  AtTask
//
//  Created by Mikayel Aghasyan on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIUtil : NSObject {}

+ (UILabel *)titleLabelWithTag:(int)tag width:(int)width;
+ (UILabel *)labelWithTag:(int)tag width:(int)width;

+ (CGSize)positionView:(UIView *)v withOrigin:(CGPoint)origin withConstrain:(CGSize)szConstrain;
+ (CGSize)positionView:(UIView *)v withOrigin:(CGPoint)origin withConstrain:(CGSize)szConstrain withText:(NSString *)text;

+ (CGFloat)makeIntegralFloat:(CGFloat)val;
+ (CGPoint)makeIntegralPoint:(CGPoint)val;
+ (CGSize)makeIntegralSize:(CGSize)val;
+ (CGRect)makeIntegralRect:(CGRect)val;
+ (CGFloat)getScaleFactor;

+ (UIView *)loadViewFromNibNamed:(NSString *)nibName;
+ (UIView *)loadViewFromNibNamed:(NSString *)nibName owner:(id)owner;

+ (CGFloat)xOfObject:(id)obj;
+ (CGFloat)yOfObject:(id)obj;
+ (CGFloat)widthOfObject:(id)obj;
+ (CGFloat)heightOfObject:(id)obj;
+ (CGPoint)originOfObject:(id)obj;
+ (CGSize)sizeOfObject:(id)obj;

+ (void)setX:(CGFloat)x toObject:(id)obj;
+ (void)setY:(CGFloat)y toObject:(id)obj;
+ (void)setWidth:(CGFloat)width toObject:(id)obj;
+ (void)setHeight:(CGFloat)height toObject:(id)obj;
+ (void)setOrigin:(CGPoint)origin toObject:(id)obj;
+ (void)setSize:(CGSize)size toObject:(id)obj;

+ (UIImage *)imageWithRoundedBorderFromImage:(UIImage *)source withSize:(CGSize)size borderWidth:(CGFloat)width borderColor:(UIColor *)color;

+ (CGFloat)distanceBetweenPoint1:(CGPoint)point1 point2:(CGPoint)point2;

+ (UIImage *)navigationBarImage;
+ (UIButton *)navigationBarButton;

+ (void)showEditingNotAllowedInDemoAlert;

@end
