//
//  UIView+nib.m
//  demo
//
//  Created by huamulou on 14-9-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "UIView+nib.h"

@implementation UIView (nib)


+ (id)viewFromNibWithFileName:(NSString *)file class:(Class)clasz index:(NSInteger)index {
    id owner = [[clasz alloc] init];

    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:file owner:owner options:nil];
    UIView *view = [nib objectAtIndex:index];

    if ([view isKindOfClass:clasz]) {
        return view;
    }

    return nil;
}

+ (id)viewFromNibWithFileName:(NSString *)file owner:(id)owner index:(NSInteger)index {

    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:file owner:owner options:nil];
    UIView *view = [nib objectAtIndex:index];

    return view;
}


@end
