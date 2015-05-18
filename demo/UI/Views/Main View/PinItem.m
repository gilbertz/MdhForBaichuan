//
// Created by huamulou on 14-9-8.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import "PinItem.h"
#import "Constants.h"
#import "UIFont+FontHeight.h"
#import "SDWebImageManager.h"
#import "SDWebImageManager+GetByUrl.h"
//#import "UIImageView+AFNetworking.h"

#import "UIImageView+WebCache.h"
#import "NSString+Extend.h"

@interface PinItem () {

    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UIView *_contentView;
//    UILabel *
    UIView *_line1;
    BOOL _inited;
}
@end

@implementation PinItem {

}
- (id)initWithImageUrl:(NSString *)imageUrl title:(NSString *)title price:(NSString *)price {
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
//    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageUrl = imageUrl;
        self.price = price;
        self.title = title;
        self.backgroundColor = [UIColor clearColor];
        _inited = NO;

        _contentView = [[UIView alloc] init];
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_contentView];
        [self initBorder];
        [self setUpViews];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"item_image_empty"]];

        [_contentView addSubview:_imageView];
        _titleLabel = [[UILabel alloc] init];
        [_contentView addSubview:_titleLabel];
        _priceLabel = [[UILabel alloc] init];
        [_contentView addSubview:_priceLabel];
    }
    return self;
}

+ (float)caculateHeightWithFont:(UIFont *)font text:(NSString *)text withWidth:(float)width withLinespacing:(float)linespacing {

    return [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) withTextFont:font withLineSpacing:linespacing].height;


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


    float imageHeight = [PinItem getImageHeight:image withWidth:width];

    float titleFontHeight = [[UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE] getHeight];
    float linespacing = MINA_VIEW_PIN_ITEM_TITLE_LINE_HEIGHT - titleFontHeight;
    float titleHeight = [PinItem caculateHeightWithFont:[UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE] text:title withWidth:width - (MIAN_VIEW_PIN_ITEM_BORDER_WIDTH * 2) - (DEFAULT_SPACE * 2)
                                        withLinespacing:linespacing];
//    float priceHeight = [[UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_PRICE_FONT_SIZE] getHeight] + DEFAULT_SPACE;
    float priceHeight = [PinItem caculateHeightWithFont:[UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_PRICE_FONT_SIZE] text:@"￥200" withWidth:CGFLOAT_MAX withLinespacing:0] + DEFAULT_SPACE;


    NSLog(@"index-%d, imageHeight-%f, titleHeight-%f, priceHeight-%f", 0, imageHeight, titleHeight, priceHeight);
    return imageHeight + DEFAULT_SPACE + titleHeight + DEFAULT_SPACE * 2 + priceHeight;

}


- (void)setUpViews {



    _imageView.backgroundColor = MINA_VIEW_PIN_ITEM_BACKGROUND_COLOR;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;


//    _titleLabel.font = [UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE];
//    _titleLabel.text = _title;
    if (IOS7PLUS)
        _titleLabel.textAlignment = NSTextAlignmentJustified;
    _titleLabel.textColor = MINA_VIEW_PIN_ITEM_FONT_COLOR;



//    _titleLabel.backgroundColor = MINA_VIEW_PIN_ITEM_BACKGROUND_COLOR;



    _priceLabel.font = [UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_PRICE_FONT_SIZE];
    _priceLabel.text = _price;
    _priceLabel.textColor = MINA_VIEW_PIN_ITEM_FONT_COLOR;
//    _priceLabel.backgroundColor = MINA_VIEW_PIN_ITEM_BACKGROUND_COLOR;


    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processTap:)];
    [_contentView addGestureRecognizer:recognizer];


}

- (void)processTap:(id)obj {

    if (self.collectionView.collectionViewDelegate && [self.collectionView.collectionViewDelegate respondsToSelector:@selector(collectionView:didSelectCell:atIndex:)]) {
        NSInteger matchingIndex = self.index;
        [self.collectionView.collectionViewDelegate collectionView:self.collectionView didSelectCell:self atIndex:matchingIndex];
    }
}


