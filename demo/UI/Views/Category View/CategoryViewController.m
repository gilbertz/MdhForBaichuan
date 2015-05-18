//
//  CategoryViewController.m
//  demo
//
//  Created by huamulou on 14-9-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "CategoryViewController.h"
#import "Constants.h"
#import "UIViewController+TitleLabel.h"
#import "CustomSearchBar.h"
#import "URLUtil.h"
#import "ItemListViewController.h"


#define SEARCH_BAR_HEIGHT 50.0

@interface CategoryViewController () {
    CustomSearchBar *_customSearchBar;
    float _heightFix;
    UIButton *_btnAccessoryView;
    CategoriesView *_fatherCategoriesView;
    SubCategoriesView *_subCategoriesView;


}
@property(nonatomic, retain) UIView *splitLine;
@end

@implementation CategoryViewController

@synthesize state = _state;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _heightFix = VIEW_START_Y_WITH_NAV;
        _state = TabViewLoadInit;
        if (IOS7PLUS) {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleLabelWithText:@"类目" withHeight:VIEW_NAV_HEIGHT fontSize:17 withColor:[UIColor whiteColor]];
    [self loadSearchBar];

    [self loadLine];

    [self loadFatherCategories];
    [self loadSubCategoryView];
    [self loadFatherData];
    [self addAccessoryView];


}


- (void)loadLine {
    _splitLine = [[UIView alloc] initWithFrame:CGRectMake(ZERO, _heightFix + SEARCH_BAR_HEIGHT, SCREEN_WIDTH, VIEW_BORDERWIDTH)];
    _splitLine.backgroundColor = DEFAULT_BORDER_COLOR;
    [self.view addSubview:_splitLine];

}

- (void)loadFatherCategories {
    float top = VIEW_BORDERWIDTH + _heightFix + CATEGORY_SEARCHBAR_HEIGHT;
    _fatherCategoriesView = [[CategoriesView alloc] initWithFrame:CGRectMake(ZERO, top, 78, SCREEN_HEIGHT - CATEGORY_SEARCHBAR_HEIGHT - TAB_BAR_HEIGHT - SCREEN_START_Y - VIEW_NAV_HEIGHT)];
    _fatherCategoriesView.categoryDelegate = self;
    _fatherCategoriesView.bounces = NO;
    [self.view addSubview:_fatherCategoriesView];
}

- (void)loadFatherData {
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@", HTTP_API_BASE_URL, [URLUtil getURLWithParms:nil withPath:@"/openApi/category/getParentCategories"]];
    [_fatherCategoriesView loadWithUrl:url
                             successCB:^{
                                 _state = TabViewLoadSucc;
                             }
                              failedCB:^{
                                  _state = TabViewLoadFailed;
                              }];

}

- (void)loadSearchBar {
    _customSearchBar = [[CustomSearchBar alloc] initWithFrame:CGRectMake(0, _heightFix, SCREEN_WIDTH, SEARCH_BAR_HEIGHT)];
    _customSearchBar.delegate = self;

    [self.view insertSubview:_customSearchBar atIndex:100];

}

- (void)addAccessoryView {
    // 遮盖层
    _btnAccessoryView = [[UIButton alloc] initWithFrame:CGRectMake(0, _heightFix + 50, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
    [_btnAccessoryView setBackgroundColor:[UIColor blackColor]];
    [_btnAccessoryView setAlpha:0.0f];
    [_btnAccessoryView addTarget:self action:@selector(ClickControlAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_btnAccessoryView atIndex:99];
}

- (void)loadSubCategoryView {
    float top = _heightFix + VIEW_BORDERWIDTH + CATEGORY_SEARCHBAR_HEIGHT;
    _subCategoriesView = [[SubCategoriesView alloc] initWithFrame:CGRectMake(CATEGORY_FATHER_CELL_WIDTH + CATEGORY_SUB_VIEW_LEFT_MARGIN, top, CATEGORY_SUB_VIEW_WIDTH, SCREEN_HEIGHT - top - TAB_BAR_HEIGHT)];
    _subCategoriesView.subCategoryDelegate = self;
    [self.view addSubview:_subCategoriesView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 遮罩层（按钮）-点击处理事件
- (void)ClickControlAction:(id)sender {
    NSLog(@"handleTaps");
    [self controlAccessoryView:0];

}


// 控制遮罩层的透明度
- (void)controlAccessoryView:(float)alphaValue {

    [UIView animateWithDuration:0.2 animations:^{
        //动画代码
        [_btnAccessoryView setAlpha:alphaValue];
    }                completion:^(BOOL finished) {
        if (alphaValue <= 0) {
            [_customSearchBar resignFirstResponder];
            [_customSearchBar setShowsCancelButton:NO animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:YES];

        }

    }];
}

// UISearchBar得到焦点并开始编辑时，执行该方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [_customSearchBar setShowsCancelButton:YES animated:YES];
    // [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self controlAccessoryView:0.2];// 显示遮盖层。
//    [_customSearchBar setTintColor:[UIColor redColor]];
    if (!_customSearchBar.cancleButton) {
        if (IOS7PLUS) {
            for (UIView *subv in _customSearchBar.subviews) {
                for (UIView *view in subv.subviews) {

                    if ([view isKindOfClass:[UIButton class]]) {
                        UIButton *cannelButton = (UIButton *) view;
                        [cannelButton setTitle:@"取消" forState:UIControlStateNormal];
                        break;
                    }
                }
            }
        } else {
            for (UITextField *view in _customSearchBar.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *cannelButton = (UIButton *) view;
                    [cannelButton setTitle:@"取消" forState:UIControlStateNormal];
                    break;
                }
            }
        }
    }
    return YES;

}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"---%@", searchBar.text);
    [_customSearchBar resignFirstResponder];// 放弃第一响应者
    [self controlAccessoryView:0];// 隐藏遮盖层。
    NSDictionary *toData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            [NSString stringWithFormat:@"%@%@", @"搜索：", searchBar.text], @"title",
            searchBar.text, @"keyword"
            , @-2, @"sort"
            , nil
    ];
    searchBar.text = @"";

    [ItemListViewController setSearchCondition:toData];
    [self.navigationController pushViewController:[[ItemListViewController alloc] init] animated:YES];


}

// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_customSearchBar resignFirstResponder];
    [_customSearchBar setShowsCancelButton:NO animated:YES];
    //  [liveViewAreaTable searchDataBySearchString:nil];// 搜索tableView数据
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self controlAccessoryView:0];// 隐藏遮盖层。

}

- (void)didSeletedFatherCategory:(NSDictionary *)data {

    NSNumber *fid = [data objectForKey:@"id"];
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithObjectsAndKeys:fid, @"categoryId", nil];
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@", HTTP_API_BASE_URL, [URLUtil getURLWithParms:parms withPath:CATEGORU_SUB_API_PATH]];
    [_subCategoriesView loadWithUrl:url name:[data objectForKey:@"name"]];
}

- (void)didSeletedSubCategory:(NSDictionary *)data {
    NSDictionary *toData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            [data objectForKey:@"name"], @"title"
            , [data objectForKey:@"id"], @"subCategoryId"
            , @1, @"sort"
            , nil
    ];
//    transition.duration = 0.3f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = @"cube";
//    transition.subtype = kCATransitionFromRight;
//    transition.delegate = self;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [ItemListViewController setSearchCondition:toData];
    [self.navigationController pushViewController:[[ItemListViewController alloc] init] animated:YES];


}


- (void)didTabSelected {

    if (_state = TabViewLoadFailed) {
        [self loadFatherData];
    }
}


@end
