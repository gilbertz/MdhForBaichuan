//
//  SDWebImageManager+GetByUrl.m
//  demo
//
//  Created by huamulou on 14-9-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "SDWebImageManager+GetByUrl.h"

@implementation SDWebImageManager (GetByUrl)


- (UIImage *)getByUrl:(NSString *)url placeholder:(UIImage *)image {

    NSURL *urlNS = [NSURL URLWithString:url];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    SDImageCache *cache = manager.imageCache;
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:urlNS];

    UIImage *cachedImage = [cache imageFromMemoryCacheForKey:key];
    if (!cachedImage) {
        cachedImage = [cache imageFromDiskCacheForKey:key];
    }
    if (!cachedImage) {
        return image;
    }
    NSLog(@"find image from cache by url %@", url);
    return cachedImage;
}
@end
