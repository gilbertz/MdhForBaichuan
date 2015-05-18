//
//  ItemDetailContentView.m
//  demo
//
//  Created by huamulou on 14-9-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "ItemDetailContentView.h"
#import "FunctionBarButton.h"
#import "Constants.h"
#import "NSString+Extend.h"
#import "ItemImageView.h"
#import "UIView+nib.h"
#import "UIView+Extend.h"


@interface ItemDetailContentView () {

}

@property(nonatomic, retain) UIView *functionBar;
@property(nonatomic, retain) NSMutableDictionary *imageCache;
@property(nonatomic, retain) NSMutableDictionary *cells;
@property(nonatomic, retain) NSMutableDictionary *heights;
@property(nonatomic, retain) FunctionBarButton *detailContentBtn;

@property(nonatomic, assign) CGRect lastPosition;
//图片的数量
@property(nonatomic, assign) NSInteger imageCount;
//已经渲染的图片数量
@property(nonatomic, assign) NSInteger imageRendered;
@property(nonatomic, retain) UIActivityIndicatorView *indicatorView;

@end

#define indicatorView_width 20
#define indicatorView_left (SCREEN_WIDTH - indicatorView_width)/2

@implementation ItemDetailContentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageCache = [[NSMutableDictionary alloc] init];
        self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        _imageCount = 0;
        _imageRendered = 0;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (float)getImageHeight:(UIImage *)image withWidth:(float)width {
    float rate = width / image.size.width;
    float height = image.size.height;
    if (rate < 1) {
        height = height * rate;
    }
    return height;

}


- (CGFloat)getHeight {

    float height = FUNCTION_BAR_HEIGHT + DEFAULT_SPACE;

    float width = SCREEN_WIDTH - 2 * DEFAULT_SPACE;
    if (_contents) {
        for (NSDictionary *data in _contents) {
            if ([[data objectForKey:@"type"] intValue] == 0) {
                NSString *picUrl = [data objectForKey:@"content"];

                //  NSLog(@"we need cache for %@", picUrl);
                if ([_imageCache objectForKey:picUrl]) {
                    //      NSLog(@"we got cache for %@", picUrl);
                    float tmpHeight = [[_imageCache objectForKey:picUrl] floatValue];
                    height += tmpHeight;
                } else {
                    height += 0;
                }
            } else {
                NSString *cText = [data valueForKey:@"content"];
                CGSize textSize = [cText getRectSizeOfStringWithFontSize:DETAIL_AREA_TEXT_FONT_SIZE withLineSpacing:DETAIL_AREA_TEXT_LINESPACING withBoundingRect:CGSizeMake(width, CGFLOAT_MAX)];
                height += textSize.height + DEFAULT_SPACE;
            }

        }
    }

    return height + (_imageCount > _imageRendered ? indicatorView_width * 2 : 0);


}

