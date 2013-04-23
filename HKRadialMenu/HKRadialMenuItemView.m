//
//  HKRadialMenuItemView.m
//  HKRadialMenu
//
//  Copyright (c) 2013, Panos Baroudjian.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

#import "HKRadialMenuItemView.h"
#import "UIView+Resizing.h"

static const UIViewAutoresizing kDefaultAutoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
                                                            UIViewAutoresizingFlexibleTopMargin |
                                                            UIViewAutoresizingFlexibleLeftMargin |
                                                            UIViewAutoresizingFlexibleRightMargin;

@interface HKRadialMenuItemView ()

- (void)defaultInit;
- (void)createImageView;
- (void)createTextLabel;
- (void)createDetailTextLabel;

@property (nonatomic) UILabel *textLabel;
@property (nonatomic) UILabel *detailTextLabel;
@property (nonatomic) UIImageView *imageView;

@end

@implementation HKRadialMenuItemView

- (id)init
{
    self = [super init];
    if (self)
    {
        self.style = HKRadialMenuItemStyleDefault;
//        [self defaultInit];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.style = HKRadialMenuItemStyleDefault;
//        [self defaultInit];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.style = HKRadialMenuItemStyleDefault;
//        [self defaultInit];
    }

    return self;
}

- (id)initWithStyle:(HKRadialMenuItemStyle)style
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.style = style;
//        [self defaultInit];
    }

    return self;
}

- (void)createImageView
{
    if (!self.imageView)
    {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
    }

    self.imageView.frame = CGRectMake(0, 0, 40, 40);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)createTextLabel
{
    if (!self.textLabel)
    {
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textLabel];
    }

    CGFloat fontSize = self.style == HKRadialMenuItemStyleSubtitle ? 18 : 20;
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    self.textLabel.font = font;
}

- (void)createDetailTextLabel
{
    if (!self.detailTextLabel)
    {
        self.detailTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.font = font;
        self.detailTextLabel.textColor = [UIColor colorWithWhite:.5 alpha:1.];
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.detailTextLabel];
    }
}

- (void)defaultInit
{
    [self createImageView];
    [self createTextLabel];

    CGFloat offsetY = self.imageView.frame.size.height;
    self.textLabel.frame = (CGRect)
    {
        .origin = { .0, offsetY },
        .size = self.textLabel.frame.size
    };

    if (self.style == HKRadialMenuItemStyleSubtitle)
    {
        [self createDetailTextLabel];
        offsetY += self.textLabel.frame.size.height;
        self.detailTextLabel.frame = (CGRect)
        {
            .origin = {.0, offsetY},
            .size = self.detailTextLabel.frame.size
        };
    }
    else if (self.detailTextLabel)
    {
        [self.detailTextLabel removeFromSuperview];
        self.detailTextLabel = nil;
    }
    
    self.autoresizingMask = kDefaultAutoresizingMask;
}

- (void)setStyle:(HKRadialMenuItemStyle)style
{
    if (style == _style)
        return;

    _style = style;
    [self defaultInit];
}

- (void)recenterLayout
{
    CGFloat offsetY = self.imageView.frame.size.height;

    [self.textLabel resizeToFit];
    self.textLabel.frame = (CGRect)
    {
        .origin = {.0, offsetY},
        .size = self.textLabel.frame.size
    };
    offsetY += self.textLabel.frame.size.height;

    if (self.style == HKRadialMenuItemStyleSubtitle)
    {
        [self.detailTextLabel resizeToFit];
        CGFloat maxWidth = MAX(self.textLabel.frame.size.width, self.detailTextLabel.frame.size.width);
        self.textLabel.frame = (CGRect)
        {
            .origin = self.textLabel.frame.origin,
            .size = { maxWidth, self.textLabel.frame.size.height }
        };
        self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x,
                                              offsetY,
                                              maxWidth,
                                              self.detailTextLabel.frame.size.height);
    }

    // Resizing the view to contain all subviews
    CGRect boundingFrame = CGRectZero;
    for (UIView *subView in self.subviews)
    {
        boundingFrame = CGRectUnion(boundingFrame, subView.frame);
    }
    self.frame = boundingFrame;

    // Recentering the image view
    self.imageView.frame = (CGRect)
    {
        .origin = { boundingFrame.size.width * .5 - self.imageView.frame.size.width * .5, 0 },
        .size = self.imageView.frame.size
    };
}

@end
