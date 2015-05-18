//
//  WebViewController.m
//  demo
//
//  Created by huamulou on 14-9-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "WebViewController.h"
#import "Constants.h"
#import "UIViewController+TitleLabel.h"
#import "NSString+Extend.h"

@interface WebViewController ()

@property(nonatomic, retain) UIWebView *webView;
@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    // Do any additional setup after loading the view.
}


- (void)setUrl:(NSString *)url {
    _url = url;

}


- (void)setUpViews {
    if (_url) {


        _webView = [[UIWebView alloc] init];
        [self.view addSubview:_webView];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *viewsDictionary = @{@"_webView" : _webView};

        NSString *cString = @"V:|-0-[_webView]-0-|";

        NSArray *constraint_POS_V_SVF = [NSLayoutConstraint constraintsWithVisualFormat:cString
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:viewsDictionary];
        NSArray *constraint_POS_H_SVF = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_webView]-0-|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:viewsDictionary];

        [self.view addConstraints:constraint_POS_V_SVF];
        [self.view addConstraints:constraint_POS_H_SVF];


        NSURL *url = [NSURL URLWithString:_url];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        [self loadBackButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];

    CGFloat width = [_webViewTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) withTextFont:[UIFont systemFontOfSize:17] withLineSpacing:0].width;
    [self addTitleLabel:CGRectMake(0, 0, width, VIEW_NAV_HEIGHT) text:_webViewTitle  fontSize:17 color:[UIColor whiteColor]];
}


- (IBAction)doClickBackAction:(UIButton *)sender {
    NSLog(@"back button pressed");
    [self.navigationController popViewControllerAnimated:YES];
}

- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title {
    self = [super init];
    if (self) {
        self.url = url;
        self.webViewTitle = title;
    }

    return self;
}

+ (instancetype)controllerWithUrl:(NSString *)url title:(NSString *)title {
    return [[self alloc] initWithUrl:url title:title];
}


@end
