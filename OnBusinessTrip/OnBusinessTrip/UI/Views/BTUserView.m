//
//  BTUserView.m
//  OnBusinessTrip
//
//  Created by Naira on 6/13/13.
//
//

#import "BTUserView.h"
#import "UIView+Additions.h"

@interface BTUserView ()

@property (nonatomic, weak) UIImageView *avatarView;
@property (nonatomic, weak) UIImageView *datingView;
@property (nonatomic, weak) UIImageView *socialView;

@end

@implementation BTUserView

@synthesize user = _user;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews {
    [self setFrame:CGRectMake(0, 0, 99, 88)];
    [self.contentView setFrame:CGRectMake(0, 0, 99, 88)];
}

- (void)setUser:(id)user {
	if (user != _user) {
		_user = user;
		[self updateView];
	}
}

- (void)updateView {
	[self.avatarView setImage:[UIImage imageNamed:@"maria.png"]];
	[self.socialView setHidden:![[self.user valueForKey:@"social"] boolValue]];
	[self.datingView setHidden:![[self.user valueForKey:@"dating"] boolValue]];
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 81, 78)];
        _avatarView = iv;
        [self.contentView addSubview:_avatarView];
    }
    return _avatarView;
}

- (UIImageView *)datingView {
    if (!_datingView) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dating_icon.png"]];
        _datingView = iv;
        [iv setOrigin:CGPointMake(0, 68)];
        [self.contentView addSubview:_datingView];
    }
    return _avatarView;
}


- (UIImageView *)socialView {
    if (!_socialView) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"social_icon.png"]];
        _socialView = iv;
        [iv setOrigin:CGPointMake(78, 68)];
       [self.contentView addSubview:_socialView];
    }
    return _avatarView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
