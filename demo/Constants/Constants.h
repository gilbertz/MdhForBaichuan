//
//  Constants.h
//  demo
//
//  Created by huamulou on 14-9-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Hex.h"

#define ZERO 0


#define IOS_SYS_VERSION [UIDevice currentDevice].systemVersion.floatValue

#define IOS7PLUS (IOS_SYS_VERSION >= 7.0f)
#define IOS6PLUS (IOS_SYS_VERSION >= 6.0f)
#define IOS7TO7_1 (IOS_SYS_VERSION >= 7.0f && IOS_SYS_VERSION < 7.1f)
#pragma mark - 屏幕相关配置
#define SCREEN_BOUNDS  [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH  SCREEN_BOUNDS.width
#define STATUS_BAR_HEIGHT  20
#define SCREEN_HEIGHT  (IOS7PLUS ? SCREEN_BOUNDS.height  : (SCREEN_BOUNDS.height -STATUS_BAR_HEIGHT))
#define SCREEN_START_Y  (IOS7PLUS ? STATUS_BAR_HEIGHT : 0)

#define PLACE_HOLDER_IMAGE [UIImage imageNamed: @"item_image_empty"]
#define PLACE_HOLDER_CELL_IMAGE [UIImage imageNamed: @"item_image_empty"]


#pragma mark - 界面通用配置项
#define VIEW_BORDERWIDTH 0.5
#define VIEW_HEIGHTLIGHT_BORDERWIDTH 1
#define VIEW_THEME_COLOR  [UIColor colorWithRed:247/255.0f green:123/255.0f blue:159/255.0f alpha:1]
#define MY_VIEW_THEME_COLOR [UIColor colorWithRed:248/255.0f green:128/255.0f blue:163/255.0f alpha:1]
#define DEFAULT_SPACE  8
#define DETAIL_SERVICE_DEFAULT_SPACE  12
#define DEFAULT_SPACE_WITHLABEL 7
#define YUAN  @"￥"
#define DEFAULT_CORNERRADIUS 2.5
#define DEFAULT_BORDER_COLOR [UIColor colorWithHexString: @"#C8c8c8"]
#define VIEW_NAV_HEIGHT 44

#define VIEW_START_Y_WITH_NAV  0

#define DEFAULT_BACKGROUND_COLOR  [UIColor colorWithHexString: @"#eeeeee"]


#pragma mark - TAB相关配置

#define TAB_BAR_HEIGHT 44.0f
#define TAB_BAR_Y ((IOS7PLUS ? SCREEN_BOUNDS.height  : (SCREEN_BOUNDS.height -20)) - TAB_BAR_HEIGHT)


#pragma mark - main view 相关配置


#pragma mark - main view banner相关配置
#define MAIN_VIEW_BANNER_DOT_COLOR_S [UIColor colorWithHexString: @"#f386a5"]
#define MAIN_VIEW_BANNER_DOT_OTHER_BORDER_COLOR [UIColor colorWithHexString: @"#000"]
#define MAIN_VIEW_BANNER_DOT_OTHER_COLOR [UIColor colorWithHexString: @"#fff"]
#define MAIN_VIEW_BANNER_DOT_DIAMETER 7
#define MAIN_VIEW_BANNER_DOT_SPACER 7
#define MAIN_VIEW_BANNER_API_URL @"/openApi/index/getBanners"
#define MAIN_VIEW_BANNER_DOT_WIDTH (MAIN_VIEW_BANNER_DOT_DIAMETER+VIEW_BORDERWIDTH)

#define MAIN_VIEW_BANNER_IMAGE_VIEW_HEIGHT ((SCREEN_HEIGHT > 500) ? 200: 100)


#pragma mark - main view 瀑布流
#define MIAN_VEW_PIN_CELL_WIDTH  148
#define MIAN_VIEW_PIN_CELL_H_SPACE  8

#define MIAN_VIEW_PIN_BACKGROUND_COLOR  [UIColor colorWithHexString: @"#eeeeee"]

