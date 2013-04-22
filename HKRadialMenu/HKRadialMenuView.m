//
//  HKRadialMenuView.m
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

#import "HKRadialMenuView.h"

#define TWO_PI M_PI * 2.0f

static const float k2Pi = TWO_PI;

@interface HKRadialMenuView ()

@property (nonatomic) BOOL needsReloadData;
@property (nonatomic) NSArray *items;
@property (nonatomic) UIView *centerView;

- (void)createCenterView;
- (void)createItems;
- (void)centerViewTapped:(UITapGestureRecognizer *)tapRecognizer;

@end

@implementation HKRadialMenuView

- (void)createCenterView
{
    if (self.centerView)
    {
        [self.centerView removeFromSuperview];
        self.centerView = nil;
    }

    UIView *centerView = [self.dataSource centerViewForRadialMenuView:self];
    if (centerView)
    {
        CGRect frame = centerView.frame;
        CGPoint center = self.center;
        frame.origin.x = center.x - frame.size.width * .5;
        frame.origin.y = center.y - frame.size.height * .5;
        centerView.frame = frame;

        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(centerViewTapped:)];
        recognizer.numberOfTouchesRequired = 1;
        recognizer.numberOfTapsRequired = 1;
        [centerView addGestureRecognizer:recognizer];
        centerView.userInteractionEnabled = YES;
        [self addSubview:centerView];
    }
}

- (void)centerViewTapped:(UITapGestureRecognizer *)tapRecognizer
{
    if (self.itemsVisible)
        [self hideItemsAnimated:YES];
    else
        [self revealItemsAnimated:YES];
}

- (void)createItems
{
    if (self.items)
    {
        for (NSUInteger i = 0; i < self.items.count; ++i)
        {
            UIView *itemView = [self.items objectAtIndex:i];
            [itemView removeFromSuperview];
        }

        self.items = nil;
    }

    NSUInteger nbItems = 1;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsInRadialMenuView:)])
        nbItems = [self.dataSource numberOfItemsInRadialMenuView:self];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:nbItems];
    for (NSUInteger i = 0; i < nbItems; ++i)
    {
        UIView *itemView = [self.dataSource viewForItemInRadialMenuView:self atIndex:i];
        if (itemView)
        {
            itemView.alpha = .0;
            CGRect frame = itemView.frame;
            CGPoint center = self.center;
            frame.origin.x = center.x - frame.size.width * .5;
            frame.origin.y = center.y - frame.size.height * .5;
            itemView.frame = frame;

            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(itemViewTapped:)];
            recognizer.numberOfTouchesRequired = 1;
            recognizer.numberOfTapsRequired = 1;
            
            [itemView addGestureRecognizer:recognizer];
            [itemView setUserInteractionEnabled:YES];
            [items addObject:itemView];
            [self addSubview:itemView];
        }
    }
    self.items = items;
    self.itemsVisible = NO;
}

- (void)itemViewTapped:(UITapGestureRecognizer *)tapRecognizer
{
    NSUInteger index = [self.items indexOfObject:tapRecognizer.view];
    if (index != NSNotFound)
    {
        [self.delegate radialMenuView:self didSelectItemAtIndex:index];
    }
}

- (void)reloadData
{
    [self createCenterView];
    [self createItems];
    self.needsReloadData = NO;
}

- (void)revealItemsAnimated:(BOOL)animated
{
    NSUInteger nbItems = [[self items] count];
    if (!nbItems)
        return;
    
    CGFloat deltaAngle = k2Pi / (CGFloat)nbItems;
    CGFloat angle = M_PI + M_PI_2 - deltaAngle * .5;
    for (NSUInteger i = 0; i < nbItems; ++i)
    {
        CGFloat distance = [self.delegate distanceForItemInRadialMenuView:self
                                                                  atIndex:i];
        BOOL rotate = [self.delegate rotateItemInRadialMenuView:self
                                                        atIndex:i];
        CGAffineTransform transform = CGAffineTransformIdentity;
        if (rotate)
            transform = CGAffineTransformRotate(transform, -angle);
        transform.tx = distance;
        transform = CGAffineTransformConcat(transform, CGAffineTransformMakeRotation(angle));
        UIView *itemView = [self.items objectAtIndex:i];
        if (animated)
        {
            [UIView animateWithDuration:self.animationDuration
                                  delay:i * self.delayBetweenAnimations
                                options:UIViewAnimationOptionCurveEaseOut |
                                        UIViewAnimationOptionBeginFromCurrentState
                             animations:^(){
                                 itemView.alpha = 1.;
                                 itemView.transform = transform;
                             }
                             completion:nil];
        }
        else
        {
            itemView.alpha = 1.;
            itemView.transform = transform;
        }
        
        angle += deltaAngle;
    }
    
    self.itemsVisible = YES;
}

- (void)hideItemsAnimated:(BOOL)animated
{
    if (!self.itemsVisible)
        return;

    NSUInteger nbItems = [[self items] count];
    if (!nbItems)
        return;

    for (NSUInteger i = nbItems; i != 0; --i)
    {
        UIView *itemView = [self.items objectAtIndex:i - 1];
        if (animated)
        {
            [UIView animateWithDuration:self.animationDuration
                                  delay:(nbItems - i) * self.delayBetweenAnimations
                                options:UIViewAnimationOptionCurveEaseOut |
                                        UIViewAnimationOptionBeginFromCurrentState
                             animations:^(){
                                 itemView.alpha = 0.;
                                 itemView.transform = CGAffineTransformIdentity;
                             }
                             completion:nil];
        }
        else
        {
            itemView.alpha = 0.;
            itemView.transform = CGAffineTransformIdentity;
        }
    }
    
    self.itemsVisible = NO;
}

- (void)setDataSource:(id<HKRadialMenuViewDataSource>)dataSource
{
    if (dataSource == _dataSource)
        return;
    
    _dataSource = dataSource;
    self.needsReloadData = YES;
}

- (void)layoutSubviews
{
    if (self.needsReloadData)
    {
        [self reloadData];
    }

    [super layoutSubviews];
}

@end
