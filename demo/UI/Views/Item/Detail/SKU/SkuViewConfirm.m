//
//  SkuViewConfirm.m
//  demo
//
//  Created by huamulou on 14-9-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "SkuViewConfirm.h"
#import "Constants.h"


#define  SKUVIEWCONFIRM_HEIGHT 44
@implementation SkuViewConfirm

- (id)initWithFrame:(CGRect)frame
{
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


- (void)setUp {
    _confirmBtn.layer.masksToBounds = YES;
    _confirmBtn.layer.cornerRadius = DEFAULT_CORNERRADIUS;
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}



- (void)confirmBtnClick:(id)sender {

    if (_confirmBtnCB) {
        _confirmBtnCB();
    }
}

+ (CGFloat)getHeight {
    return SKUVIEWCONFIRM_HEIGHT;
}


@end
