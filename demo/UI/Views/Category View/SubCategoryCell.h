//
// Created by huamulou on 14-9-11.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SubCategoryCell : UICollectionViewCell


@property(strong, nonatomic) IBOutlet UIImageView *imageView;
@property(strong, nonatomic) IBOutlet UILabel *nameLabel;


@property(nonatomic, retain) NSDictionary *data;

- (instancetype)initWithFrame:(CGRect)frame;

@end