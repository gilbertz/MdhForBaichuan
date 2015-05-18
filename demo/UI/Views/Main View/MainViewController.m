//
//  MainViewController.m
//  demo
//
//  Created by huamulou on 14-9-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <TAESDK/TaeSDK.h>
#import "MainViewController.h"

#import "PinDateCell.h"
#import "PinView.h"
#import "UIViewController+TitleLabel.h"
#import "NView.h"
#import "ItemDetailViewController.h"
#import "ItemListViewController.h"
#import "WebViewController.h"
#import "UIView+Extend.h"

@interface MainViewController () {
    NView *_collectionView;
}
@property(nonatomic, retain) NSArray *images;

@end


@implementation MainViewController
@synthesize state = _state;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _state = TabViewLoadInit;
        if (IOS7PLUS) {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        NSLog(@"初始化TAESDKing");
        [[TaeSDK sharedInstance] asyncInit:^{
//            [self alert:@"初始化成功"];
            NSLog(@"初始化成功");

        }                   failedCallback:^(NSError *error) {
            [self.view alertWithTitle:@"错误" message:@"taesdk初始化错误" onBtnClicked:^(int btnIndex) {
                NSLog(@"初始化失败 %@", error);
                //abort();
            }];
        }];

        __block MainViewController *selfBlock = self;
        _clickCB = ^(NSDictionary *data) {
            int type = [[data objectForKey:@"type"] intValue];

            switch (type) {
                case 0: {
                    NSMutableDictionary *toData = [[NSMutableDictionary alloc] init];
                    if ([data objectForKey:@"name"])
                        [toData setObject:[data objectForKey:@"name"] forKey:@"title"];
                    if ([data objectForKey:@"categortyId"])
                        [toData setObject:[data objectForKey:@"categortyId"] forKey:@"subCategoryId"];
                    if ([data objectForKey:@"keyword"])
                        [toData setObject:[data objectForKey:@"keyword"] forKey:@"keyword"];
                    [toData setObject:[data objectForKey:@"sort"] ? [data objectForKey:@"sort"] : @1 forKey:@"sort"];

                    [ItemListViewController setSearchCondition:toData];
                    [selfBlock.navigationController pushViewController:[[ItemListViewController alloc] init] animated:YES];
                    return;
                }
                case 2: {
                    NSString *itemId = [data valueForKey:@"tbItemId"];
                    [selfBlock presentViewController:[ItemDetailViewController startWithItemId:itemId] animated:YES completion:nil];
                    return;
                }
                case 1: {

                    NSString *url = [data valueForKey:@"h5Url"];
                    NSString *name = [data valueForKey:@"name"];
                    [selfBlock.navigationController pushViewController:[WebViewController controllerWithUrl:url title:name] animated:YES];
                    return;
                }
                default:
                    break;

            }

        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
//    [self setNeedsStatusBarAppearanceUpdate];
    [self addTitleLabelWithText:@"TAE DEMO" withHeight:VIEW_NAV_HEIGHT fontSize:17 withColor:[UIColor whiteColor]];


}

- (void)setUpViews {
    //
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadPinView];

}

- (void)loadPinView {
    int heightFix = VIEW_START_Y_WITH_NAV;

    //self.edgesForExtendedLayout = UIExtendedEdgeNone;
    _collectionView = [[NView alloc]
            initWithFrame:CGRectMake(ZERO, heightFix, SCREEN_WIDTH, SCREEN_HEIGHT - (TAB_BAR_HEIGHT + SCREEN_START_Y + VIEW_NAV_HEIGHT))

    ];
    _collectionView.cellClickCB = _clickCB;
    _state = TabViewLoadStart;
    __block MainViewController *selfBlock = self;
    [_collectionView setUrl:@"/openApi/index/getItems"
                  successCB:^{
                      selfBlock.state = TabViewLoadSucc;
                  }
                   failedCB:^{
                       selfBlock.state = TabViewLoadFailed;
                   }

    ];

    NSLog(@"self.view.frame.size.height----%f", SCREEN_HEIGHT);
    [[self view] addSubview:_collectionView];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (void)click:(BannerFrame *)imageFrame didSelectItem:(BannerItem *)item {

}

#pragma mark - 当这个tab被选中的时候 判断是否初始化过 如果没有 重新来一次

- (void)didTabSelected {
    NSLog(@"mainview c did tab seleted， _state is %d", _state);
    if (_state == TabViewLoadFailed) {
        [self loadPinView];
    }

}


@end
