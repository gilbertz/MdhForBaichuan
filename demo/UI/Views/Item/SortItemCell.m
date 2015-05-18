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

#import "SortItemCell.h"
#import "Constants.h"
#import "NSString+Extend.h"

@interface SortItemCell () {

}
@end

@implementation SortItemCell {


}
- (id)initWithFrame:(CGRect)frame name:(NSString *)name {
    self = [super initWithFrame:frame];
    if (self) {

        _button = [UIButton buttonWithType:UIButtonTypeCustom];

        [_button setTitle:name forState:UIControlStateNormal];
//        _button.titleLabel.attributedText = [name attributedStringWithChineseFontSize:ITEM_SORT_CELL_FONT_SIZE withNumberAndLetterFontSize:ITEM_SORT_CELL_FONT_SIZE ];
//        _button.titleLabel.text = name;
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setTintColor:[UIColor blackColor]];
        [_button.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:ITEM_SORT_CELL_FONT_SIZE]];
//        _button.state

        [_button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

        _button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [_button.titleLabel sizeToFit];
//        _button.backgroundColor = [UIColor blackColor];
        [self addSubview:_button];

        int leftmargin = (self.bounds.size.width - ITEM_SORT_CELL_HEIGHTLIGHT_WIDTH) / 2;
        _line = [[UIView alloc] initWithFrame:CGRectMake(leftmargin, self.frame.size.height - ITEM_SORT_CELL_LINE_HEIGHT, ITEM_SORT_CELL_HEIGHTLIGHT_WIDTH, ITEM_SORT_CELL_LINE_HEIGHT)];

        [self addSubview:_line];


    }

    return self;
}


- (void)onClick:(id)sender {
    NSLog(@"on sort cell click");
    if (self.clickCallback)
        self.clickCallback();
//    if(clickCallback)
}

- (void)on {
    _line.backgroundColor = VIEW_THEME_COLOR;

}

- (void)off {
    _line.backgroundColor = [UIColor clearColor];

}


@end