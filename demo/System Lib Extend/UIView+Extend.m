//
//  UIView+Extend.m
//  demo
//
//  Created by huamulou on 14-9-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "UIView+Extend.h"
#import "MyAlertView.h"
#import "POPSpringAnimation.h"

@implementation UIView (Extend)
- (UIViewController *)viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *) nextResponder;
        }
    }
    return nil;
}


- (void)alertWithTitle:(NSString *)title message:(NSString *)msg onBtnClicked:(void (^)(int btnIndex))onBtnClicked {
    [[MyAlertView alertViewWithTitle:@"提示" message:msg
                        onBtnClicked:onBtnClicked
                   cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}


- (UIView *)mainView {
    return [self viewController].view;
}



#pragma mark - 使用facebook pop来做弹簧动画

- (void)animateView:(UIView *)view toFrame:(CGRect)frame completion:(void (^)(void))completion
{
	POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
	[animation setSpringBounciness:8];
	[animation setDynamicsMass:1];
    [animation setToValue:[NSValue valueWithCGRect:frame]];
	[view pop_addAnimation:animation forKey:nil];
    
    if (completion)
	{
		[animation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
			completion();
		}];
	}
}

@end
