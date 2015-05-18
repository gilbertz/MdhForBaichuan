//
//  CustomTabView.h
//  demo
//
//  Created by huamulou on 14-9-26.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@protocol CustomTabView
@property(nonatomic, assign) TabViewLoadState state;
- (void)didTabSelected;

@end