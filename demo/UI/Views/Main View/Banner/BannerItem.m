//
// Created by huamulou on 14-9-5.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import "BannerItem.h"


@implementation BannerItem {

}




- (instancetype)initWithImageURL:(NSString *)imageURL sequence:(NSInteger)sequence {
    self = [super init];
    if (self) {
        self.imageURL = imageURL;
        self.sequence = sequence;
    }

    return self;
}



@end