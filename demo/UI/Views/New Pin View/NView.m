//
//  NView.m
//  demo
//
//  Created by huamulou on 14-9-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "NView.h"
#import "Constants.h"
#import "NDateCell.h"
#import "NItemCell.h"
#import "URLUtil.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIView+Toast.h"
#import "BannerFrame.h"
#import "UIView+Extend.h"

#define BANNER_HEADER_IDENTIFIER @"BannerFrame"

@interface NView () {
    BOOL _reading;
}
@property(nonatomic, strong) NSMutableDictionary *cellSizes;
@property(nonatomic, strong) NSMutableArray *dataFromUrl;
@property(nonatomic, retain) NSDate *date;
@property(nonatomic, assign) double timeDouble;
@property(nonatomic, assign) int page;

@property(nonatomic, retain) NSString *url;


@end

@implementation NView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        _dataFromUrl = [[NSMutableArray alloc] init];
        _page = 1;


        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];

        layout.sectionInset = UIEdgeInsetsMake(DEFAULT_SPACE, DEFAULT_SPACE, DEFAULT_SPACE, DEFAULT_SPACE);
        layout.headerHeight = MAIN_VIEW_BANNER_IMAGE_VIEW_HEIGHT;
        self.backgroundColor = MIAN_VIEW_PIN_BACKGROUND_COLOR;
        layout.minimumColumnSpacing = DEFAULT_SPACE;
        layout.minimumInteritemSpacing = DEFAULT_SPACE;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[NDateCell class] forCellWithReuseIdentifier:@"NDateCell"];
        [_collectionView registerClass:[NItemCell class] forCellWithReuseIdentifier:@"NItemCell"];

        [_collectionView registerClass:[BannerFrame class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:BANNER_HEADER_IDENTIFIER];
        [self addSubview:_collectionView];
        [self createHeaderView];


        _reading = NO;
    }

    return self;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataFromUrl) {
        if ([_dataFromUrl count] == 0) {
            return 0;
        }
        return [_dataFromUrl count] + 1;
    }
    return 0;
}

//设置分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    int index = indexPath.item;
    NSLog(@"reuse cell item - %d section -%d row -%d", indexPath.item, indexPath.section, indexPath.row);
    NSNumber *key = [NSNumber numberWithInteger:indexPath.item];
    if (index == 0) {
        NDateCell *cell = (NDateCell *) [_collectionView dequeueReusableCellWithReuseIdentifier:@"NDateCell" forIndexPath:indexPath];
        if (!cell) {
        }
        [cell setData:_date];
//       cell.backgroundColor = [UIColor blackColor];
        return cell;
    } else {
        NSDictionary *data = [_dataFromUrl objectAtIndex:index - 1];
        NItemCell *cell = (NItemCell *) [_collectionView dequeueReusableCellWithReuseIdentifier:@"NItemCell" forIndexPath:indexPath];
        if (!cell) {
        }
        [cell setData:data size:[[_cellSizes objectForKey:key] CGSizeValue]];
        return cell;
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *reusableView = nil;
//
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:BANNER_HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
        BannerFrame *bannerFrame = (BannerFrame *) reusableView;
        NSString *baseUrl = MAIN_VIEW_BANNER_API_URL;

        NSString *realUrl = [URLUtil getURLWithParms:nil withPath:baseUrl];
        realUrl = [NSString stringWithFormat:@"%@%@", HTTP_API_BASE_URL, realUrl];
        [bannerFrame setDataUrl:realUrl];
        bannerFrame.clickCB = _cellClickCB;
    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
    }

    return reusableView;
}


- (void)setUrl:(NSString *)url successCB:(void (^)(void))successCB failedCB:(void (^)(void))failedCB {
    _url = url;
    [self loadData:url time:0 page:1 atHead:NO successCB:successCB failedCB:failedCB];
}

