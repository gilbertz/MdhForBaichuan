//
//  CCTabBarViewController.h
//  TabBarControllerModel
//
//  Created by wangtian on 14-6-25.
//  Copyright (c) 2014年 wangtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTabBar.h"
#import "CCTabBarChinldVIewControllerDelegate.h"
#import "UIColor+Hex.h"



@interface CCTabBarViewController : UIViewController

@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, strong) CCTabBar *tabBar;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIViewController *currentViewController;//当前被选中controller
@property (nonatomic, assign) NSInteger currentIndex;//当前被选中controller
@property (nonatomic, assign) id<CCTabBarChinldVIewControllerDelegate>delegate;

- (id)initWithItemModels:(NSArray *)itemModelArray;
- (id)initWithItemModels:(NSArray *)itemModelArray defaultSelectedIndex:(NSInteger)defaultSelectedIndex;
- (void)setTabBarBgImage:(NSString *)imageName;
@end
