//
//  ItemDetailServiceView.m
//  demo
//
//  Created by huamulou on 14-9-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "ItemDetailServiceView.h"
#import "Constants.h"
#import "UIFont+FontHeight.h"
#import "NSString+Extend.h"


@interface ItemDetailServiceView () {

}

@property(nonatomic, retain) UIView *upperLine;
@property(nonatomic, retain) UILabel *postFeeLabel;
@property(nonatomic, retain) UILabel *monthlySaleLable;
@property(nonatomic, retain) UILabel *areaLable;
@end

@implementation ItemDetailServiceView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (instancetype)initWithPostFee:(NSString *)postFee monthlySale:(NSString *)monthlySale area:(NSString *)area {
    self = [super init];
    if (self) {
        self.postFee = postFee;
        self.monthlySale = monthlySale;
        self.area = area;
    }

    return self;
}

- (void)setUp {
    _upperLine = [[UIView alloc] initWithFrame:CGRectMake(DEFAULT_SPACE, 0, SCREEN_WIDTH - 2 * DEFAULT_SPACE, VIEW_BORDERWIDTH)];
    _upperLine.backgroundColor = SERVICE_BORDER_COLOR;
    [self addSubview:_upperLine];
    self.backgroundColor = ITEMDETAILTITLEVIEW_BACKGROUND_COLOR;


    float top = VIEW_BORDERWIDTH + DETAIL_SERVICE_DEFAULT_SPACE;
    CGSize postFeeSize = [_postFee getRectSizeOfStringWithFontSize:SERVICE_FONT_SIZE];
    float fontHeight = postFeeSize.height;
    float postFeeWidth = postFeeSize.width;
    _postFeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_SPACE,top, postFeeWidth, fontHeight)];
    _postFeeLabel.attributedText = [_postFee attributedStringWithChineseFontSize:SERVICE_FONT_SIZE withNumberAndLetterFontSize:SERVICE_FONT_SIZE];
    [self addSubview:_postFeeLabel];


    if (_monthlySale) {
        CGSize monthlySize = [_monthlySale getRectSizeOfStringWithFontSize:SERVICE_FONT_SIZE];
        _monthlySale = [NSString stringWithFormat:@"%@%@%@", @"月销", _monthlySale, @"笔"];
        float monthlySaleWidth = monthlySize.width;
        float left = (SCREEN_WIDTH - 2 * DEFAULT_SPACE - monthlySaleWidth) / 2;
        _monthlySaleLable = [[UILabel alloc] initWithFrame:CGRectMake(left, top, monthlySaleWidth, fontHeight)];
        _monthlySaleLable.attributedText = [_monthlySale attributedStringWithChineseFontSize:SERVICE_FONT_SIZE withNumberAndLetterFontSize:SERVICE_FONT_SIZE];
        [_monthlySaleLable sizeToFit];
        [self addSubview:_monthlySaleLable];
    }
    CGSize areaSize = [_area getRectSizeOfStringWithFontSize:SERVICE_FONT_SIZE];
    float areaWidth = areaSize.width;
    float left = (SCREEN_WIDTH - DEFAULT_SPACE - areaWidth);
    _areaLable = [[UILabel alloc] initWithFrame:CGRectMake(left, top, areaWidth, fontHeight)];
    _areaLable.attributedText = [_area attributedStringWithChineseFontSize:SERVICE_FONT_SIZE withNumberAndLetterFontSize:SERVICE_FONT_SIZE];
    [_areaLable sizeToFit];
    [self addSubview:_areaLable];

}

- (CGFloat)getHeight {
    return VIEW_BORDERWIDTH + DETAIL_SERVICE_DEFAULT_SPACE + DETAIL_SERVICE_DEFAULT_SPACE + [SERVICE_FONT getHeight];
}


@end
