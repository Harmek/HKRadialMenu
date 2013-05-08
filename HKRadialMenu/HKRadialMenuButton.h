//
//  HKRadialMenuButton.h
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

@class HKRadialMenuButton;

static const NSInteger HKRadialMenuButtonCenterIndex = -1;

@protocol HKRadialMenuButtonDelegate <NSObject>

@optional
- (void)radialMenuButton:(HKRadialMenuButton *)button
       unhighlightedView:(UIView *)view
                 atIndex:(NSInteger)index;

@optional
- (void)radialMenuButton:(HKRadialMenuButton *)button
         highlightedView:(UIView *)view
                 atIndex:(NSInteger)index;

@end

@interface HKRadialMenuButton : UIControl

- (id)initWithFrame:(CGRect)frame
      andCenterView:(UIView *)view
      andOtherViews:(NSArray *)views
          andAngles:(NSArray *)angles;

@property (nonatomic) UIView *centerView;
@property (nonatomic) NSArray *views;
@property (nonatomic) NSArray *angles;

@property (nonatomic, readonly) UIView      *backgroundView;
@property (nonatomic, readonly) UIView      *contentView;
@property (nonatomic, readonly) BOOL        isExpanded;
@property (nonatomic, readonly) NSInteger   selectedIndex;

@property (nonatomic) NSTimeInterval    expansionDelay          UI_APPEARANCE_SELECTOR;
@property (nonatomic) BOOL              autoRotate              UI_APPEARANCE_SELECTOR;
@property (nonatomic) CFTimeInterval    animationDuration       UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat           magnetismRatio          UI_APPEARANCE_SELECTOR;

@property (nonatomic) id<HKRadialMenuButtonDelegate>    delegate;

@end
