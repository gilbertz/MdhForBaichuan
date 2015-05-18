//
//  ItemDetailServiceView.h
//  demo
//
//  Created by huamulou on 14-9-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailCommon.h"



@interface ItemDetailServiceView : UIView <ItemDetailCell>


@property(nonatomic, assign) NSString *postFee;
@property(nonatomic, retain) NSString *monthlySale;
@property(nonatomic, retain) NSString *area;

- (instancetype)initWithPostFee:(NSString *)postFee monthlySale:(NSString *)monthlySale area:(NSString *)area;



@end
