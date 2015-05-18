//
//  SettingsView.h
//  demo
//
//  Created by huamulou on 14-9-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsView : UIView
@property(weak, nonatomic) IBOutlet UIButton *outBtn;
@property(nonatomic, copy) void (^clickCB)(void);

@end
