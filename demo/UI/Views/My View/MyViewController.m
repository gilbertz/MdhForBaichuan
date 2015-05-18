//
//  MyViewController.m
//  demo
//
//  Created by huamulou on 14-9-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <TAESDK/TaeSDK.h>
#import "MyViewController.h"
#import "Constants.h"
#import "MyViewTableCell.h"
#import "UIViewController+TitleLabel.h"
#import "MyViewUserInfoView.h"
#import "UIView+nib.h"
#import "SettingsViewController.h"
#import "UIButton+WebCache.h"
#import "NSString+Extend.h"

@interface MyViewController ()
@property(nonatomic, assign) BOOL isLogin;
@property(nonatomic, retain) NSArray *dataSource;

@end

#define MyViewTableCell_id @"MyViewTableCell"

@implementation MyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS7PLUS) {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleLabelWithText:@"我的" withHeight:VIEW_NAV_HEIGHT fontSize:17 withColor:[UIColor whiteColor]];

    //    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    _userInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    //self.navigationController.view.translatesAutoresizingMaskIntoConstraints= NO;

    _userInfoView = [UIView viewFromNibWithFileName:@"SubViewsOfMyView" class:[MyViewUserInfoView class] index:1];
    _userInfoView.frame = CGRectMake(0, VIEW_START_Y_WITH_NAV, SCREEN_WIDTH, 80);



    //  _menuTable.translatesAutoresizingMaskIntoConstraints = NO;
    _menuTable = [[UITableView alloc] init];
    [self.view addSubview:_userInfoView];
    [self.view addSubview:_menuTable];
    _menuTable.frame = CGRectMake(0, VIEW_START_Y_WITH_NAV + 80, SCREEN_WIDTH, SCREEN_HEIGHT - (VIEW_NAV_HEIGHT + SCREEN_START_Y + 80 + TAB_BAR_HEIGHT));





    //登录状态监听
    [[TaeSDK sharedInstance] setSessionStateChangedHandler:^(TaeSession *session) {
        if ([session isLogin]) {//未登录变为已登录
            NSLog(@"unlogin to login");
            _isLogin = true;
            dispatch_async(dispatch_get_main_queue(), ^{
                TaeUser *user = [[TaeSession sharedInstance] getUser];
                [_userInfoView.imagebtn sd_setImageWithURL:[NSURL URLWithString:user.iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"my_avatar_img"]];
                _userInfoView.userNameLabel.attributedText = [user.nick attributedStringWithChineseFontSize:17 withNumberAndLetterFontSize:17];
                _dataSource = [[NSArray alloc] initWithObjects:@"设置", nil];
                

            });
        } else {//已登录变为未登录
            NSLog(@"login to unlogin");
            [_userInfoView.imagebtn setImage:[UIImage imageNamed:@"my_avatar_img"] forState:UIControlStateNormal];
            _userInfoView.userNameLabel.attributedText = [@"账号信息" attributedStringWithChineseFontSize:17 withNumberAndLetterFontSize:17];
            _isLogin = false;
            _dataSource = [[NSArray alloc] initWithObjects:@"登录", nil];
        }
        if (_menuTable) {
             dispatch_async(dispatch_get_main_queue(), ^{
            [_menuTable reloadData];
             });
        }
    }];

    _userInfoView.backgroundColor = MY_VIEW_THEME_COLOR;

    if ([[TaeSession sharedInstance] isLogin]) {
        _isLogin = true;
        _dataSource = [[NSArray alloc] initWithObjects:@"设置", nil];
    } else {
        _isLogin = false;
        _dataSource = [[NSArray alloc] initWithObjects:@"登录", nil];
    }
    if (_isLogin) {
        TaeUser *user = [[TaeSession sharedInstance] getUser];
        [_userInfoView.imagebtn sd_setImageWithURL:[NSURL URLWithString:user.iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"my_avatar_img"]];


        _userInfoView.userNameLabel.text = user.nick;
    }

    _userInfoView.imagebtn.layer.cornerRadius = 25;
    _userInfoView.imagebtn.layer.masksToBounds = YES;
    _menuTable.delegate = self;
    _menuTable.dataSource = self;
    _menuTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _menuTable.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    _menuTable.separatorColor = DEFAULT_BACKGROUND_COLOR;
    _menuTable.sectionIndexTrackingBackgroundColor = DEFAULT_BACKGROUND_COLOR;

    [_menuTable registerClass:[MyViewTableCell class] forCellReuseIdentifier:MyViewTableCell_id];
    //    [_menuTable reloadData];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [_menuTable dequeueReusableCellWithIdentifier:MyViewTableCell_id];

    if (cell == nil) {
        return nil;
    }
    MyViewTableCell *tableCell = (MyViewTableCell *) cell;
    tableCell.titleLabel.attributedText = [[_dataSource objectAtIndex:indexPath.item] attributedStringWithChineseFontSize:17 withNumberAndLetterFontSize:17];;
    if (indexPath.item == 0) {
        tableCell.line0.hidden = NO;

    } else {
        tableCell.line0.hidden = YES;
    }
    return tableCell;


}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        return 42 + 0.5;
    }
    return 42;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //    return  [UIView viewFromNibWithFileName:@"SubViewsOfMyView" owner:self index:2];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, DEFAULT_SPACE)];
    view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {}
    UITableViewCell *cell = [self tableView:_menuTable cellForRowAtIndexPath:indexPath];

    if (!_isLogin) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        NSLog(@"asdas start");

        [[TaeSDK sharedInstance] showLogin:self.navigationController
                           successCallback:^(TaeSession *session) {
                               [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                               NSLog(@"asdas success");
                           }
                            failedCallback:^(NSError *error) {
                                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        NSLog(@"asdas failed");
                            }];
    } else {
        [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
    }
    if (cell) {
        cell.highlighted = NO;
        [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }

}


@end
