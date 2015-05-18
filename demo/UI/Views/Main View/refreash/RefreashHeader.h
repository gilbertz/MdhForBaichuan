//
// Created by huamulou on 14-9-9.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreashCommon.h"
#import <QuartzCore/QuartzCore.h>
@interface RefreashHeader : UIView   {
    PullRefreshState _state;

  //  UILabel *_statusLabel;
  //  CALayer *_arrowImage;
}


@property(nonatomic,assign) id <RefreshTableDelegate> delegate;

- (void)setState:(PullRefreshState)aState;

- (id)initWithFrame:(CGRect)frame ;

- (void)refreshLastUpdatedDate;
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end