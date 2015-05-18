//
//  NView.h
//  demo
//
//  Created by huamulou on 14-9-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "RefreashCommon.h"
#import "RefreashHeader.h"
#import "RefreashFooter.h"

@class RefreashHeader;
@class RefreashFooter;


@interface NView : UIView <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, RefreshTableDelegate> {
    RefreashHeader *_refreshHeaderView;
    RefreashFooter *_refreshFooterView;
}
@property(nonatomic, copy) void (^cellClickCB)(NSDictionary *data);
@property(nonatomic, retain) UICollectionView *collectionView;


- (void)setUrl:(NSString *)url successCB:(void (^)(void))successCB failedCB:(void (^)(void))failedCB;


@end
