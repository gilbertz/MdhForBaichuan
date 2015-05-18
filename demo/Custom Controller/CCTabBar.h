//
//  CCTabBar.h
//  TabBarControllerModel
//
//  Created by wangtian on 14-6-25.
//  Copyright (c) 2014年 wangtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTabBarItem.h"
#import "Constants.h"
@protocol CCTabBarDelegate <NSObject>

- (void)selectedItem:(CCTabBarItemModel *)selectedItemModel;

@end

@interface CCTabBar : UIView
{
    NSMutableArray *_items;
}
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, assign) id<CCTabBarDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger currentSelectedIndex;
@property (nonatomic, assign, readonly) NSInteger lastSelectedIndex;
@property (nonatomic, readonly) NSMutableArray *items;

+ (CCTabBar *)getCCTabBarWithItemModels:(NSArray *)itemModels defaultSelectedIndex:(NSInteger)defaultSelectedIndex;
- (void)selectedItemAtIndex:(NSInteger)itemIndex;
- (void)setItemBadgeNumberWithIndex:(NSInteger)itemIndex badgeNumber:(NSInteger)badgeNumber;
@end