- (void)loadData:(NSString *)dataUrl time:(double)time page:(NSInteger)page atHead:(BOOL)atHead successCB:(void (^)(void))successCB failedCB:(void (^)(void))failedCB {
    NSNumber *oPage = page ? [NSNumber numberWithInteger:page] : @1;
    _page = [oPage intValue];
    NSNumber *pageSize = [[NSNumber alloc] initWithInt:HTTP_API_DEFAULT_PAGESIZE];
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithObjectsAndKeys:oPage, @"page", pageSize, @"pageSize", nil];
    if (time > 0) {
        [parms setObject:[NSNumber numberWithDouble:time] forKey:@"time"];
    }
    NSString *urlString = [URLUtil getURLWithParms:parms withPath:dataUrl];
    urlString = [[NSString alloc] initWithFormat:@"%@%@", HTTP_API_BASE_URL, urlString];
    UIActivityIndicatorView *_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.frame = self.bounds;
    [self addSubview:_activityView];
    [_activityView startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"load mian view quit data from url : %@", urlString);
    [manager
            GET:urlString
     parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (successCB) {
                successCB();
            }
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

                if (atHead) {
                    NSMutableArray *newDatas = [imageNames mutableCopy];
                    [newDatas addObjectsFromArray:_dataFromUrl];
                    _dataFromUrl = newDatas;
                } else {
                    [_dataFromUrl addObjectsFromArray:imageNames];
                }
                _timeDouble = [[datas objectForKey:@"lastTime"] doubleValue];
                _date = [[NSDate alloc] initWithTimeIntervalSince1970:(_timeDouble / 1000)];

                [_collectionView reloadData];
                [_collectionView layoutIfNeeded];
                if (_collectionView.contentSize.height < _collectionView.frame.size.height) {
                    _collectionView.contentSize = CGSizeMake(_collectionView.frame.size.width, _collectionView.frame.size.height + 2 * DEFAULT_SPACE);
                }
                [self setFooterView];
            } else {
                [[self mainView] makeToast:[responseObject valueForKey:@"msg"] ? [responseObject valueForKey:@"msg"] : @"下载瀑布流数据失败"];
            }

        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failedCB) {
                failedCB();
            }
            [_activityView stopAnimating];
            [_activityView removeFromSuperview];
            [[self mainView] makeToast:@"下载瀑布流数据失败"];
            NSLog(@"下载瀑布流数据失败 url - %@ \n\t error-%@", urlString, error);

        }];
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!_cellSizes) {
        _cellSizes = [[NSMutableDictionary alloc] init];
    }

    NSNumber *key = [NSNumber numberWithInteger:indexPath.item];
    id sellSizeId = [_cellSizes objectForKey:key];

    if (sellSizeId) {
        return [sellSizeId CGSizeValue];
    } else {

        CGFloat width = (SCREEN_WIDTH - 3 * DEFAULT_SPACE) / 2;
        CGFloat height;
        if (indexPath.item == 0) {
            height = [NDateCell rowHeightForObject:nil inColumnWidth:width];
        } else {
            height = [NItemCell rowHeightForObject:[_dataFromUrl objectAtIndex:indexPath.item - 1] inColumnWidth:width];

        }
        CGSize size = CGSizeMake(width, height);
        [_cellSizes setObject:[NSValue valueWithCGSize:size] forKey:key];
        return size;
    }

}

#pragma mark - 某个item的点击事件

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"select item of %@ item - %d", indexPath, indexPath.item);
    if (indexPath.item > 0) {
        NSDictionary *data = [_dataFromUrl objectAtIndex:indexPath.item - 1];

        _cellClickCB(data);
    }


}

#pragma mark - 生成下拉刷新和上拉刷新

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
    [self loadData:_url time:_timeDouble page:1 atHead:YES successCB:nil failedCB:nil];
    [self finishReloadingData];

//    [self testFinishedLoadData];

}


//加载调用的方法
- (void)getNextPageView {
    [self loadData:_url time:0 page:_page + 1 atHead:NO successCB:nil failedCB:nil];
    [self finishReloadingData];

}


@end
