//
// Created by huamulou on 14-9-5.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BannerItem : NSObject


@property (nonatomic, retain)  NSString      *imageURL;
@property (nonatomic, assign)  NSInteger     sequence;


- (instancetype)initWithImageURL:(NSString *)imageURL sequence:(NSInteger)sequence;



@end