//
//  PinDateCell.m
//  demo
//
//  Created by huamulou on 14-9-7.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "PinDateCell.h"
#import "DateUtil.h"
#import "UIFont+FontHeight.h"

@interface PinDateCell () {

    UILabel *time;
    UILabel *day;

}

@end

@implementation PinDateCell


- (id)initWithLastUpdate:(NSDate *)lastUpdate {
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    //self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = MIAN_VIEW_PIN_BACKGROUND_COLOR;

        [self setLastUpdate:lastUpdate];
        time = [[UILabel alloc] init];
        day = [[UILabel alloc] init];

        [self addSubview:time];
        [self addSubview:day];

    }
    return self;
}

- (void)setLastUpdate:(NSDate *)lastUpdateTime {


    NSDateComponents *components = [[NSCalendar currentCalendar]
            components:NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit
              fromDate:lastUpdateTime];

    NSString *dayInt = [DateUtil getTimeSizeTwo:[components day]];
    NSString *month = [DateUtil getTimeSizeTwo:[components month]];
    //  NSInteger year = [components year];
    NSString *weekDay = [DateUtil getDayInWeekInChinese:[components weekday]];
    NSString *hour = [DateUtil getTimeSizeTwo:[components hour]];
    NSString *minute = [DateUtil getTimeSizeTwo:[components minute]];
    NSString *timeText = [[NSString alloc] initWithFormat:@"%@:%@%@", hour, minute, MAIN_VIEW_PIN_DATE_UPADTE];
    time.font = [UIFont systemFontOfSize:MAIN_VIEW_PIN_DATE_TIME_NUMBER_FONT];
    time.backgroundColor = MIAN_VIEW_PIN_BACKGROUND_COLOR;
    time.textColor = MAIN_VIEW_PIN_DATE_COLOR;
    time.textAlignment = NSTextAlignmentCenter;


    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:timeText];

    [str addAttribute:NSForegroundColorAttributeName value:MAIN_VIEW_PIN_DATE_COLOR range:NSMakeRange(0, 5)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:MAIN_VIEW_PIN_DATE_TIME_NUMBER_FONT] range:NSMakeRange(0, 5)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:MAIN_VIEW_PIN_DATE_UPDATE_FONT] range:NSMakeRange(5, 2)];
    time.attributedText = str;


    day.text = [[NSString alloc] initWithFormat:@"%@/%@ %@", month, dayInt, weekDay];
    day.font = [UIFont systemFontOfSize:MAIN_VIEW_PIN_DATE_DAY_FONT];
    day.backgroundColor = MIAN_VIEW_PIN_BACKGROUND_COLOR;
    day.textColor = MAIN_VIEW_PIN_DATE_COLOR;
    day.textAlignment = NSTextAlignmentCenter;
    _lastUpdate = lastUpdateTime;
//

//    [super initBorder];
}

- (void)layoutSubviews {
    int width = self.bounds.size.width - (MIAN_VIEW_PIN_ITEM_BORDER_WIDTH * 2);

    time.frame = CGRectMake(4, MIAN_VIEW_PIN_ITEM_BORDER_WIDTH, width - 8, MAIN_VIEW_PIN_DATE_TIME_NUMBER_FONT);
    day.frame = CGRectMake(4, MIAN_VIEW_PIN_ITEM_BORDER_WIDTH + MAIN_VIEW_PIN_DATE_TIME_NUMBER_FONT + MAIN_VIEW_PIN_DATE_SPACE_CENTER, width - 8, MAIN_VIEW_PIN_DATE_DAY_FONT + MAIN_VIEW_PIN_DATE_SPACE_DOWN);
//    [super drawBorder];

}


+ (CGFloat)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth {
    float timeHeight = [[UIFont systemFontOfSize:MAIN_VIEW_PIN_DATE_TIME_NUMBER_FONT] getHeight];
    float dayHeight = [[UIFont systemFontOfSize:MAIN_VIEW_PIN_DATE_DAY_FONT] getHeight];
    return timeHeight + dayHeight + MAIN_VIEW_PIN_DATE_SPACE_CENTER + MAIN_VIEW_PIN_DATE_SPACE_DOWN;
}

@end
