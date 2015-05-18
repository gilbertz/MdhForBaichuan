//
//  ItemDetailViewController.m
//  demo
//
//  Created by huamulou on 14-9-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ItemDetailViewController.h"
#import "ItemDetailTitleView.h"
#import "URLUtil.h"
#import "Constants.h"
#import "UIView+Toast.h"
#import "ItemDetailServiceView.h"
#import "ItemDetailBuyArea.h"
#import "ItemDetailContentView.h"
#import "UIFont+FontHeight.h"


#define ITEM_DETAIL_API_URL @"/openApi/category/getItemDetail"

@interface ItemDetailViewController ()


@property(nonatomic, retain) UIButton *backButton;
@property(nonatomic, retain) NSDictionary *itemData;
@property(nonatomic, retain) NSDictionary *backItemData;
@property(nonatomic, retain) NSDictionary *baichuanItem;
@property(nonatomic, retain) NSDictionary *aitaoItemData;
@property(nonatomic, assign) BOOL isTmall;
@property(nonatomic, retain) NSString *price;
@property(nonatomic, retain) NSString *umpPrice;
@property(nonatomic, retain) NSString *itemTitle;
@property(nonatomic, retain) NSDictionary *shopData;


@property(nonatomic, retain) UIScrollView *scrollView;
@property(nonatomic, retain) UIImageView *titleImage;
@property(nonatomic, retain) ItemDetailTitleView *itemDetailTitleView;
@property(nonatomic, retain) ItemDetailServiceView *itemDetailServiceView;
@property(nonatomic, retain) ItemDetailBuyArea *itemDetailBuyArea;
@property(nonatomic, retain) ItemDetailContentView *itemDetailContentView;
@end

@implementation ItemDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.



}


- (NSString *)getFormattedNumber:(double)f {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:f]];
    return formattedNumberString;
}

- (void)setTbItemId:(NSString *)tbItemId {
    [self clear];
//    _mainContentView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BUY_AREA_HEIGHT)];
//    _mainContentView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mainContentView0.frame.size.width, _mainContentView0.frame.size.height)];
//    [self.view addSubview:_mainContentView0];
//    [_mainContentView0 addSubview:_mainContentView1];

    _tbItemId = tbItemId;

    if (_tbItemId) {
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:_tbItemId, @"id", nil];

        NSString *realUrl = [URLUtil getURLWithParms:data withPath:ITEM_DETAIL_API_URL];
        realUrl = [[NSString alloc] initWithFormat:@"%@%@", HTTP_API_BASE_URL, realUrl];
        UIActivityIndicatorView *_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = self.view.bounds;
        [self.view addSubview:_activityView];
        [_activityView startAnimating];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager
                GET:realUrl
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [_activityView stopAnimating];
                [_activityView removeFromSuperview];
                NSLog(@"%@", responseObject);
                id code = [responseObject objectForKey:@"code"];
                if ([code isKindOfClass:[NSNumber class]]
                        && [(NSNumber *) code isEqualToNumber:[[NSNumber alloc] initWithInt:200]]) {
                    _itemData = responseObject;
                    _shopData = [responseObject objectForKey:@"aitaobaoShop"];
                    _isTmall = [[[_shopData valueForKey:@"shopType"] uppercaseString] isEqualToString:@"B"];;

                    _baichuanItem = [responseObject objectForKey:@"baichuanItem"];

                    NSDictionary *item = [responseObject objectForKey:@"item"];
                    _backItemData = item;
                    _itemTitle = [item valueForKey:@"name"];


                    _price = [self getFormattedNumber:(float) [[item objectForKey:@"price"] intValue] / 100];
                    if ([item objectForKey:@"umpPrice"])
                        _umpPrice = [self getFormattedNumber:(float) [[item objectForKey:@"umpPrice"] intValue] / 100];
                    if (item) {
                        [self setUpViews];
                    }
                    [self loadOthersWithSuccess:YES];
                }
                else {
                    [self loadOthersWithSuccess:NO];
                    [self.view makeToast:[responseObject valueForKey:@"msg"] ? [responseObject valueForKey:@"msg"] : @"数据加载失败" duration:0.2 position:@"center"];
                    NSLog(@"下载商品数据失败 url - %@ \n\t error-%@", realUrl, [responseObject valueForKey:@"msg"] ? [responseObject valueForKey:@"msg"] : @"");
                }


            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self loadOthersWithSuccess:NO];
                [_activityView stopAnimating];
                [_activityView removeFromSuperview];
                [self.view makeToast:@"下载商品数据失败" duration:0.3 position:@"top"];
                NSLog(@"下载商品数据失败 url - %@ \n\t error-%@", realUrl, error);

            }];

    }

}


