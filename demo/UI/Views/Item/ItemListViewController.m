//
//  ItemListViewController.m
//  demo
//
//  Created by huamulou on 14-9-12.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "ItemListViewController.h"
#import "Constants.h"
#import "UIViewController+TitleLabel.h"
#import "ItemListCollectionView.h"
#import "SortItemCell.h"
#import "ItemDetailViewController.h"
#import "NSString+Extend.h"
#import "UIViewController+Extend.h"

@interface ItemListViewController () {
    ItemListCollectionView *_itemListCollectionView;
    //销量
    SortItemCell *_volumeBtn;
    //最新
    SortItemCell *_newBtn;
    //价格
    SortItemCell *_pricetBtn;
    UIView *_sortView;
    NSInteger _heightFix;
}

@end

static NSDictionary *searchCondition;

@implementation ItemListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS7PLUS) {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        _heightFix = VIEW_START_Y_WITH_NAV;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];

    // Do any additional setup after loading the view.
}

- (void)setUpViews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadItemList];
    [self loadBackButton];
    [self loadSortView];
}

- (void)loadSortView {
    _sortView = [[UIView alloc] initWithFrame:CGRectMake(ZERO, _heightFix, SCREEN_WIDTH, ITEM_SORT_HEIGHT)];
    //  _sortView.backgroundColor = [UIColor blackColor];

    CGFloat innerMargin = (SCREEN_WIDTH - 2 * ITEM_SORT_LEFT_RIGHT_MARGIN - 3 * ITEM_SORT_CELL_WIDTH) / 2;


    _newBtn = [[SortItemCell alloc] initWithFrame:CGRectMake(ITEM_SORT_LEFT_RIGHT_MARGIN, 0, ITEM_SORT_CELL_WIDTH, ITEM_SORT_HEIGHT) name:@"最新"];
    _volumeBtn = [[SortItemCell alloc] initWithFrame:CGRectMake(ITEM_SORT_LEFT_RIGHT_MARGIN + ITEM_SORT_CELL_WIDTH + innerMargin, 0, ITEM_SORT_CELL_WIDTH, ITEM_SORT_HEIGHT)
                                                name:@"销量"];
    _pricetBtn = [[SortItemCell alloc]
            initWithFrame:CGRectMake(ITEM_SORT_LEFT_RIGHT_MARGIN + ITEM_SORT_CELL_WIDTH + innerMargin + ITEM_SORT_CELL_WIDTH + innerMargin, 0, ITEM_SORT_CELL_WIDTH, ITEM_SORT_HEIGHT)
                     name:@"价格"];
    [_sortView addSubview:_newBtn];
    [_sortView addSubview:_volumeBtn];
    [_sortView addSubview:_pricetBtn];
    int sort = fabs([[searchCondition objectForKey:@"sort"] intValue]);
    switch (sort) {
        case 1:
            [_pricetBtn on];
            break;
        case 2:
            [_newBtn on];
            break;
        case 3:
            [_volumeBtn on];
            break;
    }
    __block SortItemCell *newBtnInBlock = _newBtn;
    __block SortItemCell *priceBtnInBlock = _pricetBtn;
    __block SortItemCell *volumeBtnInBlock = _volumeBtn;
    __block ItemListCollectionView *listCView = _itemListCollectionView;


    _newBtn.clickCallback = ^{
        [newBtnInBlock on];
        [priceBtnInBlock off];
        [volumeBtnInBlock off];
        listCView.dataFromUrl = nil;
        listCView.sort = -2;
        [listCView loadDataWithType:ItemListReloadReplace];
    };
    _pricetBtn.clickCallback = ^{
        [newBtnInBlock off];
        [priceBtnInBlock on];
        [volumeBtnInBlock off];
        listCView.dataFromUrl = nil;
        listCView.sort = 1;
        [listCView loadDataWithType:ItemListReloadReplace];
    };
    _volumeBtn.clickCallback = ^{
        [newBtnInBlock off];
        [priceBtnInBlock off];
        [volumeBtnInBlock on];
        listCView.dataFromUrl = nil;
        listCView.sort = -3;
        [listCView loadDataWithType:ItemListReloadReplace];
    };

    [self.view addSubview:_sortView];
}


+ (void)setSearchCondition:(NSDictionary *)data {
    searchCondition = data;

}

+ (NSDictionary *)getSearchCondition {
    return searchCondition;
}


- (void)loadBackButton {
    UIImage *backImage = [UIImage imageNamed:@"top_back_btn"];
    CGRect backframe = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    UIButton *backButton = [[UIButton alloc] initWithFrame:backframe];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    backButton.imageView.contentMode = UIViewContentModeCenter;
    //backButton.titleLabel.font = [UIFont systemFontOfSize:13];

    [self addLeftBarButtonItem:backButton target:self action:@selector(doClickBackAction:)];

//    [backButton addTarget:self action:@selector(doClickBackAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self addLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];


    NSString *title = [searchCondition objectForKey:@"title"];
    CGFloat width = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) withTextFont:[UIFont systemFontOfSize:17] withLineSpacing:0].width;
    [self addTitleLabel:CGRectMake(0, 0, width, VIEW_NAV_HEIGHT) text:title fontSize:17 color:[UIColor whiteColor]];
}

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    if (!IOS7PLUS) {
        // Add a spacer on when running lower than iOS 7.0
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

        negativeSpacer.width = 16;
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
    } else {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil action:nil];
        negativeSpacer.width = 6;
        // Just set the UIBarButtonItem as you would n//ormally
        [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    }
}

- (IBAction)doClickBackAction:(UIButton *)sender {
    NSLog(@"back button pressed");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadItemList {

    NSLog(@"screen height%f, pubuliu height - %f", SCREEN_HEIGHT, (SCREEN_HEIGHT - (TAB_BAR_HEIGHT + SCREEN_START_Y + VIEW_NAV_HEIGHT + ITEM_SORT_HEIGHT)));

    _itemListCollectionView = [[ItemListCollectionView alloc]
            initWithFrame:CGRectMake(ZERO, _heightFix + ITEM_SORT_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - (TAB_BAR_HEIGHT + SCREEN_START_Y + VIEW_NAV_HEIGHT + ITEM_SORT_HEIGHT))
//            initWithFrame:CGRectMake(ZERO, ZERO, _itemListContainer.frame.size.width,  _itemListContainer.frame.size.height)
                    title:[searchCondition valueForKey:@"title"]
                  keyword:[searchCondition valueForKey:@"keyword"]
                     sort:[[searchCondition objectForKey:@"sort"] intValue]
            subCategoryId:[[searchCondition objectForKey:@"subCategoryId"] intValue]
    ];
    __block ItemListViewController *__blockSelf = self;
    _itemListCollectionView.selectedCallBack = ^(NSString *tbItemId) {
        ItemDetailViewController *itemDetailViewController = [ItemDetailViewController startWithItemId:tbItemId];

        [__blockSelf presentViewController:itemDetailViewController animated:YES completion:nil];

    };

    NSLog(@"self.view.frame.size.height----%f", SCREEN_HEIGHT);
//
    [[self view] addSubview:_itemListCollectionView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
