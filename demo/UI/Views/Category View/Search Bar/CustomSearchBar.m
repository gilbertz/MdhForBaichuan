//
//  CustomSearchBar.m
//  demo
//
//  Created by huamulou on 14-9-10.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "CustomSearchBar.h"
#import "UIImage+Overlay.h"
#import "Constants.h"

@interface CustomSearchBar () {
    UITextField *_textField;
    UIButton *_btnAccessoryView;
}
@end

@implementation CustomSearchBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews {
    self.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor] withSize:self.frame.size];
    [self setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_bar_text"] forState:UIControlStateNormal];
    self.placeholder = @"搜索";

    [self setImage:[UIImage imageNamed:@"search_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];

    [self.cancleButton setTintColor:[UIColor blackColor]];

    if (IOS7PLUS) {
        for (UIView *subv in self.subviews) {
            for (UIView *view in subv.subviews) {
                if ([view isKindOfClass:[UITextField class]]) {
                    _textField = (UITextField *) view;
                    continue;
                }

            }
        }
    } else {
        for (UITextField *view in self.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                _textField = (UITextField *) view;
                continue;
            }

        }
    }
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
