//
//  BTSwitch.m
//  OnBusinessTrip
//
//  Created by Naira on 6/9/13.
//
//

#import "BTSwitch.h"

@interface BTSwitch ()

@property (nonatomic, assign) BOOL onValue;
@property (nonatomic, assign) CGFloat percentage; // Number between 0 and 1.0
@property (nonatomic, assign) BOOL touching;
@property (nonatomic, assign) BOOL moved;

@end

@implementation BTSwitch

@dynamic on;
@synthesize onValue = onValue_;
@synthesize backgroundImage = backgroundImage_;
@synthesize thumbnailImage = thumbnailImage_;
@synthesize percentage = percentage_;
@synthesize touching = touching_;
@synthesize moved = moved_;

#pragma mark - Initialization

- (void) setPercentageForOn:(BOOL) on {
	self.percentage = self.onValue ? 1.0 : 0.0;
}

- (void) setup {
	self.onValue = YES;
	[self setPercentageForOn:YES];
}

- (id) init {
	self = [super init];
    
	if (self) {
		[self setup];
	}
    
	return self;
}

- (id) initWithFrame:(CGRect) frame {
	self = [super initWithFrame:frame];
    
	if (self) {
		[self setup];
	}
    
	return self;
}

- (BOOL) on {
	return self.onValue;
}

- (void) setOn:(BOOL) on {
	self.onValue = on;
	[self setPercentageForOn:on];
	[self setNeedsDisplay];
}

#pragma mark - Display

- (void) drawRect:(CGRect) rect {
	[super drawRect:rect];
    
	[self.backgroundImage drawInRect:self.bounds];
    
	CGFloat thumbnailMaxX = self.bounds.size.width - self.thumbnailImage.size.width;
	if (thumbnailMaxX < 0.0) {
		thumbnailMaxX = 0.0;
	}
    
	CGFloat thumbnailX = self.percentage * thumbnailMaxX;
	CGFloat thumbnailY = (self.bounds.size.height - self.thumbnailImage.size.height) / 2.0;
    
	[self.thumbnailImage drawInRect:CGRectMake(thumbnailX, thumbnailY, self.thumbnailImage.size.width, self.thumbnailImage.size.height)];
}

#pragma mark - Touch

- (void) handlePercentageForPoint:(CGPoint) point {
	CGFloat minX = self.thumbnailImage.size.width / 2.0;
	CGFloat maxX = self.bounds.size.width - minX;
    
	if (point.x < minX) {
		self.percentage = 0.0;
	} else if (point.x > maxX) {
		self.percentage = 1.0;
	} else {
		self.percentage = (point.x - minX) / (self.bounds.size.width - self.thumbnailImage.size.width);
	}
}

- (void) touchesBegan:(NSSet*) touches withEvent:(UIEvent*) event {
	CGPoint touchPoint = [[touches anyObject] locationInView:self];
	if (CGRectContainsPoint(self.bounds, touchPoint)) {
		self.touching = YES;
		self.moved = NO;
		[self handlePercentageForPoint:touchPoint];
		[self setNeedsDisplay];
	}
}

- (void) touchesMoved:(NSSet*) touches withEvent:(UIEvent*) event {
	CGPoint touchPoint = [[touches anyObject] locationInView:self];
	CGRect boundary = CGRectMake(self.bounds.origin.x - 75.0, self.bounds.origin.y - 75.0, self.bounds.size.width + 150.0, self.bounds.size.height + 150.0);
	if (self.touching) {
		if (CGRectContainsPoint(boundary, touchPoint)) {
			self.moved = YES;
			[self handlePercentageForPoint:touchPoint];
			[self setNeedsDisplay];
		} else {
			self.touching = NO;
		}
	} else {
		if (CGRectContainsPoint(boundary, touchPoint)) {
			self.moved = YES;
			self.touching = YES;
			[self handlePercentageForPoint:touchPoint];
			[self setNeedsDisplay];
		}
	}
}

- (void) touchesCancelled:(NSSet*) touches withEvent:(UIEvent*) event {
	CGPoint touchPoint = [[touches anyObject] locationInView:self];
	self.touching = NO;
}

- (void) touchesEnded:(NSSet*) touches withEvent:(UIEvent*) event {
	CGPoint touchPoint = [[touches anyObject] locationInView:self];
	BOOL wasTouching = self.touching;
	BOOL hadMoved = self.moved;
    
	self.touching = NO;
	self.moved = NO;
    
	BOOL on;
	if (hadMoved) {
		on = self.percentage >= 0.5;
	} else {
		on = ! self.onValue;
	}
	BOOL valueChanged = self.onValue != on;
	self.onValue = on;
    
	[self setPercentageForOn:on];
	[self setNeedsDisplay];
    
	if (wasTouching && valueChanged) {
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

@end
