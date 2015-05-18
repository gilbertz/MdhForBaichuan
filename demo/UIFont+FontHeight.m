//
//  UIFont+FontHeight.m
//  demo
//
//  Created by huamulou on 14-9-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "UIFont+FontHeight.h"
#import "NSString+Extend.h"

#define TESTSTRING @"测"

@implementation UIFont (FontHeight)


- (CGFloat)getHeight {
    float height = [TESTSTRING heightOfFont:self];
    return height;
}
@end
