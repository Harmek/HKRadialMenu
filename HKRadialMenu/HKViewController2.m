//
//  HKViewController2.m
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

#import "HKViewController2.h"
#import "UIView+Resizing.h"

@interface HKViewController2 ()

- (void)radialMenuButtonSelected:(HKRadialMenuButton *)button;

@end

@implementation HKViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *centerView = [[UILabel alloc] initWithFrame:CGRectZero];
    centerView.text = @"Hold this";
    UILabel *view1 = [[UILabel alloc] initWithFrame:CGRectZero];
    view1.text = @"Button 1";
    UILabel *view2 = [[UILabel alloc] initWithFrame:CGRectZero];
    view2.text = @"Button 2";
    UILabel *view3 = [[UILabel alloc] initWithFrame:CGRectZero];
    view3.text = @"Button 3";
    centerView.font = [UIFont boldSystemFontOfSize:20];
    view1.font = view2.font = view3.font = [UIFont boldSystemFontOfSize:18];
    [centerView resizeToFit];
    [view1 resizeToFit];
    [view2 resizeToFit];
    [view3 resizeToFit];

    HKRadialMenuButton *button = [[HKRadialMenuButton alloc]
                                  initWithFrame:CGRectMake(0, 0, 300, 300)
                                  andCenterView:centerView
                                  andOtherViews:@[view1, view2, view3]
                                  andAngles:@[[NSNumber numberWithFloat:-M_PI_4],
                                              [NSNumber numberWithFloat:3 * M_PI_2],
                                              [NSNumber numberWithFloat:-3 * M_PI_4]]];
    button.delegate = self;
    [button addTarget:self action:@selector(radialMenuButtonSelected:) forControlEvents:UIControlEventValueChanged];
    button.center = self.view.center;
    [self.view addSubview:button];
}

- (void)radialMenuButtonSelected:(HKRadialMenuButton *)button
{
    NSLog(@"Radial Menu Button selected index: %d", button.selectedIndex);
}

- (void)radialMenuButton:(HKRadialMenuButton *)button highlightedView:(UIView *)view atIndex:(NSInteger)index
{
    UILabel *label = (UILabel *)view;
    label.textColor = [UIColor redColor];
}

- (void)radialMenuButton:(HKRadialMenuButton *)button unhighlightedView:(UIView *)view atIndex:(NSInteger)index
{
    UILabel *label = (UILabel *)view;
    label.textColor = [UIColor blackColor];
}

@end