- (void)setUpViews {
    [self loadScroolView];
}

- (void)loadScroolView {
    float imageHeight;
    float top = 0;
    if (SCREEN_HEIGHT >= 568) {
        imageHeight = (568 - 2 * DEFAULT_SPACE - LINEHEIGHT - [TITLE_FONT getHeight] - INNERSPACE - PRICE_FONT.pointSize - BUY_AREA_HEIGHT);
    } else {
        imageHeight = (SCREEN_HEIGHT - 2 * DEFAULT_SPACE - LINEHEIGHT - [TITLE_FONT getHeight] - INNERSPACE - PRICE_FONT.pointSize - BUY_AREA_HEIGHT);
    }


    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BUY_AREA_HEIGHT)];
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.backgroundColor = DETAIL_BACKGROUND_COLOR;
//    _scrollView.backgroundColor = [UIColor yellowColor];

    _titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, imageHeight)];
    NSString *picUrl = _backItemData ? [[_backItemData objectForKey:@"picList"] objectAtIndex:0] : @"";
    [_titleImage sd_setImageWithURL:[NSURL URLWithString:picUrl]];
    _titleImage.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_titleImage];


    top += imageHeight;

    _itemDetailTitleView = [[ItemDetailTitleView alloc] initWithIsTmall:_isTmall title:_itemTitle price:_price discountPrice:_umpPrice];
    CGSize size = _itemDetailTitleView.getSize;
    _itemDetailTitleView.frame = CGRectMake(0, top, size.width, size.height);
    [_itemDetailTitleView setUp];
    [_scrollView addSubview:_itemDetailTitleView];

    top += [_itemDetailTitleView getHeight];


    NSMutableArray *carriageList = [[_baichuanItem objectForKey:@"deliveryInfo"] objectForKey:@"carriageList"];
    NSDictionary *carriage = [carriageList objectAtIndex:0];
    _itemDetailServiceView = [[ItemDetailServiceView alloc]
            initWithPostFee:[NSString stringWithFormat:@"%@%@", [carriage valueForKey:@"name"], [carriage valueForKey:@"price"]]
                monthlySale:[NSString stringWithFormat:@"%@", [_backItemData objectForKey:@"monthlySales"]]
                       area:[_backItemData valueForKey:@"location"]];
    CGFloat itemDetailServiceViewHeight = [_itemDetailServiceView getHeight];
    _itemDetailServiceView.frame = CGRectMake(0, top, SCREEN_WIDTH, itemDetailServiceViewHeight);
    [_itemDetailServiceView setUp];
    [_scrollView addSubview:_itemDetailServiceView];


    top += DEFAULT_SPACE + itemDetailServiceViewHeight;
    _itemDetailContentView = [[ItemDetailContentView alloc] initWithContents:[_itemData objectForKey:@"mobileItemDesc"]];
    [_itemDetailContentView setUp];
    CGFloat itemDetailContentViewHeight = [_itemDetailContentView getHeight];
    _itemDetailContentView.frame = CGRectMake(0, top, SCREEN_WIDTH, itemDetailContentViewHeight);
    __block ItemDetailViewController *selfBlock = self;

    _itemDetailContentView.imageCompleteCallBack = ^(UIImage *image) {
        [selfBlock reSetHeight];
        // [_itemDetailContentView setUp];
    };


    [_scrollView addSubview:_itemDetailContentView];


    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, top + itemDetailContentViewHeight);

    [self.view addSubview:_scrollView];

}

- (void)reSetHeight {
    CGFloat height = 0;
    height += _titleImage.bounds.size.height;
    height += [_itemDetailTitleView getHeight];
    height += [_itemDetailServiceView getHeight];
    height += DEFAULT_SPACE;

    float newHeight = [_itemDetailContentView getHeight];
    _itemDetailContentView.frame = CGRectMake(0, height, SCREEN_WIDTH, newHeight);
    height += [_itemDetailContentView getHeight];

    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, height);

}

