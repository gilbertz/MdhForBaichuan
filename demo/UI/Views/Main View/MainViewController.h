//
//  MainViewController.h
//  demo
//
//  Created by huamulou on 14-9-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTabBarChinldVIewControllerDelegate.h"
#import "Constants.h"
#import "BannerFrame.h"
#import "CustomTabView.h"


@interface MainViewController : UIViewController <BannerItemSelectDelegate,CustomTabView>

@property(nonatomic, assign) id <CCTabBarChinldVIewControllerDelegate> delegate;


@property(nonatomic, copy) void (^clickCB)(NSDictionary *data);
@end
