//
//  UIView+Additions.m
//  AtDash
//
//  Created by Mikayel Aghasyan on 2/23/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "UIView+Additions.h"
#import "UIUtil.h"

@implementation UIView (Additions)

- (CGFloat)x {
	return [UIUtil xOfObject:self];
}

- (CGFloat)y {
	return [UIUtil yOfObject:self];
}

- (CGFloat)width {
	return [UIUtil widthOfObject:self];
}

- (CGFloat)height {
	return [UIUtil heightOfObject:self];
}

- (CGPoint)origin {
	return [UIUtil originOfObject:self];
}

- (CGSize)size {
	return [UIUtil sizeOfObject:self];
}

- (void)setX:(CGFloat)x {
	[UIUtil setX:x toObject:self];
}

- (void)setY:(CGFloat)y {
	[UIUtil setY:y toObject:self];
}

- (void)setWidth:(CGFloat)width {
	[UIUtil setWidth:width toObject:self];
}

- (void)setHeight:(CGFloat)height {
	[UIUtil setHeight:height toObject:self];
}

- (void)setOrigin:(CGPoint)origin {
	[UIUtil setOrigin:origin toObject:self];
}

- (void)setSize:(CGSize)size {
	[UIUtil setSize:size toObject:self];
}

- (void)removeSubviews {
	for (UIView *v in self.subviews) {
		[v removeFromSuperview];
	}
}
@end
