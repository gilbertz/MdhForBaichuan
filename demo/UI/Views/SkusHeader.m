//
//  SkusHeader.m
//  demo
//
//  Created by huamulou on 14-9-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "SkusHeader.h"
#import "UIView+nib.h"
#import "NSString+Extend.h"

@implementation SkusHeader


- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLable.attributedText = [title attributedStringWithChineseFontSize:16 withNumberAndLetterFontSize:16];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [UIView viewFromNibWithFileName:@"SKUView" owner:self index:2];
    }

    return self;
}

@end
