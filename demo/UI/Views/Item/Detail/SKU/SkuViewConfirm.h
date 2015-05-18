//
//  SkuViewConfirm.h
//  demo
//
//  Created by huamulou on 14-9-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkuViewConfirm : UIView
@property(weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property(nonatomic, copy) void (^confirmBtnCB)(void);

-(void)setUp;
+ (CGFloat)getHeight;
@end
