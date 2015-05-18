//
// Created by huamulou on 14-9-9.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import "RefreashHeader.h"
#import "Constants.h"

@interface RefreashHeader (Private)

@end

@implementation RefreashHeader {

}
- (id)initWithFrame:(CGRect)frame {
    CGRect tmp = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    // 初始化时加载collectionCell.xib文件
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"RefreashHeader" owner:self options:nil];

    // 如果路径不存在，return nil
    if (arrayOfViews.count < 1) {
        return nil;
    }
    // 如果xib中view不属于UICollectionViewCell类，return nil
    if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[RefreashHeader class]]) {
        return nil;
    }
    // 加载nib
    self = [arrayOfViews objectAtIndex:0];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = MIAN_VIEW_PIN_BACKGROUND_COLOR;
    self.contentView.backgroundColor = MIAN_VIEW_PIN_BACKGROUND_COLOR;    \
    self.titleLabel.textColor = VIEW_THEME_COLOR;
    [self setState:PullRefreshNormal];
    self.frame = tmp;
    //self.backgroundColor = [UIColor yellowColor];
    _contentView.backgroundColor = [UIColor clearColor];

    // _contentView.frame = CGRectMake(0.0f, tmp.size.height - _contentView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height);
    // NSLog(@"_contentView frame is %@", _contentView.frame);
    //   self.frame = frame;
    //    [super drawBorder];
//    }
    return self;





}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {

    if ([_delegate respondsToSelector:@selector(refreshTableDataSourceLastUpdated:)]) {
//

    } else {

    }

}

- (void)setState:(PullRefreshState)aState {

    switch (aState) {
        case PullRefreshPulling:
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            _activityView.hidden = YES;
            [UIView beginAnimations:@"Release to refresh status" context:nil];
            [UIView setAnimationDuration:FLIP_ANIMATION_DURATION];
            _titleLabel.text = NSLocalizedString(@"可以松开了...", @"Release to refresh status");
            _arrowImageView.transform = CGAffineTransformMakeRotation((M_PI));// ((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [UIView commitAnimations];

            break;
        case PullRefreshNormal:
            _activityView.hidden = YES;
            if (_state == PullRefreshPulling) {
                [UIView beginAnimations:@"PullRefreshNormal" context:nil];
                [UIView setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImageView.transform = CGAffineTransformIdentity;
                [UIView commitAnimations];
            }

            _titleLabel.text = NSLocalizedString(@"下拉即可刷新...", @"Pull down to refresh status");
            [_activityView stopAnimating];
            [UIView beginAnimations:@"PullRefreshNormal 11" context:nil];
            [UIView setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImageView.hidden = NO;
            _arrowImageView.transform = CGAffineTransformIdentity;
            [UIView commitAnimations];

            [self refreshLastUpdatedDate];

            break;
        case PullRefreshLoading:
            _activityView.hidden = NO;

            [_activityView startAnimating];
            _titleLabel.text = NSLocalizedString(@"奋力加载中...", @"Loading Status");
            [UIView beginAnimations:@"PullRefreshLoading 11" context:nil];
            [UIView setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImageView.hidden = YES;

            [UIView commitAnimations];

            break;
        default:
            break;
    }

    _state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {
//	NSLog(@"refreshScrollViewDidScroll scrollView.contentOffset.y= %f", scrollView.contentOffset.y);
    if (_state == PullRefreshLoading) {

        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);

    } else if (scrollView.isDragging) {

        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(refreshTableDataSourceIsLoading:)]) {
            _loading = [_delegate refreshTableDataSourceIsLoading:self];
        }

        if (_state == PullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
            [self setState:PullRefreshNormal];
        } else if (_state == PullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
            [self setState:PullRefreshPulling];
        }

        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }

    }

}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    //NSLog(@"refreshScrollViewDidEndDragging scrollView.contentOffset.y= %f", scrollView.contentOffset.y);
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(refreshTableDataSourceIsLoading:)]) {
        _loading = [_delegate refreshTableDataSourceIsLoading:self];
    }

    if (scrollView.contentOffset.y <= -65.0f && !_loading) {

        if ([_delegate respondsToSelector:@selector(refreshTableDidTriggerRefresh:)]) {
            [_delegate refreshTableDidTriggerRefresh:RefreshHeader];
        }

        [self setState:PullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];

    }

}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];

    [self setState:PullRefreshNormal];

}


@end