//
//  SkuItemInfoView.m
//  demo
//
//  Created by huamulou on 14-9-16.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "SkuItemInfoView.h"
#import "NIAttributedLabel.h"
#import "Constants.h"
#import "NSString+Extend.h"

@implementation SkuItemInfoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {



    }
    return self;
}


- (CGFloat)getHeight {

    return self.frame.size.height;
}


- (void)setMainImageUrl:(NSString *)mainImageUrl {
    _mainImageUrl = mainImageUrl;
    [_mainImage sd_setImageWithURL:[NSURL URLWithString:_mainImageUrl]];
//    _mainImage.contentMode =;
}

- (void)setIsTmall:(BOOL)isTmall {
    _isTmall = isTmall;

    if (isTmall) {
        _shopTypeLogo.image = [UIImage imageNamed:@"tmall_logo_tag"];

    } else {
        _shopTypeLogo.image = [UIImage imageNamed:@"taobao_logo_tag"];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLable.attributedText = [title attributedStringWithChineseFontSize:16 withNumberAndLetterFontSize:16];
}

- (void)setPrice:(NSString *)price {
    _price = price;
    _priceLable.attributedText = [[NSString stringWithFormat:@"%@%@", YUAN, price] attributedStringWithChineseFontSize:14 withNumberAndLetterFontSize:14];
    CGFloat textWidth = [_priceLable.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) withTextFont:_priceLable.font withLineSpacing:0].width;
    _priceLable.frame = CGRectMake(_priceLable.frame.origin.x, _priceLable.frame.origin.y, textWidth, _priceLable.frame.size.height);
    _stockLabel.frame = CGRectMake(CGRectGetMaxX(_priceLable.frame), _stockLabel.frame.origin.y, _stockLabel.frame.size.width, _stockLabel.frame.size.height);
}

- (void)setSelected:(NSString *)selected {
    _selected = selected;
    _selectedLabel.attributedText = [[NSString stringWithFormat:@"%@%@", @"选择", selected] attributedStringWithChineseFontSize:12 withNumberAndLetterFontSize:12];
}

- (void)setStock:(NSString *)stock {
    _stock = stock;
    NSString *sttext = [NSString stringWithFormat:@"%@%@%@", @"（库存", stock, @"件）"];
    _stockLabel.attributedText = [sttext attributedStringWithChineseFontSize:12 withNumberAndLetterFontSize:12];
    CGFloat textWidth = [sttext boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) withTextFont:_priceLable.font withLineSpacing:0].width;
    _stockLabel.frame = CGRectMake(CGRectGetMaxX(_priceLable.frame), _stockLabel.frame.origin.y, textWidth, _stockLabel.frame.size.height);
}


@end
