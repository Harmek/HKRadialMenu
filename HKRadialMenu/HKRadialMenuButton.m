//
//  HKRadialMenuButton.m
//  HKRadialMenu
//
//  Created by Panos Baroudjian on 5/6/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import "HKRadialMenuButton.h"
#import "HKRadialGestureRecognizer.h"

@interface HKRadialMenuButton ()

@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *contentView;

@property (nonatomic) UIView *centerView;
@property (nonatomic) NSArray *views;
@property (nonatomic) NSArray *angles;

@property (nonatomic) CGFloat radius;

@property (nonatomic) HKRadialGestureRecognizer *gestureRecognizer;

@property (nonatomic) NSInteger layoutPadlock;

- (void)gestureRecognizerUpdated:(HKRadialGestureRecognizer *)recognizer;
- (void)revealViewsAnimated:(BOOL)animated;
- (void)hideViewsAnimated:(BOOL)animated;

@end

@implementation HKRadialMenuButton

- (id)initWithFrame:(CGRect)frame
      andCenterView:(UIView *)view
      andOtherViews:(NSArray *)views
          andAngles:(NSArray *)angles
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.centerView = view;
        [self addSubview:self.centerView];
        self.views = views;
        for (UIView *view in views) {
            [self addSubview:view];
        }
        self.angles = angles;
        self.autoRotate = YES;
        self.animationDuration = 1;
        self.selectedIndex = NSNotFound;
    }

    return self;
}

- (HKRadialGestureRecognizer *)gestureRecognizer
{
    if (!_gestureRecognizer)
    {
        _gestureRecognizer = [[HKRadialGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(gestureRecognizerUpdated:)];
        [self addGestureRecognizer:_gestureRecognizer];
    }

    return _gestureRecognizer;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.layoutPadlock)
        return;

    NSLog(@"layout", @"");
    CGRect frame = self.frame;
    CGFloat outerRadius = MIN(frame.size.width, frame.size.height) * .5;
    self.radius = outerRadius;
    frame = self.centerView.frame;
    CGFloat innerRadius = MAX(frame.size.width, frame.size.height) * .5;
    self.gestureRecognizer.innerRadius = innerRadius;
    self.gestureRecognizer.outerRadius = outerRadius;
    self.gestureRecognizer.angles = self.angles;

    CGPoint center = CGPointMake(self.frame.size.width * .5, self.frame.size.height * .5);
    frame = self.centerView.frame;
    self.centerView.frame = (CGRect)
    {
        .origin = {center.x - frame.size.width * .5, center.y - frame.size.height * .5},
        .size = frame.size
    };
    
    for (UIView *view in self.views)
    {
        view.alpha = .0;
        frame = view.frame;
        view.frame = (CGRect)
        {
            .origin = {center.x - frame.size.width * .5, center.y - frame.size.height * .5},
            .size = frame.size
        };
    }
}

