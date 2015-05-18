//
//  PinView.m
//  demo
//
//  Created by huamulou on 14-9-7.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <Toast/UIView+Toast.h>
#import "PinView.h"
#import "URLUtil.h"
#import "Constants.h"
#import "PinDateCell.h"
#import "PinItem.h"
#import "UIView+Extend.h"

#define FLIP_ANIMATION_DURATION 0.18f

@interface PinView () {

    NSMutableArray *_datasource;
    NSDate *_date;
    BOOL _reloading;
    BOOL _inited;
}
@end

@implementation PinView

- (instancetype)initWithFrame:(CGRect)frame withUrl:(NSString *)dataUrl {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataUrl = dataUrl;
        self.delegate = self;
        self.collectionViewDelegate = self;
        self.collectionViewDataSource = self;
        self.autoresizingMask = ~UIViewAutoresizingNone;
        self.numColsPortrait = 2;
        self.backgroundColor = MIAN_VIEW_PIN_BACKGROUND_COLOR;
        self.numColsLandscape = 3;
        _inited = NO;
        [self createHeaderView];
        [self loadData:_dataUrl];

    }

    return self;
}


- (void)loadData:(NSString *)dataUrl {

    NSString *url = @"/openApi/index/getItems";
    NSNumber *page = @1;
    NSNumber *pageSize = @6;
    NSString *urlString = [URLUtil getURLWithParms:[NSMutableDictionary dictionaryWithObjectsAndKeys:page, @"page", pageSize, @"pageSize", nil] withPath:url];
    urlString = [[NSString alloc] initWithFormat:@"%@%@", HTTP_API_BASE_URL, urlString];
    UIActivityIndicatorView *_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.frame = self.bounds;
    [self addSubview:_activityView];
    [_activityView startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager
            GET:urlString
     parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_activityView stopAnimating];
            [_activityView removeFromSuperview];
            NSLog(@"%@", responseObject);
            id code = [responseObject objectForKey:@"code"];
            if ([code isKindOfClass:[NSNumber class]]
                    && [(NSNumber *) code isEqualToNumber:[[NSNumber alloc] initWithInt:200]]) {
                NSDictionary *datas = [responseObject objectForKey:@"data"];
                int i = 0;
                NSMutableArray *imageNames = [NSMutableArray array];
                for (NSDictionary *data in [datas objectForKey:@"items"]) {
                    [imageNames addObject:data];
                    i++;
                }
                _datasource = imageNames;
                _inited= true;
                _date = [[NSDate alloc] initWithTimeIntervalSince1970:[[datas objectForKey:@"lastTime"] intValue] / 1000];

                [self reloadData];
            }

        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_activityView stopAnimating];
            [_activityView removeFromSuperview];
            [[self mainView] makeToast:@"下载瀑布流数据失败"];
            NSLog(@"下载瀑布流数据失败 url - %@ \n\t error-%@", urlString, error);

        }];
}


- (Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index {
    if (index == 0) {
        return [PinDateCell class];
    } else {
        return [PinItem class];
    }
    return nil;
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index {
    NSLog(@"%f", collectionView.contentSize.height);
    NSLog(@"%f-%f", cell.frame.origin.y, cell.frame.size.height);
    NSLog(@"you select number:%d", index);
}

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView {
    if (_inited)
        return _datasource.count + 1;
    return 0;
}

- (UIView *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index {
    NSLog(@"reuse cell");

    if (index == 0) {
        PinDateCell *cell = (PinDateCell *) [self dequeueReusableViewForClass:[PinDateCell class]];
        if (!cell) {
            cell = [[PinDateCell alloc] initWithLastUpdate:_date];
            [cell collectionView:self fillCellWithObject:_date atIndex:index];
        }
        return cell;
    } else {
        NSDictionary *data = [_datasource objectAtIndex:index - 1];
        PinItem *cell = (PinItem *) [self dequeueReusableViewForClass:[PinItem class]];
        if (!cell) {
            cell = [[PinItem alloc] initWithImageUrl:[data objectForKey:@"picUrl"] title:[data objectForKey:@"name"] price:@"￥200"];
            [cell collectionView:self fillCellWithObject:data atIndex:index];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {

    if (index == 0) {
        return [PinDateCell rowHeightForObject:_date inColumnWidth:self.colWidth];
    } else {
        NSDictionary *item = [_datasource objectAtIndex:index - 1];
        return [PinItem rowHeightForObject:item inColumnWidth:self.colWidth];
    }
}


- (void)createHeaderView {
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[RefreashHeader alloc] initWithFrame:
            CGRectMake(0.0f, 0.0f - self.bounds.size.height,
                    self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.delegate = self;

    [self addSubview:_refreshHeaderView];

    [_refreshHeaderView refreshLastUpdatedDate];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_refreshHeaderView) {
        [_refreshHeaderView refreshScrollViewDidScroll:scrollView];
    }
//
//    if (_refreshFooterView) {
//        [_refreshFooterView RefreshScrollViewDidScroll:scrollView];
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_refreshHeaderView) {
        [_refreshHeaderView refreshScrollViewDidEndDragging:scrollView];
    }

//    if (_refreshFooterView) {
//        [_refreshFooterView RefreshScrollViewDidEndDragging:scrollView];
//    }
}

#pragma mark -
#pragma mark RefreshTableDelegate Methods

- (void)refreshTableDidTriggerRefresh:(RefreshPos)aRefreshPos {
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)refreshTableDataSourceIsLoading:(UIView *)view {
    return _reloading; // should return if data source model is reloading
}
//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

- (void)beginToReloadData:(RefreshPos)aRefreshPos {
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    if (aRefreshPos == RefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    } else if (aRefreshPos == RefreshFooter) {
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
    // overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished

- (void)finishReloadingData {

    //  model should call this when its done loading
    _reloading = NO;

    if (_refreshHeaderView) {
        [_refreshHeaderView refreshScrollViewDataSourceDidFinishedLoading:self];
    }

//    if (_refreshFooterView) {
//        [_refreshFooterView RefreshScrollViewDataSourceDidFinishedLoading:self.aoView];
//        [self setFooterView];
//    }

    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}
//

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate *)refreshTableDataSourceLastUpdated:(UIView *)view {

    return [NSDate date]; // should return date data source was last changed

}


//刷新调用的方法
- (void)refreshView {
    //DataAccess *dataAccess= [[DataAccess alloc]init];
    //NSMutableArray *dataArray = [dataAccess getDateArray];
    // [self.aoView refreshView:dataArray];
    [self testFinishedLoadData];

}

//加载调用的方法
- (void)getNextPageView {
    // [self removeFooterView];
    // DataAccess *dataAccess= [[DataAccess alloc]init];
    //NSMutableArray *dataArray = [dataAccess getDateArray];
//    NSMutableArray *testData = [[NSMutableArray alloc]init];
//    for (int i=0; i<9; i++) {
//        [testData addObject:[dataArray objectAtIndex:i]];
//    }
    //[self.aoView getNextPage:dataArray];
    [self testFinishedLoadData];

}

- (void)testFinishedLoadData {

    [self finishReloadingData];
    // [self setFooterView];
}

@end
