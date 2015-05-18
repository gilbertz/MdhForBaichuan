//
//  CustomPageControl.h
//  demo
//
//  Created by huamulou on 14-9-6.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol PageControlDelegate;


#pragma mark - 哥他妈用画图的方式画出来的点点了 太敬业了
@interface CustomPageControl : UIView

#pragma mark - 页码之类的配置项，真是变态的设计师啊啊啊啊啊
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;

// Customize these as well as the backgroundColor property.
@property (nonatomic, strong) UIColor *dotCurrentColor;
@property (nonatomic, strong) UIColor *dotOtherColor;


#pragma mark - 边框的颜色，真是变态的设计师啊啊啊啊啊
@property (nonatomic, strong) UIColor *dotCurrentBorderColor;
@property (nonatomic, strong) UIColor *dotOtherBorderColor;

#pragma mark - 边框透明度，真是变态的设计师啊啊啊啊啊
@property (nonatomic) CGFloat dotCurrentBorderAlpha;
@property (nonatomic) CGFloat dotOtherBorderAlpha;

#pragma mark - dot透明度，真是变态的设计师啊啊啊啊啊
@property (nonatomic) CGFloat dotCurrentAlpha;
@property (nonatomic) CGFloat dotOtherAlpha;

// Optional delegate for callbacks when user taps a page dot.
@property (nonatomic, weak) NSObject<PageControlDelegate> *delegate;



@end

@protocol PageControlDelegate<NSObject>
@optional
- (void)pageControlPageDidChange:(CustomPageControl *)pageControl;
@end
