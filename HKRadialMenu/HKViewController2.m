//
//  HKViewController2.m
//  HKRadialMenu
//
//  Created by Panos Baroudjian on 5/6/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import "HKViewController2.h"
#import "HKRadialMenuButton.h"
#import "HKRadialMenuItemView.h"
#import "UIView+Resizing.h"

@interface HKViewController2 ()

@end

@implementation HKViewController2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[UILabel appearance] setTextColor:[UIColor blackColor]];
    UILabel *centerView = [[UILabel alloc] initWithFrame:CGRectZero];
    centerView.text = @"Center";
    [centerView resizeToFit];
    UILabel *view1 = [[UILabel alloc] initWithFrame:CGRectZero];
    view1.text = @"View 1";
    [view1 resizeToFit];
    UILabel *view2 = [[UILabel alloc] initWithFrame:CGRectZero];
    view2.text = @"View 2";
    [view2 resizeToFit];
    UILabel *view3 = [[UILabel alloc] initWithFrame:CGRectZero];
    view3.text = @"View 3";
    [view3 resizeToFit];
//    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [view1 setBackgroundColor:[UIColor greenColor]];
//    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [view2 setBackgroundColor:[UIColor greenColor]];
//    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [view3 setBackgroundColor:[UIColor greenColor]];
    HKRadialMenuButton *button = [[HKRadialMenuButton alloc]
                                  initWithFrame:CGRectMake(100, 100, 300, 300)
                                  andCenterView:centerView
                                  andOtherViews:@[view1, view2, view3]
                                  andAngles:@[@0, [NSNumber numberWithFloat:3 * M_PI_2], @M_PI]];
    [button setBackgroundColor:[UIColor redColor]];
    button.center = self.view.center;
    [self.view addSubview:button];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
