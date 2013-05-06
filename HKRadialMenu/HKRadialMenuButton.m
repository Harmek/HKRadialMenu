//
//  HKRadialMenuButton.m
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

#import "HKRadialMenuButton.h"
#import "HKRadialGestureRecognizer.h"

static CGFloat CGSizeGetRadius(CGSize size)
{
    return MAX(size.width, size.height) * .5;
}

@interface HKRadialMenuButton ()

@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *contentView;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic) UIView *centerView;
@property (nonatomic) NSArray *views;
@property (nonatomic) NSArray *angles;
@property (nonatomic) CGFloat radius;

@property (nonatomic) HKRadialGestureRecognizer *gestureRecognizer;

@property (nonatomic) NSInteger layoutPadlock;

- (void)_defaultInit;

- (void)gestureRecognizerUpdated:(HKRadialGestureRecognizer *)recognizer;
- (void)revealViewsAnimated:(BOOL)animated;
- (void)hideViewsAnimated:(BOOL)animated;

- (void)animateView:(UIView *)view
       withDuration:(CGFloat)duration
           andAlpha:(CGFloat)alpha
       andTransform:(CGAffineTransform)transform
      andCompletion:(void (^)(BOOL finished))completion;

- (void)expandView:(UIView *)view
          andAngle:(CGFloat)angle
       andDistance:(CGFloat)distance
          animated:(BOOL)animated;
- (void)collapseView:(UIView *)view
            animated:(BOOL)animated;
- (void)animateMagnetismWithGestureRecognizer:(HKRadialGestureRecognizer *)recognizer;
- (void)animateSelectionOnView:(UIView *)view;

@end

@implementation HKRadialMenuButton

- (id)init
{
    self = [super init];
    if (self)
    {
        [self _defaultInit];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self _defaultInit];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _defaultInit];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame
      andCenterView:(UIView *)view
      andOtherViews:(NSArray *)views
          andAngles:(NSArray *)angles
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.centerView = view;
        self.views = views;
        self.angles = angles;
    }

    return self;
}

- (void)_defaultInit
{
    self.autoRotate = YES;
    self.animationDuration = 1;
    self.selectedIndex = NSNotFound;
    self.magnetismRatio = .85;
    self.delayBetweenAnimations = 0;
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] initWithFrame:self.frame];
        [self addSubview:_contentView];
    }

    return _contentView;
}

- (UIView *)backgroundView
{
    if (!_backgroundView)
    {
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        [self addSubview:_backgroundView];
    }

    return _backgroundView;
}

- (void)setCenterView:(UIView *)centerView
{
    if (_centerView == centerView)
        return;

    if (_centerView)
        [_centerView removeFromSuperview];
    _centerView = centerView;
    [self.contentView addSubview:centerView];
}

- (void)setViews:(NSArray *)views
{
    if (_views == views)
        return;

    if (_views)
    {
        for (UIView *view in _views)
        {
            [view removeFromSuperview];
        }
    }
    _views = views;
    for (UIView *view in views)
    {
        [self.contentView addSubview:view];
    }
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

    CGRect frame = self.frame;
    self.contentView.frame = self.bounds;
    self.backgroundView.frame = self.bounds;
    CGFloat outerRadius = MIN(frame.size.width, frame.size.height) * .5;
    self.radius = outerRadius;
    frame = self.centerView.frame;
    CGFloat innerRadius = CGSizeGetRadius(frame.size);
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

- (void)animateView:(UIView *)view
       withDuration:(CGFloat)duration
           andAlpha:(CGFloat)alpha
       andTransform:(CGAffineTransform)transform
      andCompletion:(void (^)(BOOL finished))completion
{
    self.layoutPadlock += 1;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^(){
                         view.alpha = alpha;
                         view.transform = transform;
                     }
                     completion:^(BOOL completed){
                         --self.layoutPadlock;
                         if (completion)
                             completion(completed);
                     }];
}

- (void)expandView:(UIView *)view
          andAngle:(CGFloat)angle
       andDistance:(CGFloat)distance
          animated:(BOOL)animated
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (self.autoRotate)
        transform = CGAffineTransformRotate(transform, -angle);
    transform.tx = distance;
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeRotation(angle));
    if (animated)
    {
        [self animateView:view withDuration:self.animationDuration andAlpha:1. andTransform:transform andCompletion:nil];
    }
    else
    {
        view.alpha = 1.;
        view.transform = transform;
    }
}

- (void)collapseView:(UIView *)view animated:(BOOL)animated
{
    if (animated)
    {
        [self animateView:view withDuration:self.animationDuration andAlpha:.0 andTransform:CGAffineTransformIdentity andCompletion:nil];
    }
    else
    {
        view.transform = CGAffineTransformIdentity;
        view.alpha = .0;
    }
}

