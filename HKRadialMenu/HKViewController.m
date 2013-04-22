//
//  HKViewController.m
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

#import "HKViewController.h"

@interface HKViewController ()

@end

@implementation HKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    HKRadialMenuView *radialView = (HKRadialMenuView *)self.view;
    radialView.delayBetweenAnimations = .1;
}

- (NSUInteger)numberOfItemsInRadialMenuView:(HKRadialMenuView *)radialMenuView
{
    return 8;
}

- (UIView *)centerViewForRadialMenuView:(HKRadialMenuView *)radialMenuView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.text = @"Tap here";
    [label sizeToFit];

    label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin;
    return label;
}

- (UIView *)viewForItemInRadialMenuView:(HKRadialMenuView *)radialMenuView atIndex:(NSUInteger)index
{
    NSString *text = [NSString stringWithFormat:@"Item #%u", index];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    textLabel.text = text;
    textLabel.font = [UIFont boldSystemFontOfSize:18];
    [textLabel sizeToFit];

    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    subtitleLabel.text = @"Subtitle";
    subtitleLabel.font = [UIFont systemFontOfSize:14];
    subtitleLabel.textColor = [UIColor colorWithWhite:.5 alpha:1.];
    [subtitleLabel sizeToFit];

    CGFloat width = MAX(textLabel.frame.size.width, subtitleLabel.frame.size.width);
    CGFloat height = textLabel.frame.size.height + subtitleLabel.frame.size.height + 1;
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [itemView addSubview:textLabel];
    [itemView addSubview:subtitleLabel];
    subtitleLabel.frame = CGRectMake(0, textLabel.frame.size.height, subtitleLabel.frame.size.width, subtitleLabel.frame.size.height);


    itemView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin;
    [itemView sizeToFit];
    return itemView;
}

- (CGFloat)distanceForItemInRadialMenuView:(HKRadialMenuView *)radialMenuView atIndex:(NSUInteger)index
{
    return 100;
}

- (void)radialMenuView:(HKRadialMenuView *)radialMenuView didSelectItemAtIndex:(NSUInteger)index
{
    NSLog(@"Selected Item#%u", index);
}

@end
