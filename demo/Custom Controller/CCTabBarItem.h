//
//  CCTabBarItem.h
//  TabBarControllerModel
//
//  Created by wangtian on 14-6-25.
//  Copyright (c) 2014年 wangtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTabBarItemModel.h"

#define itemWH 64 //tabBar里按钮的大小
#define itemHE 44.5 //tabBar里按钮的大小
#define itemTitleFont [UIFont fontWithName:@"STHeitiSC-Light"  size:9]  //item 标题 字体font
#define badgeValueViewImageName @"userinfo_vip_background@2x.png" //小红圈 背景图片名称
#define badgeValueFont  [UIFont fontWithName:@"HelveticaNeue" size:12]  //小红圈里字体的大小
#define badgeValueColor [UIColor whiteColor] //小红圈里字体的颜色
#define badgeValueViewWH itemWH * 0.4  //小红圈的大小

@interface CCTabBarItem : UIButton
@property(nonatomic, strong) UIButton *badgeValueView;

+ (CCTabBarItem *)getCCTabBarItemWithModel:(CCTabBarItemModel *)itemModel;

- (void)setItemBadgeNumber:(NSInteger)number;
@end
