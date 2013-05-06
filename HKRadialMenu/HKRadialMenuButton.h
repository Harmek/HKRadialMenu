//
//  HKRadialMenuButton.h
//  HKRadialMenu
//
//  Created by Panos Baroudjian on 5/6/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKRadialMenuButton;

static const NSInteger HKRadialMenuButtonCenterIndex = -1;

@protocol HKRadialMenuButtonDelegate <NSObject>

- (void)radialMenuButton:(HKRadialMenuButton *)button
       unhighlightedView:(UIView *)view
                 atIndex:(NSInteger)index;

- (void)radialMenuButton:(HKRadialMenuButton *)button
         highlightedView:(UIView *)view
                 atIndex:(NSInteger)index;

@end

@interface HKRadialMenuButton : UIControl

- (id)initWithFrame:(CGRect)frame
      andCenterView:(UIView *)view
      andOtherViews:(NSArray *)views
          andAngles:(NSArray *)angles;

@property (nonatomic, readonly) UIView *backgroundView;
@property (nonatomic, readonly) UIView *contentView;

@property (nonatomic) BOOL autoRotate;
@property (nonatomic) CFTimeInterval animationDuration                  UI_APPEARANCE_SELECTOR;
@property (nonatomic) CFTimeInterval delayBetweenAnimations             UI_APPEARANCE_SELECTOR;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) id<HKRadialMenuButtonDelegate> delegate;

@end
