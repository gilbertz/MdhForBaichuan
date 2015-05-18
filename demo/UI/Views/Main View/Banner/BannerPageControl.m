//
// Created by huamulou on 14-9-5.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import "BannerPageControl.h"
#import "UIImage+Tint.h"


@implementation BannerPageControl {

}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _activeImage = [UIImage imageNamed:@"main_banner_dot_s"];
        _inactiveImage = [UIImage imageNamed:@"main_banner_dot"];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame activeColor:(UIColor *)activeColor inactiveColor:(UIColor *)inactiveColor {
    self = [super initWithFrame:frame];
    if (self) {
        self.activeColor = activeColor;
        self.inactiveColor = inactiveColor;
        if (self.activeColor) {
            _activeImage = [[UIImage imageNamed:@"main_banner_dot_s"] imageWithGradientTintColor:self.activeColor];
        } else {
            _activeImage = [UIImage imageNamed:@"main_banner_dot_s"];
        }

        if (self.inactiveColor) {
            _inactiveImage = [[UIImage imageNamed:@"main_banner_dot_s"] imageWithGradientTintColor:self.inactiveColor];
        } else {
            _inactiveImage = [UIImage imageNamed:@"main_banner_dot_s"];
        }
    }
    return self;
}



- (void)setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];
    [self updateDots];
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView * dot = [self imageViewForSubview:  [self.subviews objectAtIndex: i]];
        if (i == self.currentPage) {
            dot.image = _activeImage;
        }
        else {
           dot.image = _inactiveImage; 
        }
    }
}
- (UIImageView *) imageViewForSubview: (UIView *) view
{
    view.backgroundColor = [UIColor clearColor];
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]])
    {
        for (UIView* subview in view.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
    }
    else
    {
        dot = (UIImageView *) view;
    }

    return dot;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   // Drawing code
}
*/


@end