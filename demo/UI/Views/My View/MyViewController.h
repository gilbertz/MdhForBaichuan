//
//  MyViewController.h
//  demo
//
//  Created by huamulou on 14-9-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTabBarChinldVIewControllerDelegate.h"

@class MyViewUserInfoView;

@interface MyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property(nonatomic, retain) UITableView *menuTable;
@property(nonatomic, retain) MyViewUserInfoView *userInfoView;
@property(nonatomic, retain) UINavigationController *myNavController;
@property(nonatomic, assign) id <CCTabBarChinldVIewControllerDelegate> delegate;
@end
