//
//  CCTabBarViewController.m
//  TabBarControllerModel
//
//  Created by wangtian on 14-6-25.
//  Copyright (c) 2014年 wangtian. All rights reserved.
//

#import "CCTabBarViewController.h"
#import "UIImage+Overlay.h"
#import "MyViewController.h"
#import "CustomTabView.h"

@interface CCTabBarViewController () <CCTabBarDelegate, CCTabBarChinldVIewControllerDelegate> {
    NSInteger _defauletSelectedIndex;
    NSString *_tabBarBgImageName;
    NSMutableArray *_subControllers;
    NSString *_color;
}
@end

@implementation CCTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _subControllers = [[NSMutableArray alloc] init];
        _currentIndex = -1;
//        self.delegate = self;
    }
    return self;
}

- (id)initWithItemModels:(NSArray *)itemModelArray {
    if (self = [super init]) {

        self.itemsArray = itemModelArray;
        _defauletSelectedIndex = 0;
    }
    return self;
}

- (id)initWithItemModels:(NSArray *)itemModelArray defaultSelectedIndex:(NSInteger)defaultSelectedIndex {
    self = [self initWithItemModels:itemModelArray];
    if (self) {

        _defauletSelectedIndex = defaultSelectedIndex;
    }
    return self;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_contentView];

    }
    return _contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpViewsWithDefauletSelectedIndex:_defauletSelectedIndex];
    // Do any additional setup after loading the view.
}


- (void)setUpConstraines {
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDictionary = @{@"contentView" : self.contentView, @"tabBar" : self.tabBar};
    NSArray *constraint_POS_HForCV = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary];
    NSArray *constraint_POS_HForCV_V;
    NSLog(@"@@@@@@@@@@@@@@@@@@@@@@@@%f", [UIDevice currentDevice].systemVersion.floatValue);
//    if (IOS7TO7_1) {
//        constraint_POS_HForCV_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[contentView]-0-[tabBar]-0-|"
//                                                                          options:0
//                                                                          metrics:nil
//                                                                            views:viewsDictionary];
//    } else {
    constraint_POS_HForCV_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView]-0-[tabBar]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary];
//    }

    NSArray *constraint_POS_HForCV0 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tabBar]-0-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:viewsDictionary];
    [self.view addConstraints:constraint_POS_HForCV_V];
    [self.view addConstraints:constraint_POS_HForCV0];
    [self.view addConstraints:constraint_POS_HForCV];
}

#pragma mark -初始化toolbar

- (void)setUpViewsWithDefauletSelectedIndex:(NSInteger)defauletSelectedIndex {
    if (self.itemsArray.count == 0) {
        return;
    }
    self.tabBar = [CCTabBar getCCTabBarWithItemModels:self.itemsArray defaultSelectedIndex:defauletSelectedIndex];


    if (_tabBarBgImageName) {

        [self.tabBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:_tabBarBgImageName]]];
        // [self.tabBar setBackgroundColor:[UIColorHex redColor]];
    } else if (_color) {
        [self.tabBar setBackgroundColor:[UIColor colorWithHexString:_color]];
    }


    self.tabBar.delegate = self;
    [self.view addSubview:self.tabBar];
    [self setUpConstraines];
    for (int i = 0; i < self.itemsArray.count; i++) {

        CCTabBarItemModel *itemModel = [self.itemsArray objectAtIndex:i];
        id childViewController = [[NSClassFromString(itemModel.controllerName) alloc] init];
        //[childViewController setDelegate:self];
        if (i == 0 || i == 1 || i == 2) {

            UINavigationController *mainNavController = [[UINavigationController alloc] initWithRootViewController:childViewController];

            if ([childViewController isKindOfClass:[MyViewController class]]) {
                MyViewController *myview = (MyViewController *) childViewController;
                [myview setMyNavController:mainNavController];
            }
            if (IOS7PLUS) {
                [[mainNavController navigationBar] setBarTintColor:VIEW_THEME_COLOR];
                //     navigationBar
            } else {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
                [[mainNavController navigationBar] setBackgroundImage:[UIImage imageNamed:@"main_nav_title_ios6"] forBarMetrics:UIBarMetricsDefault];
            }
            [self addChildViewController:mainNavController];
            [_subControllers addObject:mainNavController];
        } else {
            [self addChildViewController:childViewController];
            [_subControllers addObject:childViewController];
        }

        if (i == defauletSelectedIndex) {
//            [self.contentView addSubview:[[_subControllers objectAtIndex:i] view]];
//            [[[_subControllers objectAtIndex:i] view] setFrame:self.contentView.bounds];
//            _currentViewController = [_subControllers objectAtIndex:i];
            [self selectedItem:itemModel];
        }


    }
    _currentIndex = defauletSelectedIndex;


    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width, 0.5)];
    [sep setBackgroundColor:[UIColor colorWithHexString:@"#000"]];
    //设置为半透明
    sep.alpha = 0.25;
    sep.layer.shadowColor = [UIColor blackColor].CGColor;
    sep.layer.shadowOpacity = 0.5;
    sep.layer.shadowRadius = 0.5;
    sep.layer.shadowOffset = CGSizeMake(0, 0);
    [self.tabBar addSubview:sep];

}

