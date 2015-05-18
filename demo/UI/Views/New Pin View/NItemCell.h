//
//  NItemCell.h
//  demo
//
//  Created by huamulou on 14-9-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Npin.h"

@interface NItemCell : UICollectionViewCell<NCellDelegate>


@property(nonatomic, assign) NSString *imageUrl;
@property(nonatomic, assign) NSString *title;
@property(nonatomic, assign) NSInteger tbItemId;
@property(nonatomic, assign) NSString *discountPrice;
@property(nonatomic, assign) NSString *price;
- (void)setData:(id)data size:(CGSize)size;
@end
