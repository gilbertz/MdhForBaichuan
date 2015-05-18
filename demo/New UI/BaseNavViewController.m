//
//  BaseNavViewController.m
//  demo
//
//  Created by huamulou on 14-10-24.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

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
    // Do any additional setup after loading the view.
   // self.tabBarItem.selectedImage = [self.tabBarItem.image. ]
    self.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -10);
    //self.tabBarItem.image.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
