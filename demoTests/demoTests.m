//
//  demoTests.m
//  demoTests
//
//  Created by huamulou on 14-9-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SignUtil.h"
#import "URLUtil.h"
#import "UIFont+FontHeight.h"
#import "Constants.h"
#import "NSString+Extend.h"

@interface demoTests : XCTestCase

@end
typedef NS_ENUM(NSInteger, TaeFileSDKEnvironment) {
    TaeSDKEnvironmentDaily = 0,
    TaeSDKEnvironmentPreRelease,
    TaeSDKEnvironmentRelease,
    TaeSDKEnvironmentSandBox
};
@implementation demoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEnum{
    NSLog(@"%d", TaeSDKEnvironmentSandBox);
    XCTAssertTrue(1 == 1, @"just a test ");
}

- (void)testExample {

    UIFont *font = [UIFont systemFontOfSize:16];
    NSLog(@"font pontSize %f", [font getHeight]);
    NSLog(@"font pontSize %f", [[UIFont systemFontOfSize:14] getHeight]);
    NSLog(@"font pontSize %f", [[UIFont systemFontOfSize:12] getHeight]);


    NSString *asdas = @"我是中国人12哈哈abc而非1";
    NSMutableAttributedString *attributedString = [asdas attributedStringWithChineseFontSize:11 withNumberAndLetterFontSize:11 withLineSpacing:0];
    //添加我们的测试代码

    NSLog(@"%@", attributedString);

    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@111, @"1", @"2", @"2", @"3", @"3", nil];

    NSLog(@"$$$$$$$$$$$$$$$$$%@", [dictionary valueForKey:@"1"]);

    NSString *sign = [SignUtil genSign:dictionary];

    CGFloat hhhh = [[UIFont systemFontOfSize:16] getHeight];
    NSLog(@"font height----###################---%f", hhhh);
    NSLog(@"%@", sign);
//    XCTAssertTrue([[NSString stringWithString:@"BC88BF4D448842AB4A54F0BB6AFCEA0F"] isEqualToString:sign], @"just a test %@", sign);


//
    //   NSString *s = @"1";
    //   UILabel *label = [[UILabel alloc] init];

    NSInteger iii;
    if (iii) {
        NSLog(@"iii is not nil");
    }
    iii = 1212;
    if (iii) {
        NSLog(@"iii is not nil");
    }



//    label.
//    NSLog(@"12121212-%d", [s heightOfStringWithFont:[UIFont systemFontOfSize:22] withWidth:135 withLineBreakMode:label.lineBreakMode]);
//    NSLog(@"12121212-%d", [@"a" heightOfStringWithFont:[UIFont systemFontOfSize:22] withWidth:135 withLineBreakMode:label.lineBreakMode]);
//    NSLog(@"12121212-%d", [@"A" heightOfStringWithFont:[UIFont systemFontOfSize:22] withWidth:135 withLineBreakMode:label.lineBreakMode]);
//    NSLog(@"12121212-%d", [@"哦" heightOfStringWithFont:[UIFont systemFontOfSize:22] withWidth:135 withLineBreakMode:label.lineBreakMode]);
//
//
//    NSLog(@"font height %d", [[UIFont systemFontOfSize:20] getHeight]);
//    NSLog(@"font height %d", [[UIFont systemFontOfSize:21] getHeight]);
//    NSLog(@"font height %d", [[UIFont systemFontOfSize:22] getHeight]);
//    NSString *s1 = @"12wewqdsdasdasd我哈哈哈哈哈哈";
//    NSLog(@"22222-%d", [s1 heightOfStringWithFont:[UIFont systemFontOfSize:12] withWidth:135 withLineBreakMode:label.lineBreakMode]);
//

    float k = (float) 5 / 3;
    NSLog(@"sum%f", k);
    int sum = 11;
    for (int i = 1; i < k; i++) {


        sum += 10;
    }
    NSLog(@"sum%d", sum);

//
    NSLog(@"font-%f", [@"!" widthWithFont:[UIFont systemFontOfSize:20]]);
    NSLog(@"font-%f", [@"!1212" widthWithFont:[UIFont systemFontOfSize:20]]);
    NSLog(@"font-%f", [@"12" widthWithFont:[UIFont systemFontOfSize:20]]);
    NSLog(@"font-%f", [@"我是" widthWithFont:[UIFont systemFontOfSize:20]]);

    NSString *url = @"/openApi/index/getItems";
    NSNumber *page = @1;
    NSNumber *pageSize = @3;


    NSLog(@"URL%@", [URLUtil                    getURLWithParms:[NSDictionary dictionaryWithObjectsAndKeys:
            page, @"page", pageSize, @"pageSize", nil] withPath:url]);
//
    //  NSString *url1 = ITEM_LIST_API;
    // NSNumber *page1 = [NSNumber numberWithInteger:1];
    // NSNumber *pageSize1 = [NSNumber numberWithInteger:HTTP_API_DEFAULT_PAGESIZE];
    NSInteger _subCategoryId;
    NSInteger _sort;
    NSString *_keyword;
    NSNumber *subCategoryId = [NSNumber numberWithInteger:_subCategoryId];
    NSNumber *sort = [NSNumber numberWithInteger:_sort];
    NSString *urlString = [URLUtil                                                                                                                            getURLWithParms:
            [NSDictionary dictionaryWithObjectsAndKeys:page, @"page", pageSize, @"pageSize", _keyword, "keyword", sort, "sort", subCategoryId, "subCategoryId", nil] withPath:url];
    urlString = [[NSString alloc] initWithFormat:@"%@%@", HTTP_API_BASE_URL, urlString];

    NSLog(@"api%@", urlString);

}

- (void)testURL {

    //添加我们的测试代码

    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"1", @"2", @"2", nil];
//
    //   NSString *url = [SignUtil genSign:dictionary];

    NSLog(@"%@", [URLUtil getURLWithParms:dictionary withPath:@"/openApi/item/detail"]);
    XCTAssertTrue(1 == 1, @"just a test ");
}

@end
