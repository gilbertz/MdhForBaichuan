//
// Created by huamulou on 14-9-11.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import <Toast/UIView+Toast.h>
#import "SubCategoriesView.h"
#import "SubCategoryCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "Constants.h"
#import "UIView+Extend.h"
#import "NSString+Extend.h"


@implementation SubCategoriesView {

    NSIndexPath *_lastIndexPath;
    NSMutableArray *_datasource;
}


- (id)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithFrame:frame];
    if (self) {

//        _labelView = [[UILabel alloc]
//                initWithFrame:CGRectMake(ZERO, ZERO, CATEGORY_SUB_VIEW_WIDTH, CATEGORY_SUB_VIEW_LABEL_HEIGHT)];
//        _labelView.textColor = [UIColor colorWithHexString:@"#999898"];
//        [self addSubview:_labelView];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(ZERO, DEFAULT_SPACE, CATEGORY_SUB_VIEW_WIDTH, self.frame.size.height - CATEGORY_SUB_VIEW_LABEL_HEIGHT) collectionViewLayout:flowLayout];
        //self.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];

        [self addSubview:_collectionView];
        [_collectionView registerClass:[SubCategoryCell class] forCellWithReuseIdentifier:@"SubCategoryCell"];

    }

    return self;

}


- (void)loadWithUrl:(NSString *)url name:(NSString *)name {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager
            GET:url
     parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //  NSLog(@"%@", responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                id code = [responseObject objectForKey:@"code"];
                if ([code isKindOfClass:[NSNumber class]]
                        && [(NSNumber *) code isEqualToNumber:[[NSNumber alloc] initWithInt:200]]) {
                    NSMutableArray *datas = [responseObject objectForKey:@"data"];
                    _datasource = datas;
                    _collectionView.contentSize = CGSizeMake(CATEGORY_SUB_VIEW_WIDTH, (CATEGORY_SUB_CELL_IMAGE_HEIGHT + CATEGORY_SUB_CELL_LABEL_HEIGHT + DEFAULT_SPACE) * (datas.count / 3 + (datas.count % 3 == 0 ? 0 : 1)));

                    // NSLog(@"下载分类数据成功,url- %@, \n name-%@", url, name);
                    _labelView.attributedText = [name attributedStringWithChineseFontSize:CATEGORY_SUB_VIEW_LABEL_FONT_SIZE withNumberAndLetterFontSize:CATEGORY_SUB_VIEW_LABEL_FONT_SIZE withLineSpacing:0];
                    [_collectionView reloadData];

                }

            } else {
                NSLog(@"下载分类数据失败,url- %@, data-%@", url, responseObject);
                [[self mainView] makeToast:@"下载分类数据失败"];
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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

    SubCategoryCell *cell = (SubCategoryCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"SubCategoryCell" forIndexPath:indexPath];

    if (!cell) {
    }
    // cell.frame = CGRectMake(0,  indexPath.row * 46, 78,46);
    NSDictionary *data = [_datasource objectAtIndex:indexPath.row];
    cell.data = data;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    _lastIndexPath = indexPath;
    //[_collectionView reloadData];

    NSDictionary *data = [_datasource objectAtIndex:indexPath.row];
    if (self.subCategoryDelegate && [self.subCategoryDelegate respondsToSelector:@selector(didSeletedSubCategory:)]) {
        [self.subCategoryDelegate didSeletedSubCategory:data];
    }


    NSLog(@"select row -  %d, item-%d, section -%d", indexPath.row, indexPath.item, indexPath.section);
}

#pragma mark - collectionView delegate

//设置分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


#pragma mark - UICollectionViewDelegateFlowLayout

// 定义cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(CATEGORY_SUB_CELL_WIDTH, CATEGORY_SUB_CELL_HEIGHT);
    return size;
}

//设置元素的的大小框
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionViewlayout :(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}


@end