- (void)layoutSubviews {
    if (!_inited) {
        float width = self.bounds.size.width - (MIAN_VIEW_PIN_ITEM_BORDER_WIDTH * 2);
//    int height = self.bounds.size.height - (MIAN_VIEW_PIN_ITEM_BORDER_WIDTH * 2);
        float x = MIAN_VIEW_PIN_ITEM_BORDER_WIDTH;
        float y = MIAN_VIEW_PIN_ITEM_BORDER_WIDTH;

        NSLog(@"pin-item x-%f, y-%f, h-%f, w-%f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);

        NSLog(@"pin-item1 x-%f, y-%f, h-%f, w-%f", x, y, width, self.frame.size.height);

        _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

        float imageHeight = [PinItem getImageHeight:_imageView.image withWidth:147];
        _imageView.frame = CGRectMake(x, y, width, imageHeight);


//    _imageView.backgroundColor = [UIColor blackColor];

        float titleWidth = width - (DEFAULT_SPACE * 2);
        float titleFontHeight = [[UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE] getHeight];
        float titleLineSpace = MINA_VIEW_PIN_ITEM_TITLE_LINE_HEIGHT - titleFontHeight;
        float titleHeight = [PinItem caculateHeightWithFont:[UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE] text:_title withWidth:titleWidth
                                            withLinespacing:titleLineSpace];

        float titleTextWidth = [_title widthWithFont:_titleLabel.font];

        float titleWidthTmp = titleWidth;
        int numOfLines = 1;
        while (titleTextWidth > titleWidthTmp) {
            titleWidthTmp += titleWidthTmp;
            numOfLines += 1;
        }
        if (!IOS7PLUS) {
            numOfLines += 1;
        }
        _titleLabel.numberOfLines = numOfLines;
        _titleLabel.attributedText = [_title attributedStringFromStingWithFont:[UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE]
                                                               withLineSpacing:titleLineSpace];
        _titleLabel.frame = CGRectMake(x + DEFAULT_SPACE, imageHeight + DEFAULT_SPACE, titleWidth, titleHeight);
        //[_titleLabel sizeToFit];
//    NSLog(@"_titlelabel %@",  _titleLabel.frame);



        float priceHeight = [[UIFont systemFontOfSize:MINA_VIEW_PIN_ITEM_PRICE_FONT_SIZE] getHeight];
        float priceWidth = [_price widthWithFont:_priceLabel.font];

        NSLog(@"numOfLines-%d, caculate at layoutSubviews width-%f, titleWidth-%f, titleHeight-%f, priceHeight - %f", numOfLines, width, titleWidth, titleHeight, priceHeight);
//    _priceLabel.frame = CGRectMake(x + DEFAULT_SPACE, imageHeight + DEFAULT_SPACE  + _titleLabel.frame.size.height + DEFAULT_SPACE * 2, priceWidth * 2, priceHeight);
        _priceLabel.frame = CGRectMake(x + DEFAULT_SPACE, imageHeight + DEFAULT_SPACE + titleHeight + DEFAULT_SPACE * 2, priceWidth * 2, priceHeight);
        [_priceLabel sizeToFit];
        [self drawBorder];
        _inited = YES;
    }

}


+ (CGFloat)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth {
    NSDictionary *data = object;

    UIImage *imageN = [[SDWebImageManager sharedManager] getByUrl:[data objectForKey:@"picUrl"] placeholder:[UIImage imageNamed:@"item_image_empty"]];

    NSString *titleN = [data objectForKey:@"name"];
    return [PinItem getItemHeight:imageN withWidth:147 withTitle:titleN];
}


- (void)initBorder {
    _contentView.layer.borderWidth = 0.5;
    _contentView.layer.cornerRadius = 2.5;

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

@end