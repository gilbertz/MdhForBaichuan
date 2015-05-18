//
// Created by huamulou on 14-9-5.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BannerItem.h"
#import "CustomPageControl.h"

@class BannerFrame;


#pragma mark - SGFocusImageFrameDelegate

@protocol BannerItemSelectDelegate <NSObject>

- (void)click:(BannerFrame *)imageFrame didSelectItem:(BannerItem *)item;

@end


@interface BannerFrame : UICollectionReusableView <UIGestureRecognizerDelegate, UIScrollViewDelegate, PageControlDelegate>


@property (nonatomic, assign)NSString *dataUrl;
@property(nonatomic, copy) void (^clickCB)(NSDictionary *data);

- (void)onClick:(UIButton *)sender;

@end