//
// Created by huamulou on 14-9-7.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import "DateUtil.h"


@implementation DateUtil {

}
+ (NSString *)getDayInWeekInChinese:(NSInteger)dayInWeek {

    switch (dayInWeek) {

        case 1:
            return @"周日";
        case 2 :
            return @"周一";
        case 3 :
            return @"周二";
        case 4:
            return @"周三";
        case 5:
            return @"周四";
        case 6:
            return @"周五";
        case 7:
            return @"周六";
        default:
            return nil;
    }
}

+ (NSString *)getTimeSizeTwo:(NSInteger)time {

    if (time > 10) {
        return [[NSString alloc] initWithFormat:@"%d", time];
    }
    else {
        return [[NSString alloc] initWithFormat:@"%d%d", 0, time];
    }
    return nil;
}


@end