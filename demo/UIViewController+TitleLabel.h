//
//  UIViewController+TitleLabel.h
//  demo
//
//  Created by huamulou on 14-9-10.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TitleLabel)



- (void)addTitleLabel:(CGRect)rect text:(NSString *)title fontSize:(NSInteger)fontSize color:(UIColor *)color;
- (void)addTitleLabelWithText:(NSString *)title withHeight:(CGFloat)height fontSize:(NSInteger)fontSize withColor:(UIColor *)color;
@end
