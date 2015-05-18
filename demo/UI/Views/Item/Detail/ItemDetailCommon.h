//
//  ItemDetailCommon.h
//  demo
//
//  Created by huamulou on 14-9-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>


#define INNERSPACE 16
#define LINEHEIGHT 20
#define TITLE_FONT_SIZE  16
#define TITLE_FONT  [UIFont fontWithName:@"STHeitiSC-Light" size:16]
#define TITLE_COLOR  [UIColor blackColor]
#define PRICE_FONT  [UIFont fontWithName:@"HelveticaNeue" size:16]
#define PRICE_COLOR   [UIColor colorWithHexString:@"#e50909"]
#define OTHER_PRICE_COLOR  [UIColor colorWithHexString:@"#999898"]
#define  OTHER_PRICE_FONT_SIZE 11
#define TMALL_IMAGE   [UIImage imageNamed:@"tmall_logo_tag"]
#define LOGO_IMAGE_SPACE   5
#define TAOBAO_IMAGE  [UIImage imageNamed:@"taobao_logo_tag"]

#define  ITEMDETAILTITLEVIEW_BACKGROUND_COLOR  [UIColor whiteColor]


#define BACK_BTN_TOP_MARGIN (IOS7PLUS? 32 : 12)
#define BACK_BTN_LEFT_MARGIN 16
#define BACK_BTN_BACKGROUND_IMAGE [UIImage imageNamed:@"item_detail_back_btn"]
#define BACK_BTN_R 37
#define BACK_BTN_R 37


#define BUY_AREA_HEIGHT 44


#define SERVICE_FONT_SIZE  12
#define SERVICE_FONT  [UIFont fontWithName:@"STHeitiSC-Light" size:SERVICE_FONT_SIZE]
#define SERVICE_BORDER_COLOR  [UIColor colorWithHexString:@"d9d9d9"]


#define DETAIL_BACKGROUND_COLOR [UIColor colorWithHexString: @"#eeeeee"]
#define BUY_AREA_BUYNOW_BUTTON_WIDTH 82
#define BUY_AREA_BUYNOW_BUTTON_HEIGHT 33
#define BUY_AREA_BUYNOW_BUTTON_AREA_HEIGHT 44
#define BUY_AREA_BUYNOW_BSCKGROUND_COLOR [UIColor colorWithHexString:@"#FF4F00"]
#define BUY_AREA_BUYNOW_FONT [UIFont fontWithName:@"STHeitiSC-Light" size:16]
#define BUY_AREA_BUYNOW_BORDER_COLOR  [UIColor blackColor]


#define FUNCTION_BAR_SPACING 43
#define FUNCTION_BAR_HEIGHT 44
#define DETAIL_AREA_TEXT_FONT_SIZE 12
#define DETAIL_AREA_TEXT_FONT_COLR [UIColor blackColor]
#define DETAIL_AREA_TEXT_LINESPACING 6

@protocol ItemDetailCell

@required
- (CGFloat)getHeight;

- (void)setUp;
@end

@interface ItemDetailCommon : UIView

@end
