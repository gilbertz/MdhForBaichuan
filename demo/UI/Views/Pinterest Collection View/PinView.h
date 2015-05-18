//
//  PinView.h
//  demo
//
//  Created by huamulou on 14-9-7.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"
#import "RefreashHeader.h"
#import "RefreashCommon.h"

@class RefreashHeader;
@class RefreashFooter;

@interface PinView : PSCollectionView <UIScrollViewDelegate, PSCollectionViewDataSource, PSCollectionViewDelegate, RefreshTableDelegate> {
    RefreashHeader *_refreshHeaderView;
    RefreashFooter *_refreshFooterView;
}


@property(nonatomic, retain) NSString *dataUrl;

- (instancetype)initWithFrame:(CGRect)frame withUrl:(NSString *)dataUrl;


@end
