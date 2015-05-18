//
//  ItemDetailTitleView.h
//  demo
//
//  Created by huamulou on 14-9-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailCommon.h"

@interface ItemDetailTitleView : UIView<ItemDetailCell>


//是否是天猫
@property(nonatomic, assign) BOOL isTmall;


@property(nonatomic, retain) NSString *title;

@property(nonatomic, retain) NSString *price;
@property(nonatomic, retain) NSString *discountPrice;

- (instancetype)initWithIsTmall:(BOOL)isTmall title:(NSString *)title price:(NSString *)price discountPrice:(NSString *)discountPrice;

- (CGSize)getSize;
- (void)setUp;

@end
