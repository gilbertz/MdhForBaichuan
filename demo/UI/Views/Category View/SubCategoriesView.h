//
// Created by huamulou on 14-9-11.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SubCategorySeleted <NSObject>

@required
- (void)didSeletedSubCategory:(NSDictionary *)data;
@end

@interface SubCategoriesView :  UIView <UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic, assign) id <SubCategorySeleted> subCategoryDelegate;
@property (nonatomic, retain)UICollectionView *collectionView;
@property (nonatomic, retain)UILabel *labelView;
- (id)initWithFrame:(CGRect)frame;
- (void)loadWithUrl:(NSString *)url name:(NSString *)name;
@end