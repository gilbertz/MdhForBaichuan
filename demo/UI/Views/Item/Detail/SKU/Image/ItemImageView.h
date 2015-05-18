//
//  ItemImageView.h
//  demo
//
//  Created by huamulou on 14-9-29.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemImageView : UIView <UIScrollViewDelegate>
@property(weak, nonatomic) IBOutlet UIImageView *image;
@property(weak, nonatomic) IBOutlet UIScrollView *scroll;


@property(nonatomic, assign) CGRect fromFrame;

@end
