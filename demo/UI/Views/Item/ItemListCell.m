//
//  ItemListCell.m
//  demo
//
//  Created by huamulou on 14-9-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "ItemListCell.h"
#import "Constants.h"
#import "UIFont+FontHeight.h"
#import "SDWebImageManager+GetByUrl.h"
#import "NSString+Extend.h"

@interface ItemListCell () {

    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UIView *_contentView;
//    UILabel *
    UIView *_line1;
}
@end

@implementation ItemListCell

@synthesize data = _data;
@synthesize collectionView = _collectionView;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _contentView = [[UIView alloc] init];
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_contentView];
        [self initBorder];
        [self setUpViews:frame.size];


        [_contentView addSubview:_imageView];
        _titleLabel = [[UILabel alloc] init];
        [_contentView addSubview:_titleLabel];
        _priceLabel = [[UILabel alloc] init];
        [_contentView addSubview:_priceLabel];
    }
    return self;
}

- (void)setCollectionView:(UICollectionView *)collectionView {
    self.collectionView = collectionView;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - completeCB -在图片加载结束之后可以有一个回调

- (void)setData:(id)data size:(CGSize)size imageLoadComplete:(void (^)(UIImage *image))completeCB {
    if (data) {
        self.imageUrl = [data objectForKey:@"pic"];
        self.price = [data valueForKey:@"price"];
        self.price = [NSString stringWithFormat:@"%@%@", YUAN, _price];
        self.tbItemId = [[data objectForKey:@"tbItemId"] intValue];
        self.discountPrice = [data valueForKey:@"discountPrice"];
        if (self.discountPrice) {
            self.discountPrice = [NSString stringWithFormat:@"%@%@", YUAN, _discountPrice];
        }
        self.title = [data objectForKey:@"title"];


        [_imageView sd_setImageWithURL:
                        [NSURL URLWithString:_imageUrl]
                      placeholderImage:
                              [UIImage imageNamed:@"item_image_empty"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 [self.collectionView reloadData];
                                 completeCB(image);
                             }
        ];

        self.backgroundColor = [UIColor clearColor];

        _imageView.backgroundColor = MINA_VIEW_PIN_ITEM_BACKGROUND_COLOR;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;

        if (IOS7PLUS)
            _titleLabel.textAlignment = NSTextAlignmentJustified;
        _titleLabel.textColor = MINA_VIEW_PIN_ITEM_FONT_COLOR;


        NSMutableAttributedString *priceAttr =[_price attributedStringWithChineseFontSize:MINA_VIEW_PIN_ITEM_PRICE_FONT_SIZE withNumberAndLetterFontSize:MINA_VIEW_PIN_ITEM_PRICE_FONT_SIZE withLineSpacing:0];

        [priceAttr addAttribute:NSKernAttributeName value:@-2.0f range:NSMakeRange(0, 1)];
        _priceLabel.attributedText = priceAttr;
        _priceLabel.textColor = MINA_VIEW_PIN_ITEM_FONT_COLOR;

        [self setUpViews:size];
    }
}


+ (float)caculateHeightWithFontSize:(NSInteger)fontSize text:(NSString *)text withWidth:(float)width withLinespacing:(float)linespacing {
    if (text) {
        return [text getRectSizeOfStringWithFontSize:fontSize withLineSpacing:linespacing withBoundingRect:CGSizeMake(width, CGFLOAT_MAX)].height;
    }
    return 0.0;

}


+ (float)getImageHeight:(UIImage *)image withWidth:(float)width {
    float rate = width / image.size.width;
    float height = image.size.height;
    if (rate < 1) {
        height = height * rate;
    }
    return height;

}


+ (float)getItemHeight:(UIImage *)image withWidth:(float)width withTitle:(NSString *)title {


    float imageHeight = [ItemListCell getImageHeight:image withWidth:width];

    float titleFontHeight = [[UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE] getHeight];
    float linespacing = MINA_VIEW_PIN_ITEM_TITLE_LINE_HEIGHT - titleFontHeight;
    float titleHeight = [ItemListCell caculateHeightWithFontSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE text:title withWidth:width - (DEFAULT_SPACE_WITHLABEL * 2)
                                                 withLinespacing:linespacing];
    float priceHeight = [ItemListCell caculateHeightWithFontSize:MINA_VIEW_PIN_ITEM_PRICE_FONT_SIZE text:@"￥200" withWidth:CGFLOAT_MAX withLinespacing:0] + DEFAULT_SPACE;


    NSLog(@"index-%d, imageHeight-%f, titleHeight-%f, priceHeight-%f", 0, imageHeight, titleHeight, priceHeight);
    return imageHeight + DEFAULT_SPACE_WITHLABEL + titleHeight + DEFAULT_SPACE * 2 + priceHeight + MIAN_VIEW_PIN_ITEM_BORDER_WIDTH;

}


- (void)setUpViews:(CGSize)size {
    float width = self.bounds.size.width - (MIAN_VIEW_PIN_ITEM_BORDER_WIDTH * 2);
//    int height = self.bounds.size.height - (MIAN_VIEW_PIN_ITEM_BORDER_WIDTH * 2);
    float x = MIAN_VIEW_PIN_ITEM_BORDER_WIDTH;
    float y = MIAN_VIEW_PIN_ITEM_BORDER_WIDTH;


    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - MIAN_VIEW_PIN_ITEM_BORDER_WIDTH);

    float imageHeight = [ItemListCell getImageHeight:_imageView.image withWidth:(size.width)];

    float titleWidth = width - (DEFAULT_SPACE_WITHLABEL * 2);
    float titleFontHeight = [_title getRectSizeOfStringWithFontSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE withLineSpacing:0].height;


    float titleLineSpace = MINA_VIEW_PIN_ITEM_TITLE_LINE_HEIGHT - titleFontHeight;
    float titleHeight = [ItemListCell caculateHeightWithFontSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE text:_title withWidth:titleWidth
                                                 withLinespacing:titleLineSpace];
    float priceHeight = [[UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_PRICE_FONT_SIZE] getHeight];

    if (size.height > 0) {
        imageHeight = size.height - priceHeight - titleHeight - DEFAULT_SPACE_WITHLABEL - DEFAULT_SPACE * 2 - DEFAULT_SPACE;
    }


    _imageView.frame = CGRectMake(x, y, width, imageHeight);



    _titleLabel.numberOfLines = 0;
    if (_title) {
        _titleLabel.attributedText = [_title attributedStringWithChineseFontSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE
                                                     withNumberAndLetterFontSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE
                                                                 withLineSpacing:titleLineSpace];
    }
    _titleLabel.frame = CGRectMake(x + DEFAULT_SPACE_WITHLABEL, imageHeight + DEFAULT_SPACE_WITHLABEL, titleWidth, titleHeight);


    float priceWidth = _price ? [_price widthWithFont:_priceLabel.font] : 0.0;

    _priceLabel.frame = CGRectMake(x + DEFAULT_SPACE - 2.5, imageHeight + DEFAULT_SPACE + titleHeight + DEFAULT_SPACE * 2, priceWidth * 2, priceHeight);
    [self drawBorder];


}


