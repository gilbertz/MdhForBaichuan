//
//  UIViewController+TitleLabel.m
//  demo
//
//  Created by huamulou on 14-9-10.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "UIViewController+TitleLabel.h"
#import "Constants.h"
#import "NSString+Extend.h"

@implementation UIViewController (TitleLabel)


- (void)addTitleLabelWithText:(NSString *)title withHeight:(CGFloat)height fontSize:(NSInteger)fontSize withColor:(UIColor *)color {


    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.textColor = color;  //设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [title attributedStringWithChineseFontSize:fontSize withNumberAndLetterFontSize:fontSize withLineSpacing:0];  //设置标题
    self.navigationItem.titleView = titleLabel;
}

- (void)addTitleLabel:(CGRect)rect text:(NSString *)title fontSize:(NSInteger)fontSize color:(UIColor *)color {

//    UIView *titleView = [[UIView alloc] initWithFrame:rect];
//    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

//    titleView.autoresizesSubviews = YES;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:rect];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.textColor = color;  //设置文本颜色
//    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.backgroundColor = [UIColor blackColor];
    titleLabel.attributedText = [title attributedStringWithChineseFontSize:fontSize withNumberAndLetterFontSize:fontSize withLineSpacing:0];  //设置标题
//    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleLabel;
}

@end
