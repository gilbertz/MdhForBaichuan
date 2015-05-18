//
// Created by huamulou on 14-9-11.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "SubCategoryCell.h"
#import "Constants.h"
#import "NSString+Extend.h"


@implementation SubCategoryCell {

}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    //     self.backgroundColor = [UIColor blackColor];

        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SubCategoryView" owner:self options:nil];

        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }

    return self;
}


- (void)setData:(NSDictionary *)data {
    _data = data;


    //self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CATEGORY_SUB_CELL_WIDTH, CATEGORY_SUB_CELL_IMAGE_HEIGHT)];

    [_imageView  sd_setImageWithURL:[NSURL URLWithString:[data objectForKey:@"pic"]] placeholderImage:PLACE_HOLDER_IMAGE];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    //self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CATEGORY_SUB_CELL_IMAGE_HEIGHT, CATEGORY_SUB_CELL_WIDTH, CATEGORY_SUB_CELL_HEIGHT - CATEGORY_SUB_CELL_IMAGE_HEIGHT)];
    _nameLabel.attributedText = [[data objectForKey:@"name"] attributedStringWithChineseFontSize:12 withNumberAndLetterFontSize:12 withLineSpacing:0];
    
}

@end