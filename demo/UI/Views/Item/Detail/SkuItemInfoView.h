//
//  SkuItemInfoView.h
//  demo
//
//  Created by huamulou on 14-9-16.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIAttributedLabel;

@interface SkuItemInfoView : UIView
@property(weak, nonatomic) IBOutlet UIImageView *mainImage;
@property(weak, nonatomic) IBOutlet UIImageView *shopTypeLogo;
@property(weak, nonatomic) IBOutlet NIAttributedLabel *titleLable;
@property(weak, nonatomic) IBOutlet UILabel *priceLable;
@property(weak, nonatomic) IBOutlet UILabel *selectedLabel;
@property(weak, nonatomic) IBOutlet UILabel *stockLabel;


@property(nonatomic, retain) NSString *mainImageUrl;
@property(nonatomic, assign) BOOL isTmall;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *price;
@property(nonatomic, retain) NSString *selected;
@property(nonatomic, retain) NSString *stock;

- (CGFloat)getHeight;
@end
