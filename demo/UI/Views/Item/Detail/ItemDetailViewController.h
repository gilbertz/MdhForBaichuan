//
//  ItemDetailViewController.h
//  demo
//
//  Created by huamulou on 14-9-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemDetailViewController : UIViewController


//是否是天猫
@property(nonatomic, retain) NSString *tbItemId;


+ (instancetype)startWithItemId:(NSString *)tbItemId;


@end
