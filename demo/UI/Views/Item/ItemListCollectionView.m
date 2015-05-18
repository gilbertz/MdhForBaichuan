//
//  ItemListCollectionView.m
//  demo
//
//  Created by huamulou on 14-9-12.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <Toast/UIView+Toast.h>
#import "ItemListCollectionView.h"
#import "Constants.h"
#import "URLUtil.h"
#import "NItemCell.h"
#import "ItemListCell.h"
#import "UIView+Extend.h"


@interface ItemListCollectionView () {
    NSInteger _currentPage;

}
@property(nonatomic, strong) NSMutableDictionary *cellSizes;
@property(nonatomic, strong) NSMutableDictionary *realCellSizes;

@property(nonatomic, retain) NSDate *date;
@property(nonatomic, assign) BOOL reading;
@property(nonatomic, retain) CHTCollectionViewWaterfallLayout *layout;
@end

@implementation ItemListCollectionView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title keyword:(NSString *)keyword sort:(NSInteger)sort subCategoryId:(NSInteger)subCategoryId {
    self = [super initWithFrame:frame];
    if (self) {

        self.title = title;
        self.keyword = keyword;
        self.sort = sort;
        self.subCategoryId = subCategoryId;
        self.backgroundColor = MIAN_VIEW_PIN_BACKGROUND_COLOR;
        _currentPage = 1;
        _layout = [[CHTCollectionViewWaterfallLayout alloc] init];

        _layout.sectionInset = UIEdgeInsetsMake(DEFAULT_SPACE, DEFAULT_SPACE, DEFAULT_SPACE, DEFAULT_SPACE);
//        layout.headerHeight = MAIN_VIEW_BANNER_IMAGE_VIEW_HEIGHT;
//        layout.footerHeight = 10;
        self.backgroundColor = MIAN_VIEW_PIN_BACKGROUND_COLOR;
        _layout.minimumColumnSpacing = DEFAULT_SPACE;
        _layout.minimumInteritemSpacing = DEFAULT_SPACE;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _reading = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[ItemListCell class] forCellWithReuseIdentifier:@"ItemListCell"];

        [self addSubview:_collectionView];
        [self loadDataWithType:ItemListReloadReplace];
        [self createHeaderView];
    }
    return self;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataFromUrl) {
        return [_dataFromUrl count];
    }
    return 0;
}

//设置分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    int index = indexPath.item;
    //  NSLog(@"reuse cell item - %d section -%d row -%d", indexPath.item, indexPath.section, indexPath.row);

    NSDictionary *data = [_dataFromUrl objectAtIndex:index];
    ItemListCell *cell = (ItemListCell *) [_collectionView dequeueReusableCellWithReuseIdentifier:@"ItemListCell" forIndexPath:indexPath];
    if (!cell) {
    }
    NSString *key = [self getKey:indexPath.item];
    CGFloat width = (SCREEN_WIDTH - 3 * DEFAULT_SPACE) / 2;
    CGSize cgSize = ([_realCellSizes objectForKey:key] || [_cellSizes objectForKey:key])
            ? ([_realCellSizes objectForKey:key] ? [[_realCellSizes objectForKey:key] CGSizeValue] : [[_cellSizes objectForKey:key] CGSizeValue])
            : CGSizeMake(width, -1);
    [cell setData:data size:cgSize imageLoadComplete:^(UIImage *image) {
        if (![_realCellSizes objectForKey:key]) {

            //[_cellSizes removeObjectForKey:[self getKey:indexPath.item]];
//            CGFloat height = [ItemListCell rowHeightForObject:[_dataFromUrl objectAtIndex:indexPath.item] inColumnWidth:width image:image];
//            [_realCellSizes setObject:[NSValue valueWithCGSize:CGSizeMake(width, height)] forKey:key];
//            [_layout updateSizeAtIndex:indexPath size:CGSizeMake(width, height)];
            /**
            * 去更新某些块会造成动画，体验不好
            */
//            NSMutableArray *array = [[NSMutableArray alloc] init];
//            for(int i= indexPath.item; i< [_dataFromUrl count];i++){
//                [array addObject:[NSIndexPath indexPathForItem:i inSection:0]];
//            }
//            [_collectionView reloadItemsAtIndexPaths:array];
//            [_collectionView reloadData];
        }
        //;
    }];
    //   [cell setCollectionView:collectionView];
    return cell;
}