#pragma mark -设置tabBar背景图片

- (void)setTabBarBgImage:(NSString *)imageName {
    _tabBarBgImageName = imageName;
}


#pragma mark - 点击item触发代理方法

- (void)selectedItem:(CCTabBarItemModel *)selectedItemModel {
    if (_currentIndex == selectedItemModel.itemIndex) {
        return;
    }
    int cIndex = selectedItemModel.itemIndex;
    UIViewController *childViewController = [_subControllers objectAtIndex:selectedItemModel.itemIndex];
    /**
    * 使用动画开始
    */
//    if (_currentIndex > selectedItemModel.itemIndex) {
//
//        childViewController.view.frame = CGRectMake(0 - SCREEN_WIDTH, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
//    } else {
//        childViewController.view.frame = CGRectMake(SCREEN_WIDTH + SCREEN_WIDTH, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
//    }
//    // childViewController.view.alpha = 1.0;
//
//    //UIViewController *cViewC = [_subControlers objectAtIndex:_currentIndex];
//    [UIView beginAnimations:@"fadeIn" context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    [UIView setAnimationDuration:0.2];
//
//    if (_currentIndex > selectedItemModel.itemIndex) {
//
//        childViewController.view.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
//    } else {
//        childViewController.view.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
//    }
//
//
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(animationFinished:)];
//    [UIView commitAnimations];
//
//    [self.contentView addSubview:childViewController.view];


    /**
    * 使用动画结束
    */
    /**
    * 不使用动画
    */
    UINavigationController *navigationController1 = (UINavigationController *) childViewController;
    if (IOS7PLUS) {

        UINavigationBar *navigationBar = navigationController1.navigationBar;
//                mainNavController.toolbarHidden = NO  ;
        [navigationBar setBackgroundImage:[UIImage imageWithColor:VIEW_THEME_COLOR withSize:CGSizeMake(SCREEN_WIDTH, 64)]
                           forBarPosition:UIBarPositionAny
                               barMetrics:UIBarMetricsDefault];
        navigationBar.shadowImage = [UIImage new];
        navigationBar.backgroundColor = VIEW_THEME_COLOR;

    } else {
        navigationController1.navigationBar.clipsToBounds = YES;
    }
    if (_currentViewController)
        [_currentViewController.view removeFromSuperview];
    [self.contentView addSubview:childViewController.view];
    if (IOS7TO7_1) {
        childViewController.view.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    } else {
        childViewController.view.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    }


    /**
    * 不使用动画end
    */
    if (IOS7PLUS && (cIndex == 0 || cIndex == 1 || cIndex == 2))
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    else if (IOS7PLUS) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    }
    _currentViewController = childViewController;
    _currentIndex = selectedItemModel.itemIndex;
    [self.view bringSubviewToFront:_tabBar];

    if ([navigationController1.topViewController conformsToProtocol:@protocol(CustomTabView)]) {
        UIViewController <CustomTabView> *cTabView = (UIViewController <CustomTabView> *) navigationController1.topViewController;
        if ([cTabView respondsToSelector:@selector(didTabSelected)])
            [cTabView didTabSelected];
    }


}

- (void)animationFinished:(id)sender {
}

#pragma mark -设置item  badge红圈

- (void)setBadgeNumber:(NSInteger)number index:(NSInteger)index {
    [self.tabBar setItemBadgeNumberWithIndex:index badgeNumber:number];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
