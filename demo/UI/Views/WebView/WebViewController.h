//
//  WebViewController.h
//  demo
//
//  Created by huamulou on 14-9-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController


@property(nonatomic, retain) NSString *url;
@property(nonatomic, retain) NSString *webViewTitle;

- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title;

+ (instancetype)controllerWithUrl:(NSString *)url title:(NSString *)title;


@end
