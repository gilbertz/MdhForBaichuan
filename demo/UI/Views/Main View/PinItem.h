//
// Created by huamulou on 14-9-8.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSCollectionView.h"


//@interface PinItem : CellBase
@interface PinItem : PSCollectionViewCell


@property(nonatomic, assign) NSString *imageUrl;
@property(nonatomic, assign) NSString *title;
@property(nonatomic, assign) NSString *price;


- (id)initWithImageUrl:(NSString *)imageUrl title:(NSString *)title price:(NSString *)price;

+ (float)caculateHeightWithFont:(UIFont *)font text:(NSString *)text withWidth:(float)width withLinespacing:(float)linespacing;

+ (float)getImageHeight:(UIImage *)image withWidth:(float)width;

+ (float)getItemHeight:(UIImage *)image withWidth:(float)width withTitle:(NSString *)title;

+ (float)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth;
@end