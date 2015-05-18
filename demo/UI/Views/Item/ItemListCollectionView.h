//
//  ItemListCollectionView.h
//  demo
//
//  Created by huamulou on 14-9-12.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "RefreashCommon.h"
#import "PSCollectionView.h"
#import "RefreashHeader.h"
#import "RefreashFooter.h"

typedef enum {
//在队尾添加数据,用于下拉刷新的时候
            ItemListReloadAppend,
    //在替换数据，用户顶部刷新
            ItemListReloadReplace
} ItemListReloadType;


@interface ItemListCollectionView : UIView <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, RefreshTableDelegate> {
    RefreashHeader *_refreshHeaderView;
    RefreashFooter *_refreshFooterView;
}

@property(nonatomic, retain) UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray *dataFromUrl;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *keyword;
@property(nonatomic, assign) NSInteger sort;
@property(nonatomic, assign) NSInteger subCategoryId;

@property(nonatomic, copy) void (^selectedCallBack)(NSString *tbItemId);

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title keyword:(NSString *)keyword sort:(NSInteger)sort subCategoryId:(NSInteger)subCategoryId;

- (void)loadDataWithType:(ItemListReloadType)type;
@end
