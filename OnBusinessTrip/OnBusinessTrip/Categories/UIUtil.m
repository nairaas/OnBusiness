//
//  UIUtil.m
//  AtTask
//
//  Created by Mikayel Aghasyan on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIUtil.h"
#import "Constants.h"
#import "ColorUtil.h"

#import "UIView+Additions.h"

#define FONT_SIZE_TITLE 12
#define FONT_SIZE_NORMAL 12

//static NSString *const kNavBarBackgroundImageName = @"navigation_bar.png";

@implementation UIUtil

+ (UILabel *)titleLabelWithTag:(int)tag width:(int)width {
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
	lbl.tag = tag;
	lbl.font = [UIFont fontWithName:kRegularFontName size:FONT_SIZE_TITLE];
	lbl.textColor = [UIColor grayColor];
	lbl.adjustsFontSizeToFitWidth = NO;
	lbl.lineBreakMode = UILineBreakModeWordWrap;
	lbl.numberOfLines = 0;

	return lbl;
}

+ (UILabel *)labelWithTag:(int)tag width:(int)width {
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
	lbl.tag = tag;
	lbl.font = [UIFont fontWithName:kRegularFontName size:FONT_SIZE_NORMAL];
	lbl.textColor = [UIColor blackColor];
	lbl.adjustsFontSizeToFitWidth = NO;
	lbl.lineBreakMode = UILineBreakModeWordWrap;
	lbl.numberOfLines = 0;

	return lbl;
}

+ (CGSize)positionView:(UIView *)v withOrigin:(CGPoint)origin withConstrain:(CGSize)szConstrain {
	UILabel *lbl = nil;
	if ([v isKindOfClass:[UILabel class]]) {
		lbl = (UILabel *)v;
	}
	if (lbl) {
		CGSize sz = [lbl.text sizeWithFont:lbl.font constrainedToSize:szConstrain lineBreakMode:UILineBreakModeWordWrap];
		v.frame = CGRectMake(origin.x, origin.y, sz.width, sz.height);
	}
	return v.frame.size;
}

+ (CGSize)positionView:(UIView *)v withOrigin:(CGPoint)origin withConstrain:(CGSize)szConstrain withText:(NSString *)text {
	UILabel *lbl = nil;
	if ([v isKindOfClass:[UILabel class]]) {
		lbl = (UILabel *)v;
		[lbl setText:text];
	}
	if (lbl) {
		CGSize sz = [lbl.text sizeWithFont:lbl.font constrainedToSize:szConstrain lineBreakMode:UILineBreakModeWordWrap];
		v.frame = CGRectMake(origin.x, origin.y, sz.width, sz.height);
	}
	return v.frame.size;
}

+ (CGFloat)makeIntegralFloat:(CGFloat)val {
	CGFloat scale = 1;
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		scale = [[UIScreen mainScreen] scale];
	}
	if (val > 0) {
	 	return floorf(scale * val) / scale;
	} else {
		return ceilf(scale * val) / scale;
	}
}

+ (CGPoint)makeIntegralPoint:(CGPoint)val {
	return CGPointMake([UIUtil makeIntegralFloat:val.x], [UIUtil makeIntegralFloat:val.y]);
}

+ (CGSize)makeIntegralSize:(CGSize)val {
	return CGSizeMake([UIUtil makeIntegralFloat:val.width], [UIUtil makeIntegralFloat:val.height]);
}

+ (CGRect)makeIntegralRect:(CGRect)val {
	CGRect rect;
	rect.origin = [UIUtil makeIntegralPoint:val.origin];
	rect.size = [UIUtil makeIntegralSize:val.size];
	return rect;
}

+ (CGFloat)getScaleFactor {
	UIScreen *screen = [UIScreen mainScreen];
	if ([screen respondsToSelector:@selector(scale)]) {
		return [screen scale];
	} else {
		return 1;
	}
}

+ (UIView *)loadViewFromNibNamed:(NSString *)nibName {
	UIView *v = nil;
	NSArray *arr = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
	if ([arr count] > 0) {
		v = (UIView *)[arr objectAtIndex:0];
	}
	return v;
}

+ (UIView *)loadViewFromNibNamed:(NSString *)nibName owner:(id)owner {
	UIView *v = nil;
	NSArray *arr = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
	if ([arr count] > 0) {
		v = (UIView *)[arr objectAtIndex:0];
	}
	return v;
}

+ (CGFloat)xOfObject:(id)obj {
	if([obj respondsToSelector:@selector(frame)]) {
		CGRect frame = [obj frame];
		return frame.origin.x;
	}
	return 0;
}

+ (CGFloat)yOfObject:(id)obj {
	if([obj respondsToSelector:@selector(frame)]) {
		CGRect frame = [obj frame];
		return frame.origin.y;
	}
	return 0;
}

+ (CGFloat)widthOfObject:(id)obj {
	if([obj respondsToSelector:@selector(frame)]) {
		CGRect frame = [obj frame];
		return frame.size.width;
	}
	return 0;
}

+ (CGFloat)heightOfObject:(id)obj {
	if([obj respondsToSelector:@selector(frame)]) {
		CGRect frame = [obj frame];
		return frame.size.height;
	}
	return 0;
}

