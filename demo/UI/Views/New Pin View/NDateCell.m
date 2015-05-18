//
//  NDateCell.m
//  demo
//
//  Created by huamulou on 14-9-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "NDateCell.h"
#import "Constants.h"
#import "DateUtil.h"
#import "NSString+Extend.h"

@interface NDateCell ()
@end

@implementation NDateCell
@synthesize data = _data;

- (id)initWithFrame:(CGRect)frame {

    // 初始化时加载collectionCell.xib文件
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"NDateCellView" owner:self options:nil];

    // 如果路径不存在，return nil
    if (arrayOfViews.count < 1) {
        return nil;
    }
    // 如果xib中view不属于UICollectionViewCell类，return nil
    if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[NDateCell class]]) {
        return nil;
    }
    // 加载nib
    self = [arrayOfViews objectAtIndex:0];
    //   self.frame = frame;
    //    [super drawBorder];
//    }
    return self;
}


- (void)setData:(id)data {

    NSDate *lastUpdateTime = (NSDate *) data;
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
//    _time.font = [UIFont systemFontOfSize:MAIN_VIEW_PIN_DATE_TIME_NUMBER_FONT];
//    _time.backgroundColor = MIAN_VIEW_PIN_BACKGROUND_COLOR;
    _timeLabel.textColor = MAIN_VIEW_PIN_DATE_COLOR;
//    _time.textAlignment = NSTextAlignmentCenter;


    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:timeText];

    [str addAttribute:NSForegroundColorAttributeName value:MAIN_VIEW_PIN_DATE_COLOR range:NSMakeRange(0, 5)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:MAIN_VIEW_PIN_DATE_TIME_NUMBER_FONT] range:NSMakeRange(0, 5)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Light" size:MAIN_VIEW_PIN_DATE_UPDATE_FONT] range:NSMakeRange(5, 2)];

    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#2F2F2F"] range:NSMakeRange(0, 7)];
    _timeLabel.attributedText = str;


   NSString *dayText = [[NSString alloc] initWithFormat:@"%@/%@ %@", month, dayInt, weekDay];
//    _dayLabel.text = [[NSString alloc] initWithFormat:@"%@/%@ %@", month, dayInt, weekDay];
    _dayLabel.attributedText = [dayText attributedStringWithChineseFontSize:MAIN_VIEW_PIN_DATE_DAY_FONT withNumberAndLetterFontSize:MAIN_VIEW_PIN_DATE_DAY_FONT withLineSpacing:0];
//    _day.font = [UIFont systemFontOfSize:MAIN_VIEW_PIN_DATE_DAY_FONT];
//    _day.backgroundColor = MIAN_VIEW_PIN_BACKGROUND_COLOR;
    _dayLabel.textColor = MAIN_VIEW_PIN_DATE_COLOR;
//    _day.textAlignment = NSTextAlignmentCenter;
    //

    //    [super initBorder];
}


+ (CGFloat)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth {
    return 49.0;
}
@end
