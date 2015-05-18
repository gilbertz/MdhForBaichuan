//
//  SDWebImageManager+GetByUrl.h
//  demo
//
//  Created by huamulou on 14-9-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"

@interface SDWebImageManager(GetByUrl)

-(UIImage *)getByUrl:(NSString *)url placeholder:(UIImage *)image;

@end
