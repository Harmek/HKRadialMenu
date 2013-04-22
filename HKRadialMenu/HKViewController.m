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
#import "UIView+Resizing.h"
@interface HKViewController ()

- (void)startSliderChanged:(UISlider *)slider;
- (void)endSliderChanged:(UISlider *)slider;

@end

@implementation HKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 42, 21)];
    label.text = @"Angle range (between 0 and PI)";
    [label resizeToFit];

    UISlider *startSlider = [[UISlider alloc] initWithFrame:CGRectMake(18, 49, 284, 23)];
    startSlider.minimumValue = 0;
    startSlider.maximumValue = M_PI * 2;
    startSlider.value = 0;
    [startSlider addTarget:self action:@selector(startSliderChanged:) forControlEvents:UIControlEventValueChanged];

    UISlider *endSlider = [[UISlider alloc] initWithFrame:CGRectMake(18, 79, 284, 23)];
    endSlider.minimumValue = 0;
    endSlider.maximumValue = startSlider.maximumValue;
    endSlider.value = endSlider.maximumValue;
    [endSlider addTarget:self action:@selector(endSliderChanged:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:label];
    [self.view addSubview:startSlider];
    [self.view addSubview:endSlider];
    HKRadialMenuView *radialView = self.radialMenuView;
    radialView.delayBetweenAnimations = .1;
}

- (void)startSliderChanged:(UISlider *)slider
{
    self.radialMenuView.angleRange = CGPointMake(slider.value, self.radialMenuView.angleRange.y);
}

- (void)endSliderChanged:(UISlider *)slider
{
    self.radialMenuView.angleRange = CGPointMake(self.radialMenuView.angleRange.x, slider.value);
}

- (NSUInteger)numberOfItemsInRadialMenuView:(HKRadialMenuView *)radialMenuView
{
    return 8;
}

- (UIView *)centerItemViewForRadialMenuView:(HKRadialMenuView *)radialMenuView
{
    HKRadialMenuItemView *itemView = [[HKRadialMenuItemView alloc] initWithStyle:HKRadialMenuItemStyleDefault];

    itemView.textLabel.text = @"Tap Here";

    return itemView;
}

- (HKRadialMenuItemView *)itemViewInRadialMenuView:(HKRadialMenuView *)radialMenuView atIndex:(NSUInteger)index
{
    HKRadialMenuItemView *itemView = [[HKRadialMenuItemView alloc] initWithStyle:HKRadialMenuItemStyleSubtitle];
    itemView.textLabel.text = [NSString stringWithFormat:@"Item #%u", index];
    itemView.subtitleLabel.text = @"Subtitle";

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