+ (CGFloat)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth {
    NSDictionary *data = object;

    UIImage *imageN = [[SDWebImageManager sharedManager] getByUrl:[data objectForKey:@"pic"] placeholder:[UIImage imageNamed:@"item_image_empty"]];

    NSString *titleN = [data objectForKey:@"title"];
    return [ItemListCell getItemHeight:imageN withWidth:147 withTitle:titleN];
}

+ (CGFloat)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth image:(UIImage *)image {
    NSDictionary *data = object;

//    UIImage *imageN = [[SDWebImageManager sharedManager] getByUrl:[data objectForKey:@"pic"] placeholder:[UIImage imageNamed:@"item_image_empty"]];

    NSString *titleN = [data objectForKey:@"title"];
    return [ItemListCell getItemHeight:image withWidth:columnWidth withTitle:titleN];
}


- (void)initBorder {
    _contentView.layer.borderWidth = 0.5;
    _contentView.layer.cornerRadius = 3;

    _contentView.layer.borderColor = [MIAN_VIEW_PIN_ITEM_BORDER_COLOR CGColor];
    _contentView.layer.masksToBounds = YES;
    _contentView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    self.layer.masksToBounds = NO;

    _line1 = [[UIView alloc] init];
    _line1.backgroundColor = MIAN_VIEW_PIN_ITEM_BORDER_COLOR;
    _line1.layer.shadowColor = MIAN_VIEW_PIN_ITEM_BORDER_COLOR.CGColor;//shadowColor阴影颜色
    _line1.layer.shadowOffset = CGSizeMake(0, 0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _line1.layer.shadowOpacity = 0.9;//阴影透明度，默认0
    _line1.layer.shadowRadius = 0.5;//阴影半径，默认3
    [self addSubview:_line1];

}


- (void)drawBorder {

    _line1.frame = CGRectMake(0 + 4, self.bounds.size.height - MIAN_VIEW_PIN_ITEM_BORDER_WIDTH, self.bounds.size.width - 8, MIAN_VIEW_PIN_ITEM_BORDER_WIDTH);
//    [self addSubview:_line1];

}


- (void)setData:(id)data {
    self.data = data;
}

@end
