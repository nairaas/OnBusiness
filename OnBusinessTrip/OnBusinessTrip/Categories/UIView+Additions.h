//
//  UIView+Additions.h
//  AtDash
//
//  Created by Mikayel Aghasyan on 2/23/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;
- (CGPoint)origin;
- (CGSize)size;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;

- (void)removeSubviews;

@end
