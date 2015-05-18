//
//  FunctionBarButton.m
//  demo
//
//  Created by huamulou on 14-9-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "FunctionBarButton.h"
#import "Constants.h"

#define HIGHLIGHT_BORDER_HEIGHT 1.5
#define BTN_FONT [UIFont fontWithName:@"STHeitiSC-Light"  size:14]

@implementation FunctionBarButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code


    }
    return self;
}

- (void)setBtnTitle:(NSString *)btnTitle {
    _btnTitle = btnTitle;
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;

    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitle:_btnTitle forState:UIControlStateNormal];
    _button.titleLabel.font = BTN_FONT;
    [self addSubview:_button];

    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button setTintColor:[UIColor blackColor]];
//        _button.state

    [_button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchDown];

    _button.frame = CGRectMake(0, 0, width, height);
//        _button.backgroundColor = [UIColor blackColor];

    _highlightLine = [[UIView alloc] initWithFrame:CGRectMake(0, height - HIGHLIGHT_BORDER_HEIGHT, width, HIGHLIGHT_BORDER_HEIGHT)];
    [self addSubview:_highlightLine];
}


- (void)onClick:(id)sender {
    NSLog(@"on sort cell click");
    if (self.clickCallback)
        self.clickCallback();
    [self on];
}

- (void)on {
    _highlightLine.backgroundColor = VIEW_THEME_COLOR;
}

- (void)off {
    _highlightLine.backgroundColor = [UIColor clearColor];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
