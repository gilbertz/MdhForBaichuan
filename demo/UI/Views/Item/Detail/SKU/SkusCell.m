//
//  SkusCell.m
//  demo
//
//  Created by huamulou on 14-9-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "SkusCell.h"
#import "UIColor+Hex.h"
#import "Constants.h"
#import "UIView+nib.h"
#import "NSString+Extend.h"


@implementation SkusCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [UIView viewFromNibWithFileName:@"SKUView" owner:self index:3];
    }

    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
//    _btnTitle.frame = self.bounds;
    self.btnTitle.attributedText = [title attributedStringWithChineseFontSize:12 withNumberAndLetterFontSize:12];
    self.btnTitle.textColor = [UIColor blackColor];
    self.layer.cornerRadius = DEFAULT_CORNERRADIUS;
    [self off];
    [self.btnTitle setNeedsDisplay];
    self.layer.masksToBounds = YES;
}

- (void)setCellStaus:(SkusCellStaus)cellStaus {
    _cellStaus = cellStaus;


    switch (cellStaus) {
        case SKUCELLON: {
            [self on];
            break;
        }
        case SKUCELLOFF: {
            [self off];
            break;
        }
        case SKUCELLDISABLE: {
            [self disable];
            break;
        }
        default:
            break;

    }
}


- (void)on {

    self.layer.borderColor = VIEW_THEME_COLOR.CGColor;
    self.layer.borderWidth = VIEW_HEIGHTLIGHT_BORDERWIDTH;
    self.btnTitle.textColor = [UIColor blackColor];
}

- (void)disable {
    self.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    self.btnTitle.textColor = [UIColor colorWithHexString:@"#DDDDDD"];
   self.layer.borderWidth = VIEW_BORDERWIDTH;
}
- (void)off {
    self.btnTitle.textColor = [UIColor blackColor];

    self.layer.borderWidth = VIEW_BORDERWIDTH;
    self.layer.borderColor = [UIColor colorWithHexString:@"#c8c8c8"].CGColor;

}

@end
