//
//  CategoryViewController.h
//  demo
//
//  Created by huamulou on 14-9-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTabBarChinldVIewControllerDelegate.h"
#import "CategoriesView.h"
#import "SubCategoriesView.h"
#import "CustomTabView.h"

@interface CategoryViewController : UIViewController <UISearchBarDelegate, FatherCategorySeleted, SubCategorySeleted, CustomTabView>
@property (nonatomic, assign) id<CCTabBarChinldVIewControllerDelegate> delegate;

@end
