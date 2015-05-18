//
//  UIViewController+Extend.m
//  demo
//
//  Created by huamulou on 14-9-26.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "UIViewController+Extend.h"
#import "Constants.h"

@implementation UIViewController (Extend)


- (void)addLeftBarButtonItem:(UIButton *)button target:(id)target action:(SEL)action {

    float widthFix = 6;
    if (!IOS7PLUS) {
        widthFix = 16;
    }

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    view.backgroundColor = [UIColor yellowColor];
    button.frame = CGRectMake(widthFix,( 44 - button.frame.size.height)/2, button.frame.size.width , button.frame.size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:button];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [view addGestureRecognizer:tapGesture];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];

//    if (!IOS7PLUS) {
//        // Add a spacer on when running lower than iOS 7.0
//        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                                                                        target:nil action:nil];
//        negativeSpacer.width = 16;
//        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
//    } else {
//        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                                                                        target:nil action:nil];
//        negativeSpacer.width = 6;
//        // Just set the UIBarButtonItem as you would normally
//        [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
//    }
}


//- (UINavigationController *)navigationController {
//    UIViewController *viewController = self.parentViewController ? self.parentViewController : self.presentingViewController;
//    while (!(viewController == nil || [viewController isKindOfClass:[UINavigationController class]])) {
//        viewController = viewController.parentViewController ? viewController.parentViewController : viewController.presentingViewController;
//    }
//
//    return (UINavigationController *)viewController;
//}

@end