- (void)gestureRecognizerUpdated:(HKRadialGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self revealViewsAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if (recognizer.closestAngleIndex != NSNotFound)
            {
                self.selectedIndex = recognizer.closestAngleIndex;
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
            if (self.selectedIndex != NSNotFound)
            {
                if ([self.delegate respondsToSelector:@selector(radialMenuButton:highlightedView:atIndex:)])
                    [self.delegate radialMenuButton:self
                                    highlightedView:self.selectedIndex == HKRadialMenuButtonCenterIndex ? self.centerView : self.views[self.selectedIndex]
                                            atIndex:self.selectedIndex];
            }
            [self hideViewsAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
//            NSLog(@"%@", @"Changed");
            NSInteger previousSelectedIndex = self.selectedIndex;
            NSInteger newSelectedIndex = recognizer.closestAngleIndex;
            if (previousSelectedIndex != newSelectedIndex)
            {
                if (previousSelectedIndex != NSNotFound && previousSelectedIndex != HKRadialMenuButtonCenterIndex)
                {
                    UIView *view = self.views[previousSelectedIndex];
                    NSNumber *angleNumber = self.angles[previousSelectedIndex];
                    CGFloat angle = angleNumber.floatValue;
                    CGRect viewFrame = view.frame;
                    CGFloat viewRadius = MAX(viewFrame.size.width, viewFrame.size.height) * .5;
                    CGFloat distance = (self.radius - viewRadius);
                    CGAffineTransform transform = CGAffineTransformIdentity;
                    if (self.autoRotate)
                        transform = CGAffineTransformRotate(transform, -angle);
                    transform.tx = distance;
                    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeRotation(angle));
                    self.layoutPadlock += 1;
                    [UIView animateWithDuration:self.animationDuration
                                          delay:0
                                        options:UIViewAnimationOptionCurveEaseOut |
                                                UIViewAnimationOptionBeginFromCurrentState
                                     animations:^(){
                                         view.transform = transform;
                                     }
                                     completion:^(BOOL completed){
                                         --self.layoutPadlock;
                                     }];
                    if ([self.delegate respondsToSelector:@selector(radialMenuButton:unhighlightedView:atIndex:)])
                        [self.delegate radialMenuButton:self
                                      unhighlightedView:view
                                                atIndex:previousSelectedIndex];
                }

                if (newSelectedIndex != NSNotFound && newSelectedIndex != HKRadialMenuButtonCenterIndex)
                {
                    UIView *view = self.views[newSelectedIndex];
                    NSNumber *angleNumber = self.angles[newSelectedIndex];
                    CGFloat angle = angleNumber.floatValue;
                    CGRect viewFrame = view.frame;
                    CGFloat viewRadius = MAX(viewFrame.size.width, viewFrame.size.height) * .5;
                    CGFloat distance = (self.radius - viewRadius) * .75;
                    CGAffineTransform transform = CGAffineTransformIdentity;
                    if (self.autoRotate)
                        transform = CGAffineTransformRotate(transform, -angle);
                    transform.tx = distance;
                    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeRotation(angle));
                    self.layoutPadlock++;
                    [UIView animateWithDuration:self.animationDuration
                                          delay:0
                                        options:UIViewAnimationOptionCurveEaseOut |
                                                UIViewAnimationOptionBeginFromCurrentState
                                     animations:^(){
                                         view.transform = transform;
                                     }
                                     completion:^(BOOL completed){
                                         --self.layoutPadlock;
                                     }];
                    if ([self.delegate respondsToSelector:@selector(radialMenuButton:highlightedView:atIndex:)])
                        [self.delegate radialMenuButton:self
                                        highlightedView:view
                                                atIndex:newSelectedIndex];
                }

                self.selectedIndex = newSelectedIndex;
            }
            break;
        }
        default:
            break;
    }
}

- (void)revealViewsAnimated:(BOOL)animated
{
    NSUInteger nbViews = self.views.count;
    if (!nbViews)
        return;

    self.layoutPadlock += nbViews;
    for (NSUInteger i = 0; i < nbViews; ++i)
    {
        UIView *radialView = self.views[i];
        CGRect viewFrame = radialView.frame;
        CGFloat viewRadius = MAX(viewFrame.size.width, viewFrame.size.height) * .5;
        CGFloat distance = self.radius - viewRadius;
        NSNumber *angleNumber = self.angles[i];
        CGFloat angle = angleNumber.floatValue;
        CGAffineTransform transform = CGAffineTransformIdentity;
        if (self.autoRotate)
            transform = CGAffineTransformRotate(transform, -angle);
        transform.tx = distance;
        transform = CGAffineTransformConcat(transform, CGAffineTransformMakeRotation(angle));

        if (animated)
        {
            [UIView animateWithDuration:self.animationDuration
                                  delay:i * self.delayBetweenAnimations
                                options:UIViewAnimationOptionCurveEaseOut |
             UIViewAnimationOptionBeginFromCurrentState
                             animations:^(){
                                 radialView.alpha = 1.;
                                 radialView.transform = transform;
                             }
                             completion:^(BOOL completed){
                                 --self.layoutPadlock;
                             }];
        }
        else
        {
            radialView.alpha = 1.;
            radialView.transform = transform;
        }
    }

    self.isExpanded = YES;
}

- (void)hideViewsAnimated:(BOOL)animated
{
    if (!self.isExpanded)
        return;

    NSUInteger nbViews = [self.views count];
    if (!nbViews)
        return;

    self.layoutPadlock += nbViews;
    for (NSUInteger i = nbViews; i != 0; --i)
    {
        UIView *view = [self.views objectAtIndex:i - 1];
        if (animated)
        {
            [UIView animateWithDuration:self.animationDuration
                                  delay:(nbViews - i) * self.delayBetweenAnimations
                                options:UIViewAnimationOptionCurveEaseOut |
             UIViewAnimationOptionBeginFromCurrentState
                             animations:^(){
                                 view.alpha = 0.;
                                 view.transform = CGAffineTransformIdentity;
                             }
                             completion:^(BOOL completed){
                                 --self.layoutPadlock;
                             }];
        }
        else
        {
            view.alpha = 0.;
            view.transform = CGAffineTransformIdentity;
        }
    }

    self.isExpanded = NO;
}


@end