- (void)loadOthersWithSuccess:(BOOL)isSuccess {
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(BACK_BTN_LEFT_MARGIN, BACK_BTN_TOP_MARGIN, BACK_BTN_R, BACK_BTN_R);
    [_backButton setBackgroundImage:BACK_BTN_BACKGROUND_IMAGE forState:UIControlStateNormal];

    [_backButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchDown];
    _itemDetailContentView.backButton = _backButton;
//    dispatch_async(dispatch_get_main_queue(), ^{
    [self.view addSubview:_backButton];
//    });
//    [self performSelectorOnMainThread:@selector(addSubview:)
//                           withObject:_backButton
//                        waitUntilDone:YES];
    if (isSuccess) {
        _itemDetailBuyArea = [[ItemDetailBuyArea alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BUY_AREA_BUYNOW_BUTTON_AREA_HEIGHT, SCREEN_WIDTH, BUY_AREA_BUYNOW_BUTTON_AREA_HEIGHT)];
        [_itemDetailBuyArea setAreaStaus:ItemDetailBuyAreaHide];
        _itemDetailBuyArea.baichuanData = [[NSMutableDictionary alloc] initWithDictionary:_baichuanItem];
        _itemDetailBuyArea.aitaobaoShop = [[NSMutableDictionary alloc] initWithDictionary:_aitaoItemData];
        _itemDetailBuyArea.itemFullData = [[NSMutableDictionary alloc] initWithDictionary:_itemData];
        _itemDetailBuyArea.backgroundColor = [UIColor whiteColor];
        __block ItemDetailViewController *bolckSelf = self;
        __block ItemDetailBuyArea *blockItemDetailBuyArea = _itemDetailBuyArea;
        // __block UIView *blockMCV1 = _mainContentView1;
        _itemDetailBuyArea.buyNowButtonCB = ^(CGFloat height) {
            [bolckSelf addAccessoryView:height below:blockItemDetailBuyArea];
            [UIView beginAnimations:@"showBuyArea" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDuration:0.2];
            //   CATransform3D rotate = CATransform3DMakeRotation(M_PI / 12, 1, 0, 0);
            //   blockMCV1.layer.transform = CATransform3DPerspect(rotate, CGPointMake(0, 0), 500);

            blockItemDetailBuyArea.frame = CGRectMake(0, SCREEN_HEIGHT - height, SCREEN_WIDTH, height);
            [UIView setAnimationDelegate:bolckSelf];
            // [UIView setAnimationDidStopSelector:@selector(animationFinished:)];
            [UIView commitAnimations];


        };

        [self.view addSubview:_itemDetailBuyArea];
    }
}

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ) {
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f / disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ) {
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

- (void)addAccessoryView:(CGFloat)height below:(UIView *)view {
    // 遮盖层
    UIButton *_btnAccessoryView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_btnAccessoryView setBackgroundColor:[UIColor blackColor]];
    [_btnAccessoryView setAlpha:0.75f];
    [_btnAccessoryView addTarget:self action:@selector(clickAccessoryAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_btnAccessoryView belowSubview:view];
}

- (void)clickAccessoryAction:(UIButton *)sender {
    [sender removeFromSuperview];
    [_itemDetailBuyArea setAreaStaus:ItemDetailBuyAreaHide];
    [UIView beginAnimations:@"showBuyArea" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    self.view.layer.transform = CATransform3DIdentity;
    _itemDetailBuyArea.frame = CGRectMake(0, SCREEN_HEIGHT - [_itemDetailBuyArea getHeight], SCREEN_WIDTH, [_itemDetailBuyArea getHeight]);
    [UIView setAnimationDelegate:self];
    //  [UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    [UIView commitAnimations];
}

- (void)onClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        return;
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (IOS7PLUS)
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (IOS7PLUS)
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}





+ (instancetype)startWithItemId:(NSString *)tbItemId {
    ItemDetailViewController *instance = [ItemDetailViewController sharedInstance];
    instance.tbItemId = tbItemId;
    return instance;
}

+ (ItemDetailViewController *)sharedInstance {
    static dispatch_once_t once;
    static ItemDetailViewController *instance;
    dispatch_once(&once, ^{
        instance = [[ItemDetailViewController alloc] init];
    });



    return instance;
}


-(void) clear{
    for(UIView *view in self.view.subviews){
        [view removeFromSuperview];
    }
   _backButton = nil;
   _itemData = nil;
   _backItemData = nil;
   _baichuanItem = nil;
   _aitaoItemData = nil;
   _price = nil;
   _umpPrice = nil;
   _itemTitle = nil;
   _shopData = nil;
    _scrollView = nil;
    _titleImage = nil;
    _itemDetailTitleView = nil;
    _itemDetailServiceView = nil;
    _itemDetailBuyArea  = nil;
    _itemDetailContentView = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
