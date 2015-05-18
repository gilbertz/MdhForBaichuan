//
//  UIView+nib.h
//  demo
//
//  Created by huamulou on 14-9-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (nib)
+ (id)viewFromNibWithFileName:(NSString *)file class:(Class)clasz index:(NSInteger)index;
+ (id)viewFromNibWithFileName:(NSString *)file owner:(id)owner index:(NSInteger)index;

@end
