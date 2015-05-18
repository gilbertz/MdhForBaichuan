//
//  ItemDetailBuyArea.h
//  demo
//
//  Created by huamulou on 14-9-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailCommon.h"


typedef enum {
    ItemDetailBuyAreaShow = 0,
    ItemDetailBuyAreaHide,
} ItemDetailBuyAreaStaus;

@interface ItemDetailBuyArea : UIView <ItemDetailCell>


@property(nonatomic, assign) ItemDetailBuyAreaStaus areaStaus;


@property(nonatomic, copy) void (^buyNowButtonCB)(CGFloat areaHeight);
@property(nonatomic, retain) NSMutableDictionary *baichuanData;
@property(nonatomic, retain) NSMutableDictionary *itemFullData;
@property(nonatomic, retain) NSMutableDictionary *aitaobaoShop;
@end
