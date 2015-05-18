//
// Created by huamulou on 14-9-9.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PinView.h"

#import "RefreashCommon.h"


@interface RefreashFooter : UIView {
    PullRefreshState _state;

}



@property(nonatomic,assign) id <RefreshTableDelegate> delegate;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
- (void)refreshLastUpdatedDate;
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
@end