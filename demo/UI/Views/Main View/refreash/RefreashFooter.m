//
// Created by huamulou on 14-9-9.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import "RefreashFooter.h"
#import "Constants.h"


@interface RefreashFooter(Private)
-(void)setState:(PullRefreshState) aState;
@end

@implementation RefreashFooter {

}

@synthesize delegate=_delegate;
- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor {

        CGRect tmp = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"RefreashFooterView" owner:self options:nil];

        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1) {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[RefreashFooter class]]) {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = MIAN_VIEW_PIN_BACKGROUND_COLOR;
//        self.backgroundColor = [UIColor yellowColor];
        [self setState:PullRefreshNormal];
        self.frame = tmp;
        NSLog(@"frame is %@", [NSValue valueWithCGRect:tmp]);
        return self;


}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {

    if ( [self.delegate respondsToSelector:@selector(refreshTableDataSourceLastUpdated:)]) {

    } else {


    }

}

- (void)setState:(PullRefreshState)aState {

    switch (aState) {
        case PullRefreshPulling:

            _activityView.hidden = YES;
            [_activityView stopAnimating];
            break;
        case PullRefreshNormal:

//            if (_state == PullRefreshPulling) {
//                [CATransaction begin];
//                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
//                _arrowImage.transform = CATransform3DIdentity;
//                [CATransaction commit];
//            }
//
//            _statusLabel.text = NSLocalizedString(@"Pull up to load more...", @"Pull up to load more");
//            [_activityView stopAnimating];
//            [CATransaction begin];
//            [CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions];
//            _arrowImage.hidden = NO;
//            //_arrowImage.transform = CATransform3DIdentity;
//            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
//            [CATransaction commit];
            _activityView.hidden = YES;
            [_activityView stopAnimating];

            break;
        case PullRefreshLoading:
            _activityView.hidden = NO;
            [_activityView startAnimating];

            break;
        default:
            break;
    }

    _state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {

    if (_state == PullRefreshLoading) {

        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, REFRESH_REGION_HEIGHT, 0.0f);

    } else if (scrollView.isDragging) {

        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(refreshTableDataSourceIsLoading:)]) {
            _loading = [_delegate refreshTableDataSourceIsLoading:self];
        }

        if (_state == PullRefreshPulling &&
                (scrollView.contentOffset.y + scrollView.frame.size.height) < scrollView.contentSize.height + REFRESH_REGION_HEIGHT &&
                scrollView.contentOffset.y > 0.0f && !_loading) {
            [self setState:PullRefreshNormal];
        } else if (_state == PullRefreshNormal &&
                scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + REFRESH_REGION_HEIGHT && !_loading) {
            [self setState:PullRefreshPulling];
        }

        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }

    }

}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {

    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(refreshTableDataSourceIsLoading:)]) {
        _loading = [_delegate refreshTableDataSourceIsLoading:self];
    }

    if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + REFRESH_REGION_HEIGHT && !_loading) {

        if ([_delegate respondsToSelector:@selector(refreshTableDidTriggerRefresh:)]) {
            [_delegate refreshTableDidTriggerRefresh:RefreshFooter];
        }

        [self setState:PullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, REFRESH_REGION_HEIGHT, 0.0f);
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