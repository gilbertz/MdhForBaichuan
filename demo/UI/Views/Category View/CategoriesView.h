//
// Created by huamulou on 14-9-11.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FatherCategorySeleted <NSObject>

@required
- (void)didSeletedFatherCategory:(NSDictionary *)data;
@end

@interface CategoriesView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>
- (id)initWithFrame:(CGRect)frame;

@property(nonatomic, assign) id <FatherCategorySeleted> categoryDelegate;
@property(nonatomic, retain) NSString *url;


- (void)loadWithUrl:(NSString *)url successCB:(void (^)(void))succCB failedCB:(void (^)(void))failCB;
@end