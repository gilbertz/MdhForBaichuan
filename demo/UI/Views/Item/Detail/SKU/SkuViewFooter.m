//
//  SkuViewFooter.m
//  demo
//
//  Created by huamulou on 14-9-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "SkuViewFooter.h"
#import "Constants.h"
#import "UIView+nib.h"


#define SKUFOOTER_HEIGHT 59

@implementation SkuViewFooter

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [UIView viewFromNibWithFileName:@"SKUView" owner:self index:4];
    }

    return self;
}

- (void)setUp {
//    _reduceBtn.layer.cornerRadius = DEFAULT_CORNERRADIUS;
    _reduceBtn.layer.borderWidth = VIEW_BORDERWIDTH;
    _reduceBtn.layer.borderColor = DEFAULT_BORDER_COLOR.CGColor;
    _reduceBtn.layer.masksToBounds = YES;
    [_reduceBtn addTarget:self action:@selector(reduceBtnClick:) forControlEvents:UIControlEventTouchUpInside];


    _addBtn.layer.borderColor = DEFAULT_BORDER_COLOR.CGColor;
//    _addBtn.layer.cornerRadius = DEFAULT_CORNERRADIUS;
    _addBtn.layer.borderWidth = VIEW_BORDERWIDTH;
    _addBtn.layer.masksToBounds = YES;
    [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];

//    _numLabel.layer.borderColor = DEFAULT_BORDER_COLOR.CGColor;
//    _numLabel.layer.borderWidth = VIEW_BORDERWIDTH;
    _numLabel.layer.masksToBounds = YES;


    _btnsView.layer.borderWidth= VIEW_BORDERWIDTH;
    _btnsView.layer.cornerRadius= DEFAULT_CORNERRADIUS;
    _btnsView.layer.borderColor= DEFAULT_BORDER_COLOR.CGColor;
    _btnsView.layer.masksToBounds= YES;

}

- (NSInteger)getNum {
    return _numLabel.text.integerValue;
}

- (void)reduceBtnClick:(id)sender {

    int num = [self getNum];
    int numTmp = num - 1;
    if (_reduceBtnCB && _reduceBtnCB(numTmp)) {
        if (numTmp < 0) {
            return;
        }
        if (numTmp == 0) {
            _reduceBtn.enabled = NO;
        }
        _numLabel.text = [NSString stringWithFormat:@"%d", numTmp];
    }
}

- (void)addBtnClick:(id)sender {
    int num = [self getNum];
    int numTmp = num + 1;
    if (_addBtnCB && _addBtnCB(numTmp)) {
        if (numTmp > 0) {
            _reduceBtn.enabled = YES;
        }

        _numLabel.text = [NSString stringWithFormat:@"%d", numTmp];
    }
}


+ (CGFloat)getHeight {
    return SKUFOOTER_HEIGHT;
}

@end
