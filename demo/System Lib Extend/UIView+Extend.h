//
//  UIView+Extend.h
//  demo
//
//  Created by huamulou on 14-9-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(Extend)


- (UIViewController *)viewController;
- (void)alertWithTitle:(NSString *)title message:(NSString *)msg onBtnClicked:(void (^)(int btnIndex))onBtnClicked;
- (void)animateView:(UIView *)view toFrame:(CGRect)frame completion:(void (^)(void))completion;
- (UIView *)mainView;
@end
