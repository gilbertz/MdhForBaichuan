//
//  ItemDetailContentView.h
//  demo
//
//  Created by huamulou on 14-9-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailCommon.h"

@interface ItemDetailContentView : UIView <ItemDetailCell>


@property(nonatomic, retain) NSMutableArray *contents;
@property(nonatomic, copy) void (^imageCompleteCallBack)(UIImage *image);

- (instancetype)initWithContents:(NSMutableArray *)contents;
@property(nonatomic, weak) UIButton *backButton;

@end
