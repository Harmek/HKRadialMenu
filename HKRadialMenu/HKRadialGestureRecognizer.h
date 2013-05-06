//
//  HKGestureRecognizer.h
//  HKRadialMenu
//
//  Created by Panos Baroudjian on 5/6/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKRadialGestureRecognizer : UIGestureRecognizer

@property (nonatomic) CGFloat               innerRadius;
@property (nonatomic) CGFloat               outerRadius;
@property (nonatomic) NSArray               *angles;

@property (nonatomic, readonly) NSInteger   closestAngleIndex;

@end
