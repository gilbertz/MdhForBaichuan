//
//  CCTabBar.m
//  TabBarControllerModel
//
//  Created by wangtian on 14-6-25.
//  Copyright (c) 2014年 wangtian. All rights reserved.
//

#import "CCTabBar.h"
#import "UIColor+Hex.h"

#define defaultTitleTintColor [UIColor colorWithHexString : @"#f67b9e" ]
#define distance 20 //第一个和最后一个item距离屏幕边界的距离
#define defaultTitleColor [UIColor colorWithHexString : @"#a1a1a1" ]
#define CCTabBarSize CGSizeMake(SCREEN_WIDTH, TAB_BAR_HEIGHT)
#define CCTabBarOrigin CGPointMake(0, TAB_BAR_Y)

@implementation CCTabBar {
    float _itemDisTance;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (NSMutableArray *)items {
    if (_items == nil) {

        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

+ (CCTabBar *)getCCTabBarWithItemModels:(NSArray *)itemModels defaultSelectedIndex:(NSInteger)defaultSelectedIndex {
    CCTabBar *malTabBar = [[CCTabBar alloc] initWithFrame:CGRectMake(CCTabBarOrigin.x, CCTabBarOrigin.y, CCTabBarSize.width, CCTabBarSize.height)];


    NSLog(@"CCTabBar - %f - %f - %f - %f", CCTabBarOrigin.x, CCTabBarOrigin.y, CCTabBarSize.width, CCTabBarSize.height);
    malTabBar.itemArray = itemModels;
    [malTabBar setUpViews];
    [malTabBar selectdefaultItem:defaultSelectedIndex];
    return malTabBar;
}

#pragma mark - 设置item

- (void)setUpViews {
    NSInteger itemCount = self.itemArray.count;
    _itemDisTance = (CCTabBarSize.width - 2 * distance - itemCount * itemWH) / (itemCount - 1);
    for (NSInteger itemIndex = 0; itemIndex < itemCount; itemIndex++) {

        CCTabBarItemModel *itemModel = [self.itemArray objectAtIndex:itemIndex];
        itemModel.itemIndex = itemIndex;
        CCTabBarItem *item = [CCTabBarItem getCCTabBarItemWithModel:itemModel];
        item.tag = itemIndex;
        [item addTarget:self action:@selector(selectItem:) forControlEvents:(UIControlEventTouchUpInside)];
        CGPoint itemPosition = [self getItemPositionWithItemIndex:itemIndex itemCount:itemCount];
        [item setFrame:CGRectMake(itemPosition.x, itemPosition.y, itemWH, itemHE)];
        [self addSubview:item];
        [self.items addObject:item];
    }
    [self selectdefaultItem:0];
}

#pragma mark -获得item的坐标 （item的索引   item的总数）

- (CGPoint)getItemPositionWithItemIndex:(NSInteger)itemIndex itemCount:(NSInteger)itemCount {
    CGPoint itemPosition;
    itemPosition = CGPointMake(itemIndex * (itemWH + _itemDisTance) + distance, 0);
    return itemPosition;
}

#pragma mark -点击tabBar上item调用方法

- (void)selectItem:(UIButton *)sender {
    [self selectedItemAtIndex:sender.tag];
}

#pragma mark -默认选中项

- (void)selectdefaultItem:(NSInteger)defaultSelectedItemIndex {
    _currentSelectedIndex = defaultSelectedItemIndex;
    _lastSelectedIndex = defaultSelectedItemIndex;
    [self setSelectedItemStatus];
}

#pragma mark -选中item  改变item状态  并向tabBar代理发送消息

- (void)selectedItemAtIndex:(NSInteger)itemIndex {
    if (itemIndex == _currentSelectedIndex) {

        return;
    }
    CCTabBarItemModel *itemModel = [self.itemArray objectAtIndex:itemIndex];
    _lastSelectedIndex = _currentSelectedIndex;
    _currentSelectedIndex = itemIndex;
    [self setSelectedItemStatus];
    [self setLastSelectedItemStatus];
    if ([self.delegate respondsToSelector:@selector(selectedItem:)]) {

        [self.delegate selectedItem:itemModel];
    }
}

#pragma mark - 设置选中item状态的样式

- (void)setSelectedItemStatus {
    CCTabBarItemModel *itemModel = [self.itemArray objectAtIndex:_currentSelectedIndex];
    CCTabBarItem *currentSelecteditem = [self.items objectAtIndex:_currentSelectedIndex];
    [currentSelecteditem setTitleColor:defaultTitleTintColor forState:(UIControlStateNormal)];
    if (itemModel.selectedItemImageName != nil) {

        [currentSelecteditem setImage:[UIImage imageNamed:itemModel.selectedItemImageName] forState:(UIControlStateNormal)];
    }
}

#pragma mark - 设置上一个被选中的item的样式

- (void)setLastSelectedItemStatus {
    CCTabBarItemModel *itemModel = [self.itemArray objectAtIndex:_lastSelectedIndex];
    CCTabBarItem *lastSelectedItem = [self.items objectAtIndex:_lastSelectedIndex];
    [lastSelectedItem setTitleColor:defaultTitleColor forState:(UIControlStateNormal)];
    if (itemModel.itemImageName != nil) {

        [lastSelectedItem setImage:[UIImage imageNamed:itemModel.itemImageName] forState:(UIControlStateNormal)];
    }
}

- (void)setItemBadgeNumberWithIndex:(NSInteger)itemIndex badgeNumber:(NSInteger)badgeNumber {
    CCTabBarItem *item = [self.items objectAtIndex:itemIndex];
    [item setItemBadgeNumber:badgeNumber];
}
@end




