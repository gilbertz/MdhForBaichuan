//
// Created by huamulou on 14-9-11.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import "CategoriesView.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIView+Toast.h"
#import "CategoryCell.h"
#import "UIView+Extend.h"
#import "NSString+Extend.h"


@implementation CategoriesView {
    NSMutableArray *_categoryItems;
    NSInteger _lastSeleted;
    NSArray *_datasource;

}


- (id)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {

        _lastSeleted = 0;
        [self setUpViews];
      //  [self loadWithUrl:url];
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
    }

    return self;

}


- (void)setUpViews {

    self.dataSource = self;
    self.delegate = self;
    [self registerClass:[CategoryCell class] forCellWithReuseIdentifier:@"CategoryCell"];

}


- (void)loadWithUrl:(NSString *)url successCB:(void (^)(void))succCB failedCB:(void (^)(void))failCB {
    self.url = url;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager
            GET:url
     parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"%@", responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if(succCB){
                    succCB();
                }
                id code = [responseObject objectForKey:@"code"];
                if ([code isKindOfClass:[NSNumber class]]
                        && [(NSNumber *) code isEqualToNumber:[[NSNumber alloc] initWithInt:200]]) {

                    NSMutableArray *datas = [responseObject objectForKey:@"data"];
                    _datasource = datas;
                    self.contentSize = CGSizeMake(78, 46 * datas.count);
                   // NSLog(@"下载分类数据成功,url- %@", url);

                    [self reloadData];
                }

            } else {
                if(failCB){
                    failCB();
                }
                NSLog(@"下载分类数据失败,url- %@, data-%@", url, responseObject);
                [[self mainView] makeToast:@"下载分类数据失败"];
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(failCB){
                failCB();
            }
            NSLog(@"下载分类数据失败,url- %@, error-%@", url, error);
            [[self mainView] makeToast:@"下载分类数据失败"];
        }
    ];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_datasource) {
        return [_datasource count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    CategoryCell *cell = (CategoryCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];

    if (!cell) {
    }
    // cell.frame = CGRectMake(0,  indexPath.row * 46, 78,46);
    NSDictionary *data = [_datasource objectAtIndex:indexPath.row];
    cell.nameLabel.attributedText = [[data objectForKey:@"name"] attributedStringWithChineseFontSize:14 withNumberAndLetterFontSize:14 withLineSpacing:0];
    cell.name = [data objectForKey:@"name"];
    cell.id = [[data objectForKey:@"id"] intValue];
    cell.sequence = [[data objectForKey:@"sequence"] intValue];
    cell.pic = [data objectForKey:@"pic"];
    if (indexPath.item == _lastSeleted) {
        [self notifySubCategoriesView:data];
        [cell onSelect];
    } else {
        [cell offSelect];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    _lastSeleted = indexPath.item;
    [self reloadData];
    NSDictionary *data = [_datasource objectAtIndex:_lastSeleted];
    NSLog(@"seleted %@", data);
    [self notifySubCategoriesView:data];

    NSLog(@"select row -  %d, item-%d, section -%d", indexPath.row, indexPath.item, indexPath.section);
}

- (void)notifySubCategoriesView:(NSDictionary *)data {

    if (self.categoryDelegate && [self.categoryDelegate respondsToSelector:@selector(didSeletedFatherCategory:)]) {
        [self.categoryDelegate didSeletedFatherCategory:data];
    }

}

#pragma mark - collectionView delegate

//设置分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


#pragma mark - UICollectionViewDelegateFlowLayout

// 定义cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(78, 46);
    return size;
}

//设置元素的的大小框
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionViewlayout :(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end