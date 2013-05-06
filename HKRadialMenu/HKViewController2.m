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
    UILabel *centerView = [[UILabel alloc] initWithFrame:CGRectZero];
    centerView.text = @"Hold...";
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
