//
//  ItemDetailTitleView.m
//  demo
//
//  Created by huamulou on 14-9-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "ItemDetailTitleView.h"
#import "Constants.h"
#import "UIFont+FontHeight.h"
#import "NIAttributedLabel.h"
#import "ItemDetailCommon.h"
#import "NSString+Extend.h"


@interface ItemDetailTitleView ()
@property(nonatomic, retain) NIAttributedLabel *titleLable;
@property(nonatomic, assign) CGSize boundsRect;
@property(nonatomic, assign) CGFloat titleHeight;
@property(nonatomic, assign) CGFloat priceHeight;
@property(nonatomic, assign) BOOL heightCalculated;
@property(nonatomic, retain) UILabel *priceLable;
@property(nonatomic, retain) UILabel *otherPriceLable;


@property(nonatomic, assign) float titleLineSpace;


@property(nonatomic, retain) NSMutableAttributedString *priceAttrText;
@property(nonatomic, retain) NSString *priceText;
@property(nonatomic, retain) NSMutableAttributedString *otherPriceAttrText;
@end

@implementation ItemDetailTitleView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _heightCalculated = NO;
    }
    return self;
}

- (instancetype)initWithIsTmall:(BOOL)isTmall title:(NSString *)title price:(NSString *)price discountPrice:(NSString *)discountPrice {
    self = [super init];
    if (self) {
        self.isTmall = isTmall;
        self.title = title;
        self.price = price;
        self.discountPrice = discountPrice;
        int priceLength = [price length];
        
        if (discountPrice) {
            _priceText = [NSString stringWithFormat:@"%@%@%@", YUAN, discountPrice, @" "];
            
            _priceAttrText = [[NSMutableAttributedString alloc] initWithString:_priceText];
            [_priceAttrText addAttribute:NSForegroundColorAttributeName value:PRICE_COLOR range:NSMakeRange(0, [_priceText length])];
            [_priceAttrText addAttribute:NSFontAttributeName value:PRICE_FONT range:NSMakeRange(0, [_priceText length])];

            NSString *s1 = [NSString stringWithFormat:@"%@%@%@"
                            , @"原价："
                            , YUAN
                            , price];
            _otherPriceAttrText = [s1 attributedStringWithChineseFontSize:OTHER_PRICE_FONT_SIZE withNumberAndLetterFontSize:OTHER_PRICE_FONT_SIZE withLineSpacing:0];
            [_otherPriceAttrText addAttribute:NSForegroundColorAttributeName value:OTHER_PRICE_COLOR range:NSMakeRange(0, [s1 length])];
            [_otherPriceAttrText addAttribute:NSStrikethroughStyleAttributeName value:@1 range:NSMakeRange(0, [s1 length])];
            
        } else {
            _priceAttrText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", YUAN, price]];
            [_priceAttrText addAttribute:NSForegroundColorAttributeName value:PRICE_COLOR range:NSMakeRange(0, 1 + priceLength)];
            [_priceAttrText addAttribute:NSFontAttributeName value:PRICE_FONT range:NSMakeRange(0, 1 + priceLength)];
        }
    }
    
    return self;
}

- (CGSize)getSize {
    
    float titleLableWidth = SCREEN_WIDTH - 2 * DEFAULT_SPACE;


    float firstLineLableWidth = titleLableWidth - TMALL_IMAGE.size.width - LOGO_IMAGE_SPACE;
    
    float titleWidthByFont = [_title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) withTextFont:TITLE_FONT withLineSpacing:0].width;
    
  
    _titleLineSpace = 11;

    _titleHeight = LINEHEIGHT + LINEHEIGHT;
    if (titleWidthByFont <= firstLineLableWidth) {
        _titleHeight = LINEHEIGHT;
    }
    
    _priceHeight = [PRICE_FONT getHeight];
    _heightCalculated = YES;
    _boundsRect = CGSizeMake(SCREEN_WIDTH, DEFAULT_SPACE + _titleHeight + INNERSPACE + _priceHeight + DEFAULT_SPACE);
    return _boundsRect;
}


- (void)setUp {
    if (!_heightCalculated) {
        [self getSize];
    }
    self.backgroundColor = ITEMDETAILTITLEVIEW_BACKGROUND_COLOR;
    // self.backgroundColor = [UIColor blackColor];
    _titleLable = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(DEFAULT_SPACE, DEFAULT_SPACE, _boundsRect.width - 2 * DEFAULT_SPACE, _titleHeight)];
    
    _titleLable.autoresizingMask = UIViewAutoresizingFlexibleDimensions;
    _titleLable.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLable.numberOfLines = _boundsRect.height > LINEHEIGHT ? 2 : 1;
    _titleLable.textColor = TITLE_COLOR;
    
    NSMutableAttributedString *_tAttrText = [_title attributedStringWithChineseFontSize:TITLE_FONT_SIZE withNumberAndLetterFontSize:TITLE_FONT_SIZE withLineSpacing:_titleLineSpace];
    int length = [_title length];
    
    [_tAttrText addAttribute:NSForegroundColorAttributeName value:TITLE_COLOR range:NSMakeRange(0, length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [_tAttrText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, length)];
    _titleLable.attributedText = _tAttrText;
    
    UIImage *image = _isTmall ? TMALL_IMAGE : TAOBAO_IMAGE;
    [_titleLable insertImage:image
                     atIndex:0
                     margins:UIEdgeInsetsMake(ZERO, ZERO, ZERO, LOGO_IMAGE_SPACE)
       verticalTextAlignment:NIVerticalTextAlignmentMiddle
     ];

   _titleLable.lineHeight = LINEHEIGHT;
    
    float pWidth = [_priceText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) withTextFont:PRICE_FONT withLineSpacing:0].width;
    _priceLable = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_SPACE -4.5, DEFAULT_SPACE + _titleHeight + INNERSPACE, pWidth, _priceHeight)];
    _priceLable.attributedText = _priceAttrText;
    _priceLable.textAlignment = NSTextAlignmentCenter;
    [_priceLable sizeToFit];
    
    
    if (_otherPriceAttrText) {
        _otherPriceLable =[[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_SPACE -4.5 +pWidth, DEFAULT_SPACE + _titleHeight + INNERSPACE, SCREEN_WIDTH -2* DEFAULT_SPACE -pWidth, _priceHeight)];
        _otherPriceLable.attributedText = _otherPriceAttrText;
        
        //        [_otherPriceLable sizeToFit];
        [self addSubview:_otherPriceLable];
    }
    //   _priceLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLable];
    [self addSubview:_priceLable];
    
    
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (CGFloat)getHeight {
    return [self getSize].height;
}


@end
