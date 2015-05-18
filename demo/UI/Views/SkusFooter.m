//
//  SkusFooter.m
//  demo
//
//  Created by huamulou on 14-9-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "SkusFooter.h"
#import "UIView+nib.h"

@implementation SkusFooter
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [UIView viewFromNibWithFileName:@"SKUView" owner:self index:1];
    }

    return self;
}
@end