- (void)animateSelectionOnView:(UIView *)view
{
    CGAffineTransform transform = view.transform;
    transform = CGAffineTransformConcat(CGAffineTransformMakeScale(2, 2), transform);
    [self animateView:view
         withDuration:self.animationDuration * .5
             andAlpha:.0
         andTransform:transform
        andCompletion:^(BOOL complete){
            view.transform = CGAffineTransformIdentity;
            view.alpha = view == self.centerView ? 1. : .0;
        }];
}

- (void)animateMagnetismWithGestureRecognizer:(HKRadialGestureRecognizer *)recognizer
{
    NSInteger previousIndex = self.selectedIndex;
    NSInteger newIndex = recognizer.closestAngleIndex;
    if (previousIndex != NSNotFound && previousIndex != HKRadialMenuButtonCenterIndex)
    {
        UIView *view = self.views[previousIndex];
        NSNumber *angleNumber = self.angles[previousIndex];
        CGFloat angle = angleNumber.floatValue;
        CGFloat distance = (self.radius - CGSizeGetRadius(view.frame.size));
        [self expandView:view andAngle:angle andDistance:distance animated:YES];
        if ([self.delegate respondsToSelector:@selector(radialMenuButton:unhighlightedView:atIndex:)])
            [self.delegate radialMenuButton:self
                          unhighlightedView:view
                                    atIndex:previousIndex];
    }
    else if (previousIndex == HKRadialMenuButtonCenterIndex)
    {
        if ([self.delegate respondsToSelector:@selector(radialMenuButton:unhighlightedView:atIndex:)])
            [self.delegate radialMenuButton:self
                          unhighlightedView:self.centerView
                                    atIndex:HKRadialMenuButtonCenterIndex];
    }

    if (newIndex != NSNotFound && newIndex != HKRadialMenuButtonCenterIndex)
    {
        UIView *view = self.views[newIndex];
        NSNumber *angleNumber = self.angles[newIndex];
        CGFloat angle = angleNumber.floatValue;
        CGFloat distance = (self.radius - CGSizeGetRadius(view.frame.size)) * self.magnetismRatio;
        [self expandView:view andAngle:angle andDistance:distance animated:YES];
        if ([self.delegate respondsToSelector:@selector(radialMenuButton:highlightedView:atIndex:)])
            [self.delegate radialMenuButton:self
                            highlightedView:view
                                    atIndex:newIndex];
    }
    else if (newIndex == HKRadialMenuButtonCenterIndex)
    {
        if ([self.delegate respondsToSelector:@selector(radialMenuButton:highlightedView:atIndex:)])
            [self.delegate radialMenuButton:self
                            highlightedView:self.centerView
                                    atIndex:HKRadialMenuButtonCenterIndex];
    }
}

- (void)gestureRecognizerUpdated:(HKRadialGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            if ([self.delegate respondsToSelector:@selector(radialMenuButton:highlightedView:atIndex:)])
                [self.delegate radialMenuButton:self
                                highlightedView:self.centerView
                                        atIndex:HKRadialMenuButtonCenterIndex];
            self.selectedIndex = HKRadialMenuButtonCenterIndex;
            [self revealViewsAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (self.selectedIndex != recognizer.closestAngleIndex)
            {
                [self animateMagnetismWithGestureRecognizer:recognizer];
                self.selectedIndex = recognizer.closestAngleIndex;
            }
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
                UIView *view = self.selectedIndex == HKRadialMenuButtonCenterIndex ? self.centerView : self.views[self.selectedIndex];
                [self animateSelectionOnView:view];
                if ([self.delegate respondsToSelector:@selector(radialMenuButton:unhighlightedView:atIndex:)])
                    [self.delegate radialMenuButton:self
                                  unhighlightedView:view
                                            atIndex:self.selectedIndex];
            }
            [self hideViewsAnimated:YES];
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

    for (NSUInteger i = 0; i < nbViews; ++i)
    {
        UIView *radialView = self.views[i];
        CGFloat viewRadius = CGSizeGetRadius(radialView.frame.size);
        CGFloat distance = self.radius - viewRadius;
        NSNumber *angle = self.angles[i];
        [self expandView:radialView
                andAngle:angle.floatValue
             andDistance:distance
                animated:animated];
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

    for (NSUInteger i = nbViews; i != 0; --i)
    {
        if (i - 1 == self.selectedIndex)
            continue;
        
        UIView *view = [self.views objectAtIndex:i - 1];
        [self collapseView:view animated:animated];
    }

    self.isExpanded = NO;
}


@end
