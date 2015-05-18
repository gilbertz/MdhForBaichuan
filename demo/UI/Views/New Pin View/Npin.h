//
//  Npin.h
//  demo
//
//  Created by huamulou on 14-9-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NView;

@protocol NCellDelegate

@property(nonatomic, retain) id data;
@property(nonatomic, retain) UICollectionView *collectionView;

+ (CGFloat)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth;

//+ (CGFloat)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth image:(UIImage *)image;
@end


@interface Npin : NSObject

@end
