//
//  CCTabBarItem.m
//  TabBarControllerModel
//
//  Created by wangtian on 14-6-25.
//  Copyright (c) 2014年 wangtian. All rights reserved.
//

#import "CCTabBarItem.h"
#import "UIColor+Hex.h"
//#import "SecurityGuardManager.h"

#define itemFrame CGRectMake(0, 0, itemWH, itemHE)
#define imageHeightDefault 22
#define fontHeightDefault 9
#define upIntend 6
#define downIntend 4.5
#define defaultTitleColor [UIColor colorWithHexString : @"#a1a1a1" ]
#define defaultTitleTintColor [UIColor colorWithHexString : @"#f67b9e" ]

@implementation CCTabBarItem


+ (CCTabBarItem *)getCCTabBarItemWithModel:(CCTabBarItemModel *)itemModel {
    CCTabBarItem *tabBarItem = [[CCTabBarItem alloc] initWithFrame:itemFrame];
    [tabBarItem configItemWithItemModel:itemModel];
    return tabBarItem;
}

#pragma mark -设置item信息

- (void)configItemWithItemModel:(CCTabBarItemModel *)itemModel {
    if (itemModel.itemTitle != nil) {

        [self setTitle:itemModel.itemTitle forState:(UIControlStateNormal)];
    }
    if (itemModel.itemImageName != nil) {

        [self setImage:[UIImage imageNamed:itemModel.itemImageName] forState:(UIControlStateNormal)];
    }

    [self setTintColor:defaultTitleTintColor];
}

#pragma mark -设置小红圈里的数字

- (void)setItemBadgeNumber:(NSInteger)number {
    if (number != 0) {

        if (self.badgeValueView.hidden) {

            self.badgeValueView.hidden = NO;
        }
        [self.badgeValueView setTitle:[NSString stringWithFormat:@"%d", number] forState:(UIControlStateNormal)];
    }
    else {

        self.badgeValueView.hidden = YES;
    }
}

- (UIButton *)badgeValueView {
    if (_badgeValueView == nil) {

        CGFloat x = itemWH - badgeValueViewWH + 5;
        CGFloat y = -5;
        _badgeValueView = [[UIButton alloc] initWithFrame:CGRectMake(x, y, badgeValueViewWH, badgeValueViewWH)];
        [_badgeValueView setBackgroundImage:[UIImage imageNamed:badgeValueViewImageName] forState:(UIControlStateNormal)];
        _badgeValueView.titleLabel.font = badgeValueFont;
        [_badgeValueView setTitleColor:badgeValueColor forState:(UIControlStateNormal)];
        _badgeValueView.hidden = YES;
        _badgeValueView.adjustsImageWhenHighlighted = NO;
    }
    return _badgeValueView;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置按钮文字颜色
        [self setTitleColor:defaultTitleColor forState:UIControlStateNormal];
        // 设置按钮文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 让图片按照原来的宽高比显示出来
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        // 设置按钮文字的字体
        self.titleLabel.font = itemTitleFont;
        // 设置按钮里面的内容（UILabel、UIImageView）居中
        // self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self addSubview:self.badgeValueView];
        self.adjustsImageWhenHighlighted = NO;

    }
    return self;
}


#pragma mark - 重写了UIButton的方法
#pragma mark 控制UILabel的位置和尺寸

// contentRect其实就是按钮的位置和尺寸
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleX = 0;
    CGFloat titleHeight = fontHeightDefault;
    CGFloat titleY = contentRect.size.height - titleHeight - downIntend;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

#pragma mark 控制UIImageView的位置和尺寸

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageX = 0;
    CGFloat imageY = upIntend;
    CGFloat imageWidth = contentRect.size.width;
    CGFloat imageHeight = imageHeightDefault;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}




@end
