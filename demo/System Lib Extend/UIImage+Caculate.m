//
//  UIImage+Caculate.m
//  demo
//
//  Created by huamulou on 14-9-12.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "UIImage+Caculate.h"

@implementation UIImage(Caculate)
- (float)getImageHeightWithWidth:(float)width {
    float rate = width / self.size.width;
    float height = self.size.height;
    if (rate < 1) {
        height = height * rate;
    }
    return height;

}

@end