- (void)setUp {
    float functionBarButtonWidth = (SCREEN_WIDTH - 2 * (DEFAULT_SPACE) - 2 * FUNCTION_BAR_SPACING) / 3;
    _functionBar = [[UIView alloc] initWithFrame:CGRectMake(ZERO, ZERO, SCREEN_WIDTH, FUNCTION_BAR_HEIGHT)];
    _functionBar.backgroundColor = [UIColor whiteColor];
    _detailContentBtn = [[FunctionBarButton alloc] initWithFrame:CGRectMake(DEFAULT_SPACE, 0, functionBarButtonWidth, FUNCTION_BAR_HEIGHT)];
    _detailContentBtn.clickCallback = ^{
//        _detailContentBtn.
    };

    _detailContentBtn.btnTitle = @"图文详情";
    [_functionBar addSubview:_detailContentBtn];
    [_detailContentBtn on];
    [self addSubview:_functionBar];
    self.userInteractionEnabled = YES;

    float top = FUNCTION_BAR_HEIGHT + DEFAULT_SPACE;
    float width = SCREEN_WIDTH - (2 * DEFAULT_SPACE);
    NSLog(@"width %f", width);
    if (_contents) {
        if (!_cells) {
            _cells = [[NSMutableDictionary alloc] init];

        }
        if (!_heights) {
            _heights = [[NSMutableDictionary alloc] init];
        }
        int i = 0;
        for (NSDictionary *data in _contents) {
            NSNumber *key = [NSNumber numberWithInt:i];
            if ([[data objectForKey:@"type"] intValue] == 0) {
                _imageCount++;

                UIImageView *imageView = [[UIImageView alloc] init];
                [_heights setObject:@0 forKey:key];


                NSLog(@"add key %d in cells ", i);
                [_cells setObject:imageView forKey:key];
                [self addSubview:imageView];
                UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhoto:)];
                [imageView addGestureRecognizer:g];
                imageView.userInteractionEnabled = YES;
                imageView.frame = CGRectMake(DEFAULT_SPACE, top, SCREEN_WIDTH - 2 * DEFAULT_SPACE, 0);
                [imageView sd_setImageWithURL:[NSURL URLWithString:[data objectForKey:@"content"]]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          _imageRendered++;
                                        float width = SCREEN_WIDTH - (2 * DEFAULT_SPACE);
                                        float rate = width / image.size.width;
                                        float height = image.size.height;
                                        if (rate < 1) {
                                            height = height * rate;
                                        }
                                        [_heights setObject:[NSNumber numberWithFloat:height] forKey:key];
                                        [_imageCache setObject:[NSNumber numberWithFloat:height] forKey:[data objectForKey:@"content"]];
                                        if (_imageCompleteCallBack) {
                                            _imageCompleteCallBack(image);
                                        }

                                        if (![_cells objectForKey:key]) {
                                            [_cells setObject:imageView forKey:key];
                                        }
                                        [_heights setObject:[NSNumber numberWithFloat:height] forKey:key];
                                        [self resetPosition];
                                    }];

                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.layer.masksToBounds = YES;
                top += imageView.frame.size.height;


            } else {
                NSString *cText = [data valueForKey:@"content"];
                UILabel *label = [[UILabel alloc] init];
                label.clipsToBounds = YES;
                label.backgroundColor = [UIColor clearColor];
                CGSize textSize = [cText getRectSizeOfStringWithFontSize:DETAIL_AREA_TEXT_FONT_SIZE withLineSpacing:DETAIL_AREA_TEXT_LINESPACING withBoundingRect:CGSizeMake(width, CGFLOAT_MAX)];
                float textHeight = textSize.height;
                label.numberOfLines = 0;
                label.textColor = DETAIL_AREA_TEXT_FONT_COLR;

                label.frame = CGRectMake(DEFAULT_SPACE, top, width, textHeight);
                label.attributedText = [cText attributedStringWithChineseFontSize:DETAIL_AREA_TEXT_FONT_SIZE withNumberAndLetterFontSize:DETAIL_AREA_TEXT_FONT_SIZE withLineSpacing:DETAIL_AREA_TEXT_LINESPACING];
                top += (textHeight + DEFAULT_SPACE);
                [self addSubview:label];
                [_cells setObject:label forKey:key];
                [label sizeToFit];
                NSLog(@"add key %d in cells ", i);
                [_heights setObject:[NSNumber numberWithFloat:textHeight] forKey:key];
            }
            i++;
        }
        [self setUpIndicatorViewWithTop:top];
    }

}


- (void)setUpIndicatorViewWithTop:(CGFloat)top {
    if (_imageCount > _imageRendered) {
        if (!_indicatorView) {
            // _bottomView.backgroundColor = [UIColor whiteColor];
            _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _indicatorView.center = CGPointMake(SCREEN_WIDTH / 2, top + indicatorView_width);
            [self addSubview:_indicatorView];
            [_indicatorView startAnimating];

        } else {
            _indicatorView.center = CGPointMake(SCREEN_WIDTH / 2, top + indicatorView_width);
        }
    } else {

        [_indicatorView removeFromSuperview];
        _indicatorView = nil;
    }

}

- (UIViewController *)viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *) nextResponder;
        }
    }
    return nil;
}

