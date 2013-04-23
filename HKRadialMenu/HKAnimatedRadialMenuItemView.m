//
//  HKGlowingRadialMenuItemView.m
//  HKRadialMenu
//
//  Created by Panos Baroudjian on 4/23/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import "HKAnimatedRadialMenuItemView.h"

@interface HKAnimatedRadialMenuItemView ()

- (void)initAnimation;

@end

@implementation HKAnimatedRadialMenuItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initAnimation];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initAnimation];
    }
    return self;
}

- (id)initWithStyle:(HKRadialMenuItemStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        [self initAnimation];
    }

    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initAnimation];
    }

    return self;
}

- (void)initAnimation
{
    [UIView animateWithDuration:1.5
                          delay:0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.textLabel.alpha = .1;
                     }
                     completion:nil];
}

@end
