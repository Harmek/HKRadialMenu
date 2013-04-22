//
//  HKRadialMenuViewController.m
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


#import "HKRadialMenuViewController.h"

@interface HKRadialMenuViewController ()

@end

@implementation HKRadialMenuViewController

- (void)loadView
{
    [super loadView];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    HKRadialMenuView *radialMenuView = [[HKRadialMenuView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                          screenWidth,
                                                                                          screenHeight)];
    radialMenuView.dataSource = self;
    radialMenuView.delegate = self;
    radialMenuView.animationDuration = 1;
    radialMenuView.backgroundColor = [UIColor whiteColor];
    self.view = radialMenuView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    HKRadialMenuView *view = (HKRadialMenuView *)self.view;
    [view reloadData];
}

#pragma mark HKRadialMenuViewDataSource methods

- (UIView *)centerViewForRadialMenuView:(HKRadialMenuView *)radialMenuView
{
    return nil;
}

- (NSUInteger)numberOfItemsInRadialMenuView:(HKRadialMenuView *)radialMenuView
{
    return 1;
}

- (UIView *)viewForItemInRadialMenuView:(HKRadialMenuView *)radialMenuView
                                atIndex:(NSUInteger)index
{
    return nil;
}

#pragma mark HKRadialMenuViewDelegate methods

- (BOOL)rotateItemInRadialMenuView:(HKRadialMenuView *)radialMenuView
                           atIndex:(NSUInteger)index
{
    return YES;
}

- (CGFloat)distanceForItemInRadialMenuView:(HKRadialMenuView *)radialMenuView
                                   atIndex:(NSUInteger)index
{
    return 80;
}

- (void)radialMenuView:(HKRadialMenuView *)radialMenuView
didSelectItemAtIndex:(NSUInteger)index
{

}

@end
