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

@interface HKRadialMenuItemView ()

- (void)defaultInit;

@property (nonatomic) UILabel *textLabel;
@property (nonatomic) UILabel *subtitleLabel;

@end

@implementation HKRadialMenuItemView

- (id)init
{
    self = [super init];
    if (self)
    {
        self.style = HKRadialMenuItemStyleDefault;
        [self defaultInit];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.style = HKRadialMenuItemStyleDefault;
        [self defaultInit];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.style = HKRadialMenuItemStyleDefault;
        [self defaultInit];
    }

    return self;
}

- (id)initWithStyle:(HKRadialMenuItemStyle)style
{
    self = [super initWithFrame:CGRectMake(0, 0, 10, 10)];
    if (self)
    {
        self.style = style;
        [self defaultInit];
    }

    return self;
}

- (void)defaultInit
{
    NSString *textLabelText = nil;
    if (self.textLabel)
    {
        textLabelText = self.textLabel.text;
        [self.textLabel removeFromSuperview];
        self.textLabel = nil;
    }

    CGFloat fontSize = self.style == HKRadialMenuItemStyleSubtitle ? 18 : 20;
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    CGSize labelSize = !textLabelText ? [@"Title" sizeWithFont:font] : [textLabelText sizeWithFont:font];
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelSize.width, labelSize.height)];
    self.textLabel.font = font;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.textLabel];

    if (self.style == HKRadialMenuItemStyleSubtitle)
    {
        NSString *subtitleLabelText = nil;
        if (self.subtitleLabel)
        {
            subtitleLabelText = self.subtitleLabel.text;
            [self.subtitleLabel removeFromSuperview];
            self.subtitleLabel = nil;
        }

        font = [UIFont systemFontOfSize:14];
        labelSize = !subtitleLabelText ? [@"Subtitle" sizeWithFont:font] : [subtitleLabelText sizeWithFont:font];
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelSize.width, labelSize.height)];
        self.subtitleLabel.font = font;
        self.subtitleLabel.textColor = [UIColor colorWithWhite:.5 alpha:1.];
        self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
        self.subtitleLabel.backgroundColor = [UIColor clearColor];
        self.subtitleLabel.frame = CGRectMake(0,
                                              self.textLabel.frame.size.height,
                                              self.subtitleLabel.frame.size.width,
                                              self.subtitleLabel.frame.size.height);
        [self addSubview:self.subtitleLabel];
    }

    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
                            UIViewAutoresizingFlexibleTopMargin |
                            UIViewAutoresizingFlexibleLeftMargin |
                            UIViewAutoresizingFlexibleRightMargin;

    [self sizeToFit];
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
    [self.textLabel resizeToFit];
    if (self.style == HKRadialMenuItemStyleSubtitle)
    {
        [self.subtitleLabel resizeToFit];
        CGFloat maxWidth = MAX(self.textLabel.frame.size.width, self.subtitleLabel.frame.size.width);
        self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x,
                                          self.textLabel.frame.origin.y,
                                          maxWidth,
                                          self.textLabel.frame.size.height);
        self.subtitleLabel.frame = CGRectMake(self.subtitleLabel.frame.origin.x,
                                              self.subtitleLabel.frame.origin.y,
                                              maxWidth,
                                              self.subtitleLabel.frame.size.height);
    }

    CGRect boundingFrame = CGRectZero;
    for (UIView *subView in self.subviews)
    {
        boundingFrame = CGRectUnion(boundingFrame, subView.frame);
    }

    self.frame = boundingFrame;
}

@end