- (void)loadDataWithType:(ItemListReloadType)type {
    NSString *url = ITEM_LIST_API;
    if (type == ItemListReloadReplace) {
        _currentPage = 1;
    }
    _reading = YES;
    NSNumber *page = [NSNumber numberWithInteger:_currentPage];
    NSNumber *pageSize = [NSNumber numberWithInteger:HTTP_API_DEFAULT_PAGESIZE];
    NSNumber *subCategoryId = [NSNumber numberWithInteger:_subCategoryId];
    NSNumber *sortNow = [NSNumber numberWithInteger:_sort];

    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            page, @"page",
            pageSize, @"pageSize", nil];
    if (_keyword)
        [parms setObject:_keyword forKey:@"keyword"];
    [parms setObject:sortNow forKey:@"sort"];
    [parms setObject:subCategoryId forKey:@"subCategoryId"];

    NSString *urlString = [URLUtil getURLWithParms:parms withPath:url];
    urlString = [[NSString alloc] initWithFormat:@"%@%@", HTTP_API_BASE_URL, urlString];

    NSLog(@"list 页面 url:%@", urlString);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager
            GET:urlString
     parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            id code = [responseObject objectForKey:@"code"];
            //   NSLog(@"################# url %@ \n\rres-%@", urlString, responseObject);
            if ([code isKindOfClass:[NSNumber class]]
                    && [(NSNumber *) code isEqualToNumber:[[NSNumber alloc] initWithInt:200]]) {
                NSArray *datas = [responseObject objectForKey:@"data"];

                if (type == ItemListReloadReplace) {
                    _dataFromUrl = [datas mutableCopy];
                } else {
                    if ([datas count] > 0) {
                        [_dataFromUrl addObjectsFromArray:datas];

                    } else {
                        _currentPage--;
                    }
                }
                //   NSLog(@"################# item count %d \n\n", datas.count);

                [_collectionView reloadData];
                [_collectionView layoutIfNeeded];
                _reading = NO;
                [self setFooterView];
            }
            else {
                NSLog(@"request failed url-%@ \n\t response-%@", url, responseObject);
                [[self mainView] makeToast:[responseObject objectForKey:@"msg"]];
            }

        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        }];
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!_cellSizes) {
        _cellSizes = [[NSMutableDictionary alloc] init];
    }
    if (!_realCellSizes) {
        _realCellSizes = [[NSMutableDictionary alloc] init];
    }

    /**
    * 因为重用了瀑布流，所以需要对不同的条件做分别
    */
    NSString *key = [self getKey:indexPath.item];
    NSLog(@"key is %@", key);
    id sellSizeId = [_cellSizes objectForKey:key];
    id sellSizeIdReal = [_realCellSizes objectForKey:key];
    if (sellSizeIdReal) {
        CGSize size = [sellSizeIdReal CGSizeValue];
        NSLog(@"in real cache height - %f width-%f for indexpath item-%d s-%d r-%d", size.height, size.width, indexPath.item, indexPath.section, indexPath.row);
        return size;
    }
    else if (sellSizeId) {
        CGSize size = [sellSizeId CGSizeValue];
        NSLog(@"in cache height - %f width-%f for indexpath item-%d s-%d r-%d", size.height, size.width, indexPath.item, indexPath.section, indexPath.row);
        return size;
    } else {
        CGFloat width = (SCREEN_WIDTH - 3 * DEFAULT_SPACE) / 2;
        CGFloat height;
        height = [ItemListCell rowHeightForObject:[_dataFromUrl objectAtIndex:indexPath.item] inColumnWidth:width];
        NSLog(@"not in cache height - %f for indexpath item-%d s-%d r-%d", height, indexPath.item, indexPath.section, indexPath.row);
        CGSize size = CGSizeMake(width, height);
        [_cellSizes setObject:[NSValue valueWithCGSize:size] forKey:key];
        return size;
    }

}


- (NSString *)getKey:(NSInteger)index {
    return [NSString stringWithFormat:@"%@%@%d%d%d", _title, _keyword, _sort, _subCategoryId, index];
}


- (void)setDataFromUrl:(NSMutableArray *)dataFromUrl {
    _dataFromUrl = dataFromUrl;
    [_collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"dssads-%d", indexPath.item);
    if (_selectedCallBack) {
        NSDictionary *data = [_dataFromUrl objectAtIndex:indexPath.item];
        NSLog(@"%@", data);
        _selectedCallBack([data valueForKey:@"tbItemId"]);
    }

}
#pragma mark -刷新区块开始

#pragma mark - 生成下拉刷新

- (void)createHeaderView {
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[RefreashHeader alloc] initWithFrame:
            CGRectMake(0.0f, 0.0f - self.bounds.size.height,
                    self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.delegate = self;

    [self.collectionView addSubview:_refreshHeaderView];

}


- (void)refreshTableDidTriggerRefresh:(RefreshPos)aRefreshPos {
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)refreshTableDataSourceIsLoading:(UIView *)view {
    return _reading;
}

- (NSDate *)refreshTableDataSourceLastUpdated:(UIView *)view {
    return [NSDate date];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_refreshHeaderView) {
        [_refreshHeaderView refreshScrollViewDidScroll:scrollView];
    }

    if (_refreshFooterView) {
        [_refreshFooterView refreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_refreshHeaderView) {
        [_refreshHeaderView refreshScrollViewDidEndDragging:scrollView];
    }

    if (_refreshFooterView) {
        [_refreshFooterView refreshScrollViewDidEndDragging:scrollView];
    }
}


- (void)finishReloadingData {

    if (_refreshHeaderView) {
        [_refreshHeaderView refreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
    }

    if (_refreshFooterView) {
        [_refreshFooterView refreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
        // [self setFooterView];
    }

}

#pragma mark - 设置底部刷新区块
- (void)setFooterView {
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(_collectionView.contentSize.height, _collectionView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                height,
                _collectionView.frame.size.width,
                self.bounds.size.height);
    } else {
        // create the footerView
        _refreshFooterView = [[RefreashFooter alloc] initWithFrame:
                CGRectMake(0.0f, height,
                        _collectionView.frame.size.width, self.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [_collectionView addSubview:_refreshFooterView];
    }

    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

#pragma mark data reloading methods that must be overide by the subclass

- (void)beginToReloadData:(RefreshPos)aRefreshPos {
    if (aRefreshPos == RefreshHeader) {
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0];
    } else if (aRefreshPos == RefreshFooter) {
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0];
    }
}

//刷新调用的方法
- (void)refreshView {

    [self loadDataWithType:ItemListReloadReplace];
    [self finishReloadingData];

//    [self testFinishedLoadData];

}


//加载调用的方法
- (void)getNextPageView {
    _currentPage ++;
    [self loadDataWithType:ItemListReloadAppend];
    [self finishReloadingData];

}


#pragma mark -刷新区块结束


@end