+ (CGPoint)originOfObject:(id)obj {
	if([obj respondsToSelector:@selector(frame)]) {
		CGRect frame = [obj frame];
		return frame.origin;
	}
	return CGPointZero;
}

+ (CGSize)sizeOfObject:(id)obj {
	if([obj respondsToSelector:@selector(frame)]) {
		CGRect frame = [obj frame];
		return frame.size;
	}
	return CGSizeZero;
}

+ (void)setX:(CGFloat)x toObject:(id)obj {
	if([obj respondsToSelector:@selector(frame)] && [obj respondsToSelector:@selector(setFrame:)]) {
		CGRect frame = [obj frame];
		frame.origin.x = x;
		[obj setFrame:frame];
	}
}

+ (void)setY:(CGFloat)y toObject:(id)obj {
	if([obj respondsToSelector:@selector(frame)] && [obj respondsToSelector:@selector(setFrame:)]) {
		CGRect frame = [obj frame];
		frame.origin.y = y;
		[obj setFrame:frame];
	}
}

+ (void)setWidth:(CGFloat)width toObject:(id)obj {
	if([obj respondsToSelector:@selector(frame)] && [obj respondsToSelector:@selector(setFrame:)]) {
		CGRect frame = [obj frame];
		frame.size.width = width;
		[obj setFrame:frame];
	}
}

+ (void)setHeight:(CGFloat)height toObject:(id)obj {
	if([obj respondsToSelector:@selector(frame)] && [obj respondsToSelector:@selector(setFrame:)]) {
		CGRect frame = [obj frame];
		frame.size.height = height;
		[obj setFrame:frame];
	}
}

+ (void)setOrigin:(CGPoint)origin toObject:(id)obj {
	if([obj respondsToSelector:@selector(frame)] && [obj respondsToSelector:@selector(setFrame:)]) {
		CGRect frame = [obj frame];
		frame.origin = origin;
		[obj setFrame:frame];
	}
}

+ (void)setSize:(CGSize)size toObject:(id)obj {
	if([obj respondsToSelector:@selector(frame)] && [obj respondsToSelector:@selector(setFrame:)]) {
		CGRect frame = [obj frame];
		frame.size = size;
		[obj setFrame:frame];
	}
}

+ (UIImage *)imageWithRoundedBorderFromImage:(UIImage *)source withSize:(CGSize)size borderWidth:(CGFloat)width borderColor:(UIColor *)color {
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
	} else {
		UIGraphicsBeginImageContext(size);
	}
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect borderRect = CGRectMake(width / 2, width / 2, size.width - width, size.height - width);
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:borderRect cornerRadius:width * 2];
	path.lineWidth = width / 2;
	CGContextSetStrokeColorWithColor(context, color.CGColor);
	[path stroke];
	CGRect avatarImageRect = CGRectMake(width, width, size.width - 2 * width, size.height - 2 * width);
	CGPathRef p = [UIBezierPath bezierPathWithRoundedRect:avatarImageRect cornerRadius:width * 2 - 0.5].CGPath;
	CGContextAddPath(context, p);
	CGContextClip(context);
	[source drawInRect:avatarImageRect];
	UIImage *imageWithBorder =  UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return imageWithBorder;
}

+ (CGFloat)distanceBetweenPoint1:(CGPoint)point1 point2:(CGPoint)point2 {
	CGFloat dx = point1.x - point2.x;
	CGFloat dy = point1.y - point2.y;
	return [UIUtil makeIntegralFloat:sqrt(dx * dx + dy * dy)];
}

+ (UIImage *)navigationBarImage {
	NSString *fileLocation = [[NSBundle mainBundle] pathForResource:@"navigation_bar" ofType:@"png"];
	UIImage *backgroundImage = [[UIImage alloc] initWithContentsOfFile:fileLocation];
//	UIImage *backgroundImage = [UIImage imageNamed:kNavBarBackgroundImageName];
	backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	return backgroundImage;
}

+ (UIButton *)navigationBarButton {
	NSString *fileLocation = [[NSBundle mainBundle] pathForResource:@"add-comment-btn" ofType:@"png"];
	UIImage *normalImage = [[UIImage alloc] initWithContentsOfFile:fileLocation];
	normalImage = [normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
	fileLocation = [[NSBundle mainBundle] pathForResource:@"add-comment-btn-down" ofType:@"png"];
	UIImage *highlightedImage = [[UIImage alloc] initWithContentsOfFile:fileLocation];
	highlightedImage = [highlightedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn setBackgroundImage:normalImage forState:UIControlStateNormal];
	[btn setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
	[btn setSize:normalImage.size];
	[btn.titleLabel setFont:[UIFont fontWithName:kBoldFontName size:14]];
	[btn.titleLabel setShadowColor:[UIColor blackColor]];
	[btn.titleLabel setShadowOffset:CGSizeMake(0, -1)];
	return btn;
}

+ (void)showEditingNotAllowedInDemoAlert {
	NSString *message = NSLocalizedString(@"noEditingInDemo.alert.text", @"Commenting and updateing is not allowed in demo alert text");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil
										  otherButtonTitles:NSLocalizedString(@"action.OK", @"OK button label"), nil];
    alert.accessibilityLabel = @"UpdatesAndCommentCannotBeAdded";
	[alert show];
}

@end