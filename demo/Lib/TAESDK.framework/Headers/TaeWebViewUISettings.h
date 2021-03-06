//
//  TaeWebViewUISettings.h
//  taesdk
//
//  Created by 友和(lai.zhoul@alibaba-inc.com) on 14-8-9.
//  Copyright (c) 2014年 com.taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaeWebViewUISettings : NSObject


/*此字段无效*/@property(nonatomic, strong) NSString *title ; //顶层 navigatorBar的标题内容

@property(nonatomic, strong) UIImage *backButtonBackgroundImage ; //顶层 navigatorBar的回退按钮的背景图片,图片尺寸参见Tae.bundle里的back@2x.png

typedef void (^webviewControllerDidDisappearCallback)();
@property(nonatomic, strong) webviewControllerDidDisappearCallback webviewControllerDidDisappearCallback;

/* 以下属性在调用参数isNeedPush=NO时生效，如果isNeedPush=YES,将使用调用者传入UINavigationController设置的样式*/

@property(nonatomic, strong) UIFont *titleFont ; //顶层 navigatorBar的标题字体
@property(nonatomic, strong) UIColor *titleColor ; //顶层 navigatorBar的标题字体颜色
@property(nonatomic, strong) UIColor *titleBackgroundColor ; //顶层 navigatorBar的标题字体Label的背景颜色
@property(nonatomic, strong) UIColor *barTintColor ; //顶层 navigatorBar的背景颜色
@property(nonatomic, strong) UIColor *tintColor ; //顶层 navigatorBar的左右bar的颜色，仅ios7

@end