- (void)resetPosition {

    float top = FUNCTION_BAR_HEIGHT + DEFAULT_SPACE;
    float width = SCREEN_WIDTH - 2 * DEFAULT_SPACE;
    NSLog(@"_cells count is %d, _heights count is %d, subview in view -%d", [_cells allKeys].count, [_heights allKeys].count, self.subviews.count);
    for (int i = 0; i < _cells.allKeys.count; i++) {
        NSNumber *key = [NSNumber numberWithInt:i];
        id view = [_cells objectForKey:key];
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *) view;
            float height = [[_heights objectForKey:key] floatValue];

            //NSLog(@"current index is-%d, current rect -%@, has image %@",i, [NSValue valueWithCGRect:CGRectMake(DEFAULT_SPACE, top, width, height)], imageView.image);
            imageView.frame = CGRectMake(DEFAULT_SPACE, top, width, height);
            top += height;
            [imageView setNeedsDisplay];

            ;
        } else {
            UILabel *label = (UILabel *) view;
            float height = [[_heights objectForKey:key] floatValue];
            NSLog(@"current index is-%d, current rect -%@", i, [NSValue valueWithCGRect:CGRectMake(DEFAULT_SPACE, top, width, height)]);
            label.frame = CGRectMake(DEFAULT_SPACE, top, width, height);
            top += height + DEFAULT_SPACE;
        }

    }

    [self setUpIndicatorViewWithTop:top];
//    [self setNeedsDisplay];
}

- (void)clickPhoto:(id)sender {
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *) sender;
    UIImageView *view = (UIImageView *) tapGestureRecognizer.view;
    UIViewController *controller = [self viewController];
    float fatherWidth = controller.view.frame.size.width;
    float fatherHeight = controller.view.frame.size.height;

    CGPoint newPoint = [view convertPoint:CGPointZero toView:controller.view];
    _lastPosition = CGRectMake(newPoint.x, newPoint.y, view.frame.size.width, view.frame.size.height);

    ItemImageView *new = [UIView viewFromNibWithFileName:@"ItemImageView" class:[ItemImageView class] index:0];

    new.userInteractionEnabled = YES;
    new.scroll.UserInteractionEnabled = YES;
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhotoSecond:)];
    [new addGestureRecognizer:g];
    new.userInteractionEnabled = YES;
    new.scroll.frame = new.bounds;

    new.scroll.delegate = new;
    new.image.contentMode = UIViewContentModeScaleAspectFit;

    new.frame = controller.view.bounds;

    float iHeight = (fatherWidth / view.image.size.width) * view.image.size.height;
    if (iHeight > fatherHeight) {
        iHeight = fatherHeight;
    }
    new.image.frame = CGRectMake(0, (fatherHeight - iHeight) / 2, fatherWidth, iHeight);
    new.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [controller.view addSubview:new];
    UIImageView *tmpView = [[UIImageView alloc] initWithFrame:_lastPosition];
    tmpView.contentMode = UIViewContentModeScaleAspectFit;
    tmpView.image = view.image;
    [controller.view addSubview:tmpView];
    [tmpView animateView:tmpView toFrame:new.image.frame completion:^{
        [tmpView removeFromSuperview];
        new.image.image = view.image;

    }];

}

- (void)clickPhotoSecond:(id)sender {
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *) sender;
    ItemImageView *view = (ItemImageView *) tapGestureRecognizer.view;

//    [view.image removeFromSuperview];
//    view.backgroundColor = [UIColor whiteColor];
    UIImageView *tmpView = [[UIImageView alloc] initWithFrame:view.image.frame];
    tmpView.image = view.image.image;
    UIView *fatherView = [self viewController].view;
    tmpView.contentMode = UIViewContentModeScaleAspectFit;
    [fatherView insertSubview:tmpView belowSubview:_backButton];
    [view removeFromSuperview];
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         tmpView.frame = _lastPosition;
                     } completion:^(BOOL finished) {
//
//                [view addSubview:view.image];
                [tmpView removeFromSuperview];
            }];


//    [tmpView animateView:tmpView toFrame:_lastPosition completion:^{
//        [tmpView removeFromSuperview];
//    }];


}

- (instancetype)initWithContents:(NSMutableArray *)contents {
    self = [super init];
    if (self) {
        self.contents = contents;
        self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    }

    return self;
}

+ (instancetype)viewWithContents:(NSMutableArray *)contents {
    return [[self alloc] initWithContents:contents];
}


@end
