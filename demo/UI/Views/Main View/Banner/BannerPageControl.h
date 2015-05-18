//
// Created by huamulou on 14-9-5.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BannerPageControl : UIPageControl {
    UIImage *_activeImage;
    UIImage *_inactiveImage;

}
@property(nonatomic, retain) UIColor *activeColor;


@property(nonatomic, retain) UIColor *inactiveColor;

- (id)initWithFrame:(CGRect)frame activeColor:(UIColor *)activeColor inactiveColor:(UIColor *)inactiveColor;

@end