//
//  FunctionBarButton.h
//  demo
//
//  Created by huamulou on 14-9-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionBarButton : UIView


@property(nonatomic, retain) UIButton *button;
@property(nonatomic, assign) NSString *btnTitle;
@property(nonatomic, retain) UIView *highlightLine;
@property(nonatomic, copy) void (^clickCallback)();

- (void)on;

- (void)off;
@end
