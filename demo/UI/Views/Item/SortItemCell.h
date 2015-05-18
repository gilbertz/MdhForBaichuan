/**
* TODO 如果没有注释 那么你懂的
* User: huamulou
* Date: 14-9-12
* Time: 17:57
* //                       _oo0oo_
* //                      o8888888o
* //                      88" . "88
* //                      (| -_- |)
* //                      0\  =  /0
* //                    ___/`---'\___
* //                  .' \\|     |// '.
* //                 / \\|||  :  |||// \
* //                / _||||| -:- |||||- \
* //               |   | \\\  -  /// |   |
* //               | \_|  ''\---/''  |_/ |
* //               \  .-\__  '-'  ___/-. /
* //             ___'. .'  /--.--\  `. .'___
* //          ."" '<  `.___\_<|>_/___.' >' "".
* //         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
* //         \  \ `_.   \_ __\ /__ _/   .-` /  /
* //     =====`-.____`.___ \_____/___.-`___.-'=====
* //                       `=---='
* //     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* //
* //               佛祖保佑         永无BUG
*/

// Copyright (c) 2014 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SortItemCell : UIView
@property(nonatomic, retain) UIButton *button;
@property(nonatomic, retain) UIView *line;

- (id)initWithFrame:(CGRect)frame name:(NSString *)name;

@property(nonatomic, copy) void (^clickCallback)();

- (void)on;

- (void)off;
@end