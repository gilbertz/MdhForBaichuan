//
//  NItemCell.m
//  demo
//
//  Created by huamulou on 14-9-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "NItemCell.h"
#import "Constants.h"
#import "UIFont+FontHeight.h"
#import "SDWebImageManager+GetByUrl.h"
#import "NSString+Extend.h"

@interface NItemCell () {

    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UIView *_contentView;
//    UILabel *
    UIView *_line1;
    BOOL _inited;
}
@end

@implementation NItemCell
@synthesize data = _data;
@synthesize collectionView = _collectionView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _contentView = [[UIView alloc] init];

       // self.layer.shouldRasterize = YES;
        [self addSubview:_contentView];
        [self initBorder];
//        [self setUpViews];

        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];

    }
    return self;
}


- (void)initSubViews {

    _imageView = [[UIImageView alloc] init];
    [_contentView addSubview:_imageView];
    _titleLabel = [[UILabel alloc] init];
    [_contentView addSubview:_titleLabel];

}

- (void)reInit {

    if (_priceLabel) {
        [_priceLabel removeFromSuperview];
        _priceLabel = nil;
    }
    _priceLabel = [[UILabel alloc] init];
    [_contentView addSubview:_priceLabel];
    _priceLabel.font = [UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_PRICE_FONT_SIZE];
    _priceLabel.textColor = MINA_VIEW_PIN_ITEM_FONT_COLOR;

    self.price = nil;
    self.imageUrl = nil;
    self.tbItemId = 0;
    self.discountPrice = nil;
    self.title = nil;
}

- (void)setData:(id)data size:(CGSize)size {
    if (data) {
        [self reInit];

        self.imageUrl = [data objectForKey:@"picUrl"];
        if ([data valueForKey:@"price"]) {
            self.price = [data valueForKey:@"price"];
            self.price = [NSString stringWithFormat:@"%@%@", YUAN, _price];
        }
        self.tbItemId = [[data objectForKey:@"tbItemId"] intValue];
        self.discountPrice = [data valueForKey:@"discountPrice"];
        if (self.discountPrice) {
            self.discountPrice = [NSString stringWithFormat:@"%@%@", YUAN, _discountPrice];
        }
        self.title = [data objectForKey:@"name"];


        [_imageView sd_setImageWithURL:
                        [NSURL URLWithString:_imageUrl]
                      placeholderImage:
                              [UIImage imageNamed:@"item_image_empty"]];


        if (IOS7PLUS)
            _titleLabel.textAlignment = NSTextAlignmentNatural;
        _titleLabel.textColor = MINA_VIEW_PIN_ITEM_FONT_COLOR;

        if (_price && ![_price isEqualToString:@""]) {
            NSMutableAttributedString *priceAttr = [_price attributedStringWithChineseFontSize:MINA_VIEW_PIN_ITEM_PRICE_FONT_SIZE
                                                                   withNumberAndLetterFontSize:MINA_VIEW_PIN_ITEM_PRICE_FONT_SIZE
                                                                               withLineSpacing:0];
            //设置字间距
            long number = -2.0f;
            [priceAttr addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat: number]   range:NSMakeRange(0,1)];
            _priceLabel.attributedText =priceAttr ;
        }

        _imageView.backgroundColor = MINA_VIEW_PIN_ITEM_BACKGROUND_COLOR;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        [self setUpViews:size];
    }
}


+ (float)caculateHeightWithFont:(NSInteger)fontSize text:(NSString *)text withWidth:(float)width withLinespacing:(float)linespacing {

    CGSize size = [text getRectSizeOfStringWithFontSize:fontSize withLineSpacing:linespacing withBoundingRect:CGSizeMake(width, CGFLOAT_MAX)];
    return size.height;


}


+ (float)getImageHeight:(UIImage *)image withWidth:(float)width {
    float rate = width / image.size.width;
    float height = image.size.height;
    if (rate < 1) {
        height = height * rate;
    }
    return height;

}


+ (float)getItemHeight:(UIImage *)image withWidth:(float)width withTitle:(NSString *)title price:(NSString *)price {


    float imageHeight = [NItemCell getImageHeight:image withWidth:width];

    float titleFontHeight = [[UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE] getHeight];
    float linespacing = MINA_VIEW_PIN_ITEM_TITLE_LINE_HEIGHT - titleFontHeight;
    float titleHeight = [NItemCell caculateHeightWithFont:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE text:title withWidth:width - (MIAN_VIEW_PIN_ITEM_BORDER_WIDTH * 2) - (DEFAULT_SPACE_WITHLABEL * 2)
                                          withLinespacing:linespacing];
    float priceHeight = 0;
    if (price)
        priceHeight = [NItemCell caculateHeightWithFont:MINA_VIEW_PIN_ITEM_PRICE_FONT_SIZE text:@"￥200" withWidth:CGFLOAT_MAX withLinespacing:0];


    NSLog(@"index-%d, imageHeight-%f, titleHeight-%f, priceHeight-%f", 0, imageHeight, titleHeight, priceHeight);
    return imageHeight + DEFAULT_SPACE_WITHLABEL + titleHeight + (priceHeight > 0 ? (priceHeight + 3 * DEFAULT_SPACE) : DEFAULT_SPACE) + MIAN_VIEW_PIN_ITEM_BORDER_WIDTH;

}


