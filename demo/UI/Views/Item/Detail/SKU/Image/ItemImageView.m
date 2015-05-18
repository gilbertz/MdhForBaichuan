//
//  ItemImageView.m
//  demo
//
//  Created by huamulou on 14-9-29.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "ItemImageView.h"

@implementation ItemImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scroll.delegate = self;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _image;
}

#pragma mark 当缩放完毕的时候调用

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    NSLog(@"结束缩放 - %f", scale);
//    float width = scale * _image.image.size.width;
//    float height = scale * _image.image.size.height;
//
//    float tmpWidth;
//    float tmpHeight;
//    if (width < view.bounds.size.width) {
//        tmpWidth = view.bounds.size.width;
//    } else {
//        tmpWidth = width;
//    }
//    if (height < view.bounds.size.height) {
//        tmpHeight = view.bounds.size.height;
//    } else {
//        tmpHeight = height;
//    }
//    _scroll.contentSize = CGSizeMake(tmpWidth, tmpHeight);
//
//    _image.center = CGPointMake(_scroll.contentSize.width/2, _scroll.contentSize.height/2);


}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"-----");
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;

    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。

    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? \

            scrollView.contentSize.width/2 : xcenter;

    //同上，此处修改y值

    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? \

            scrollView.contentSize.height/2 : ycenter;

    [_image setCenter:CGPointMake(xcenter, ycenter)];


}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {


}



@end
