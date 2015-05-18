//
// Created by huamulou on 14-9-5.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import "BannerFrame.h"
#import "Constants.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"

#define SWITCH_FOCUS_PICTURE_INTERVAL 3.0


@interface BannerFrame () {

    UIScrollView *_scrollView;
    CustomPageControl *_pageControl;

    NSMutableArray *items;


}
@property (nonatomic, retain)    NSMutableArray *datas;

- (void)setupViews;

- (void)switchItem;
@end


@implementation BannerFrame


#pragma mark - 通过url和位置来初始化 TODO url要换成真实的

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    self.backgroundColor = MIAN_VIEW_PIN_BACKGROUND_COLOR;
    if (self) {
    }
    return self;
}


- (void)setDataUrl:(NSString *)dataUrl {
    _dataUrl = dataUrl;

    [self
            loadItemsFromUrl:dataUrl
                     success:^(NSMutableArray *array) {
                         items = array;
                         [self setupViews];
                     }
                      failed:^{
                          NSLog(@"Error: 获取banner数据失败，你说该怎么办, %@---", dataUrl);
                      }];
}

#pragma mark - 使用afn框架获取json数据，block来做callback和异步实在是太爽了

- (void)loadItemsFromUrl:(NSString *)url success:(void (^)(NSMutableArray *items))successCB failed:(void (^)(void))failedCB {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager
            GET:url
     parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            /**
            * af框架直接帮你转型了，不知道是不是用的原生的，原生的速度才是最快的 TODO 看看源代码
            */
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                id code = [responseObject objectForKey:@"code"];
                if ([code isKindOfClass:[NSNumber class]]
                        && [(NSNumber *) code isEqualToNumber:[[NSNumber alloc] initWithInt:200]]) {
                    _datas = [responseObject objectForKey:@"data"];
                    int i = 0;
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    for (NSDictionary *data in _datas) {
                        BannerItem *bannerItem = [[BannerItem alloc] initWithImageURL:[data objectForKey:@"picUrl"] sequence:i];
                        [array addObject:bannerItem];
                        i++;
                    }
                    successCB(array);
                }

            } else {
                failedCB();
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failedCB();
            NSLog(@"Error: %@", error);
        }
    ];

}


- (void)pageControlPageDidChange:(CustomPageControl *)pc {
    CGFloat targetX = pc.currentPage * _scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
}

- (void)dealloc {
}


#pragma mark - private method

- (void)setupViews {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(ZERO, ZERO, SCREEN_WIDTH, MAIN_VIEW_BANNER_IMAGE_VIEW_HEIGHT)];

    CGSize size = CGSizeMake(100, 7.9);
    float pageControlX = self.bounds.size.width * 0.5 - size.width * 0.5;
    float pageControlY = self.bounds.size.height - size.height - DEFAULT_SPACE;
    NSLog(@"pagecontrol x-%f, y-%f", pageControlX, pageControlY);
    _pageControl = [
            [CustomPageControl alloc]
//            initWithFrame:CGRectMake(ZERO, ZERO, SCREEN_WIDTH, MAIN_VIEW_BANNER_IMAGE_VIEW_HEIGHT)
            initWithFrame:CGRectMake(pageControlX, pageControlY, size.width, size.height)
//            initWithFrame:CGRectMake(0, 100, size.width, size.height)
    ];

//    _pageControl.backgroundColor = [UIColor blackColor];
    /**
    * 变态啊 一个点点有这么多的设置项，还让不让人活了
    */
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;

    _pageControl.numberOfPages = items.count;
    _pageControl.currentPage = 0;
    _pageControl.delegate = self;
    _pageControl.dotOtherColor = MAIN_VIEW_BANNER_DOT_OTHER_COLOR;
    _pageControl.dotOtherAlpha = 0.40;
    _pageControl.dotOtherBorderAlpha = 0.16;
    _pageControl.dotOtherBorderColor = MAIN_VIEW_BANNER_DOT_OTHER_BORDER_COLOR;

    _pageControl.dotCurrentColor = MAIN_VIEW_BANNER_DOT_COLOR_S;
    _pageControl.dotCurrentAlpha = 1.0;
    _pageControl.dotCurrentBorderAlpha = 0.16;
    _pageControl.dotCurrentBorderColor = MAIN_VIEW_BANNER_DOT_COLOR_S;


    _scrollView.delegate = self;

    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];

    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * items.count, _scrollView.frame.size.height);
    for (int i = 0; i < items.count; i++) {
        BannerItem *item = [items objectAtIndex:i];
        //添加图片展示按钮
//        UIImageView setDe
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:item.imageURL] placeholderImage:nil];
        [imageView setFrame:CGRectMake(i * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setBackgroundColor:[UIColor whiteColor]];
        imageView.tag = i;
        //添加点击事件
//        [imageView addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:imageView];
    }
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];


    [self performSelector:@selector(switchItem) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];

}


- (void)switchItem {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchItem) object:nil];

    if (items.count > 0) {
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        [self moveToTargetPosition:targetX];
    }

    [self performSelector:@selector(switchItem) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
}


- (void)moveToTargetPosition:(CGFloat)targetX {
    //  NSLog(@"moveToTargetPosition : %f", targetX);
    if (targetX >= _scrollView.contentSize.width) {
        targetX = 0.0;
    }

    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    _pageControl.currentPage = (int) (_scrollView.contentOffset.x / _scrollView.frame.size.width);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pageControl.currentPage = (int) (scrollView.contentOffset.x / scrollView.frame.size.width);

}


- (void)onClick:(UITapGestureRecognizer *)sender {

    float x = [sender locationInView:sender.view].x;
    float sub = x / sender.view.bounds.size.width;
    int index = -1;
    for (int j = 0; j < sub; j++) {
        index += 1;
    }


    if (_clickCB) {
        _clickCB([_datas objectAtIndex:index]);

    }
    NSLog(@"click button tag is %d", index);
}


- (UIImage *)getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数%@", fileURL);
    UIImage *result;

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    NSLog(@"图片的size %f - %f ", result.size.width, result.size.height);

    return result;
}

@end