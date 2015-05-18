//
//  SettingsViewController.m
//  demo
//
//  Created by huamulou on 14-9-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <TAESDK/TaeSDK.h>
#import "SettingsViewController.h"
#import "Constants.h"
#import "UIViewController+TitleLabel.h"
#import "UIView+nib.h"
#import "SettingsView.h"
#import "NSString+Extend.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //   self.view = [UIView viewFromNibWithFileName:@"MySettingView" owner:self index:0] ;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackButton];
    [self setUpViews];


}

- (void)setUpViews {
    SettingsView *subView = [UIView viewFromNibWithFileName:@"SubViewsOfMyView" class:[SettingsView class] index:3];
    NSDictionary *dictionary = @{@"subView" : subView};
    [self.view addSubview:subView];
    subView.outBtn.backgroundColor = VIEW_THEME_COLOR;
    subView.outBtn.layer.cornerRadius  = DEFAULT_CORNERRADIUS;
    subView.outBtn.layer.masksToBounds = YES;
    subView.translatesAutoresizingMaskIntoConstraints = NO;

    subView.clickCB = ^{
//        [TaeSession sharedInstance]
        [[TaeSDK sharedInstance] logout];

        [self.navigationController popViewControllerAnimated:YES];
    }   ;

    float height = VIEW_START_Y_WITH_NAV;

    NSArray *cons_V = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"%@%f%@", @"V:|-", height, @"-[subView(100)]"]
                                                              options:0
                                                              metrics:nil
                                                                views:dictionary];
    NSArray *cons_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subView]-0-|"
                                                              options:0
                                                              metrics:nil
                                                                views:dictionary];
    [self.view addConstraints:cons_H];
    [self.view addConstraints:cons_V];


}

- (IBAction)doClickBackAction:(UIButton *)sender {
    NSLog(@"back button pressed");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadBackButton {
    UIImage *backImage = [UIImage imageNamed:@"top_back_btn"];
    CGRect backframe = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    UIButton *backButton = [[UIButton alloc] initWithFrame:backframe];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:13];


    if ([self respondsToSelector:@selector(doClickBackAction:)]) {
        [backButton addTarget:self action:@selector(doClickBackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];
    CGFloat width = [@"设置" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) withTextFont:[UIFont systemFontOfSize:17] withLineSpacing:0].width;

    [self addTitleLabel:CGRectMake(0, 0, width, VIEW_NAV_HEIGHT) text:@"设置" fontSize:17 color:[UIColor whiteColor]];
}
- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    if (!IOS7PLUS) {
        // Add a spacer on when running lower than iOS 7.0
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil action:nil];
        negativeSpacer.width = 16;
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
    } else {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil action:nil];
        negativeSpacer.width = 6;
        // Just set the UIBarButtonItem as you would normally
        [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    }
}

@end
