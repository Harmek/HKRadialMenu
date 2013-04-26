//
//  HKRadialMenuView.h
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

#import <UIKit/UIKit.h>

@class HKRadialMenuView;
@class HKRadialMenuItemView;
@protocol HKRadialMenuViewDataSource <NSObject>

- (NSUInteger)numberOfItemsInRadialMenuView:(HKRadialMenuView *)radialMenuView;
- (HKRadialMenuItemView *)centerItemViewForRadialMenuView:(HKRadialMenuView *)radialMenuView;
- (HKRadialMenuItemView *)itemViewInRadialMenuView:(HKRadialMenuView *)radialMenuView
                                           atIndex:(NSUInteger)index;

@end

@protocol HKRadialMenuViewDelegate <NSObject>

- (BOOL)rotateItemInRadialMenuView:(HKRadialMenuView *)radialMenuView atIndex:(NSUInteger)index;
- (CGFloat)distanceForItemInRadialMenuView:(HKRadialMenuView *)radialMenuView atIndex:(NSUInteger)index;
- (void)radialMenuView:(HKRadialMenuView *)radialMenuView didSelectItemAtIndex:(NSUInteger)index;

@optional
- (void)radialMenuViewDidSelectCenterView:(HKRadialMenuView *)radialMenuView;

@optional
- (CGFloat)angleForItemViewInRadialMenuView:(HKRadialMenuView *)radialMenuView
                                    atIndex:(NSUInteger)index;
@end

@interface HKRadialMenuView : UIView

- (void)reloadData;
- (void)revealItemsAnimated:(BOOL)animated;
- (void)hideItemsAnimated:(BOOL)animated;

@property (nonatomic, weak) id<HKRadialMenuViewDelegate> delegate;
@property (nonatomic, weak) id<HKRadialMenuViewDataSource> dataSource;
@property (nonatomic, readonly) BOOL itemsVisible;

@property (nonatomic) CFTimeInterval animationDuration                  UI_APPEARANCE_SELECTOR;
@property (nonatomic) CFTimeInterval delayBetweenAnimations             UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGPoint angleRange                                UI_APPEARANCE_SELECTOR;

@end