- (void)setUpViews:(CGSize)size {
    float width = self.bounds.size.width - (MIAN_VIEW_PIN_ITEM_BORDER_WIDTH * 2);
//    int height = self.bounds.size.height - (MIAN_VIEW_PIN_ITEM_BORDER_WIDTH * 2);
    float x = MIAN_VIEW_PIN_ITEM_BORDER_WIDTH;
    float y = MIAN_VIEW_PIN_ITEM_BORDER_WIDTH;

    NSLog(@"pin-item x-%f, y-%f, h-%f, w-%f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);

    NSLog(@"pin-item1 x-%f, y-%f, h-%f, w-%f", x, y, width, self.frame.size.height);

    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - MIAN_VIEW_PIN_ITEM_BORDER_WIDTH);

    float imageHeight = [NItemCell getImageHeight:_imageView.image withWidth:147];

    float priceHeight = 0;

    float titleWidth = width - (DEFAULT_SPACE_WITHLABEL * 2);
    float titleFontHeight = [[UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE] getHeight];
    float titleLineSpace = MINA_VIEW_PIN_ITEM_TITLE_LINE_HEIGHT - titleFontHeight;
    float titleHeight = [NItemCell caculateHeightWithFont:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE text:_title withWidth:titleWidth
                                          withLinespacing:titleLineSpace];


    if (_price) {
        priceHeight = [[UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_PRICE_FONT_SIZE] getHeight];
    }
    if (size.height > 0) {
        if (_price)
            imageHeight = size.height - priceHeight - titleHeight - DEFAULT_SPACE_WITHLABEL - DEFAULT_SPACE * 2 - DEFAULT_SPACE;
        else
            imageHeight = size.height - priceHeight - titleHeight - 2 * DEFAULT_SPACE;
    }


    _imageView.frame = CGRectMake(x, y, width, imageHeight);


    _titleLabel.numberOfLines = 0;

    NSMutableAttributedString *titleAttri =   [_title attributedStringWithChineseFontSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE withNumberAndLetterFontSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE withLineSpacing:titleLineSpace];
    _titleLabel.attributedText = titleAttri;
    _titleLabel.frame = CGRectMake(x + DEFAULT_SPACE_WITHLABEL, imageHeight + DEFAULT_SPACE_WITHLABEL, titleWidth, titleHeight);
    if(IOS7PLUS){
        _titleLabel.textAlignment = NSTextAlignmentJustified;
    }


    if (_price && ![_price isEqualToString:@""]) {
        priceHeight = [[UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_PRICE_FONT_SIZE] getHeight];
        float priceWidth = [_price widthWithFont:_priceLabel.font];



        _priceLabel.frame = CGRectMake(x + DEFAULT_SPACE_WITHLABEL - 1.5, imageHeight + DEFAULT_SPACE_WITHLABEL + titleHeight + DEFAULT_SPACE * 2, priceWidth * 2, priceHeight);
    }
    [self drawBorder];
    _inited = YES;

}


+ (CGFloat)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth {
    NSDictionary *data = object;

    UIImage *imageN = [[SDWebImageManager sharedManager] getByUrl:[data objectForKey:@"picUrl"] placeholder:[UIImage imageNamed:@"item_image_empty"]];

    NSString *titleN = [data objectForKey:@"name"];
    return [NItemCell getItemHeight:imageN withWidth:147 withTitle:titleN price:[data objectForKey:@"price"]];
}


- (void)initBorder {
    _contentView.layer.borderWidth = 0.5;
    _contentView.layer.cornerRadius = 3;

    _contentView.layer.borderColor = [MIAN_VIEW_PIN_ITEM_BORDER_COLOR CGColor];
    //_contentView.layer.masksToBounds = NO;
    _contentView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
   // _contentView.layer.shadowRadius = 11;
   // _contentView.layer.shadowColor = MIAN_VIEW_PIN_ITEM_BORDER_COLOR.CGColor;
   // _contentView.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.masksToBounds = NO;

    _line1 = [[UIView alloc] init];
    _line1.backgroundColor = MIAN_VIEW_PIN_ITEM_BORDER_COLOR;
    //_line1.layer.shadowColor = MIAN_VIEW_PIN_ITEM_BORDER_COLOR.CGColor;//shadowColor阴影颜色
   // _line1.layer.shadowOffset = CGSizeMake(0, 1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    //_line1.layer.shadowOpacity = 1;//阴影透明度，默认0
    //_line1.layer.shadowRadius = 1;//阴影半径，默认3
    [self addSubview:_line1];

}


#pragma mark - 在view底下画出阴影
- (void)drawBorder {
   // _line1.frame = CGRectMake(0 + 5, self.bounds.size.height - MIAN_VIEW_PIN_ITEM_BORDER_WIDTH, self.bounds.size.width - 10, MIAN_VIEW_PIN_ITEM_BORDER_WIDTH);
}
@end