#define MIAN_VIEW_PIN_ITEM_BORDER_COLOR  [UIColor colorWithHexString: @"#e0e0de"]
#define MIAN_VIEW_PIN_ITEM_BORDER_WIDTH  0.5f

#define MAIN_VIEW_PIN_DATE_UPADTE @"更新"
#define MAIN_VIEW_PIN_DATE_TIME_NUMBER_FONT  21
#define MAIN_VIEW_PIN_DATE_UPDATE_FONT  20
#define MAIN_VIEW_PIN_DATE_COLOR  [UIColor colorWithHexString: @"#2f2f2f"]
#define MAIN_VIEW_PIN_DATE_DAY_FONT  12
#define MAIN_VIEW_PIN_DATE_SPACE_UP  8
#define MAIN_VIEW_PIN_DATE_SPACE_DOWN   4
#define MAIN_VIEW_PIN_DATE_SPACE_CENTER  5

#define MINA_VIEW_PIN_ITEM_TITLE_FONT_SIZE 12
#define MINA_VIEW_PIN_ITEM_SPACING 6

#define MINA_VIEW_PIN_ITEM_FONT_COLOR  [UIColor colorWithHexString: @"#5b5b5b"]
#define MINA_VIEW_PIN_ITEM_TITLE_LINE_HEIGHT  18
#define MINA_VIEW_PIN_ITEM_BACKGROUND_COLOR  [UIColor whiteColor]
#define MINA_VIEW_PIN_ITEM_PRICE_FONT_SIZE 11


#pragma mark - 分类页面配置
#define CATEGORY_SEARCHBAR_HEIGHT  50

#define CATEGORY_FATHER_CELL_BORDER_COLOR   [UIColor colorWithHexString: @"#c7c7c7"]
#define CATEGORY_FATHER_CELL_WIDTH  78
#define CATEGORY_FATHER_CELL_HEIGHT  46
#define CATEGORY_FATHER_CELL_SELECTED_WIDTH  3

#define CATEGORY_SUB_CELL_WIDTH  70
#define CATEGORY_SUB_CELL_HEIGHT  93
#define CATEGORY_SUB_CELL_IMAGE_HEIGHT 70
#define CATEGORY_SUB_CELL_LABEL_HEIGHT 23

#define CATEGORU_SUB_API_PATH @"/openApi/category/getChildCategories"

#define CATEGORY_SUB_VIEW_UP_MARGIN 7
#define CATEGORY_SUB_VIEW_LEFT_MARGIN 7.5

#define CATEGORY_SUB_VIEW_WIDTH 226
#define CATEGORY_SUB_VIEW_LABEL_HEIGHT 32
#define CATEGORY_SUB_VIEW_LABEL_FONT_SIZE 12


#define ITEM_LIST_API @"/openApi/category/getItems"
#define ITEM_SORT_HEIGHT 32
#define ITEM_SORT_LEFT_RIGHT_MARGIN 24
#define ITEM_SORT_CELL_WIDTH 55.5
#define ITEM_SORT_CELL_HEIGHTLIGHT_WIDTH 37.5
#define ITEM_SORT_CELL_LINE_HEIGHT 1.5
#define ITEM_SORT_CELL_FONT_SIZE 12

#pragma mark - http接口相关配置
#define HTTP_API_BASE_URL @"http://taeandroid.cs.jaeapp.com"
#define HTTP_API_APPKEY @"1234"
#define HTTP_API_APPSECRET @"5678"
#define HTTP_API_PARMS_APPKEY @"serverKey"
#define HTTP_API_PARMS_APPSECRET @"serverSecret"
#define HTTP_API_PARMS_SIGN @"sign"
#define HTTP_API_DEFAULT_PAGESIZE 10

@interface Constants : NSObject

@end


typedef enum {

    TabViewLoadInit = 0,
    TabViewLoadStart,
    TabViewLoadSucc,
    TabViewLoadFailed

} TabViewLoadState;
