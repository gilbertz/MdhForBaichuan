//
// Created by huamulou on 14-9-9.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#ifndef TableViewRefresh_ViewCommon_h
#define TableViewRefresh_ViewCommon_h

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

#define  REFRESH_REGION_HEIGHT 65.0f

typedef enum{
    PullRefreshPulling = 0,
    PullRefreshNormal,
    PullRefreshLoading,
} PullRefreshState;

typedef enum{
    RefreshHeader = 0,
    RefreshFooter
} RefreshPos;

@protocol RefreshTableDelegate<NSObject>
- (void)refreshTableDidTriggerRefresh:(RefreshPos)aRefreshPos;
- (BOOL)refreshTableDataSourceIsLoading:(UIView*)view;
@optional
- (NSDate*)refreshTableDataSourceLastUpdated:(UIView*)view;
@end

#endif
