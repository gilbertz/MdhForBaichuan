//
//  ItemDetailBuyArea.m
//  demo
//
//  Created by huamulou on 14-9-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <TAESDK/TaeSDK.h>
#import <Toast/UIView+Toast.h>
#import "ItemDetailBuyArea.h"
#import "Constants.h"
#import "SkuItemInfoView.h"
#import "UIView+nib.h"
#import "SkusHeader.h"
#import "SkusFooter.h"
#import "SkusCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "SkuViewFooter.h"
#import "SkuViewConfirm.h"
#import "UIView+Extend.h"
#import "NSString+Extend.h"


#define DEFAULT_SKU_CELL_WIDTH 60
#define DEFAULT_SKU_CELL_HEIGHT 28
#define DEFAULT_SKU_HEADER_HEIGHT 35
#define DEFAULT_SKU_FOOTER_HEIGHT 8
#define OTHER_SKU_FOOTER_HEIGHT 60 + DEFAULT_SPACE
#define DEFAULT_SKU_LINE_HEIGHT (DEFAULT_SKU_HEADER_HEIGHT + DEFAULT_SKU_CELL_HEIGHT +2 *DEFAULT_SPACE + DEFAULT_SKU_FOOTER_HEIGHT)
#define DEFAULT_SKU_LINE_HEIGHT1 (DEFAULT_SKU_HEADER_HEIGHT + DEFAULT_SKU_CELL_HEIGHT +2 *DEFAULT_SPACE + OTHER_SKU_FOOTER_HEIGHT)
//#define DEFAULT_MAX 28

@interface ItemDetailBuyArea () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {


}
@property(nonatomic, retain) UIButton *buyNow;
@property(nonatomic, retain) UIView *upperLine;
@property(nonatomic, retain) UIView *skuArea;
@property(nonatomic, retain) SkuItemInfoView *skuItemInfoView;
@property(nonatomic, retain) UICollectionView *collectionView;
@property(nonatomic, retain) SkuViewConfirm *footer;


@property(nonatomic, retain) NSMutableArray *skuProps;

@property(nonatomic, assign) CGFloat viewHeight;

@property(nonatomic, retain) NSMutableDictionary *seletedRows;

@property(nonatomic, assign) NSInteger numNow;
@property(nonatomic, assign) NSInteger numMax;
@property(nonatomic, assign) NSString *skuIdNow;
@property(nonatomic, assign) NSString *openiid;
@property(nonatomic, assign) NSString *itemTitle;


@property(nonatomic, retain) NSMutableDictionary *validRows;


@property(nonatomic, retain) NSMutableArray *pvMapSkuList;
@property(nonatomic, retain) NSMutableDictionary *pvMap;
@property(nonatomic, retain) NSMutableDictionary *pvSkuIdMap;
@property(nonatomic, retain) NSMutableArray *skuPriceList;
@property(nonatomic, retain) NSMutableDictionary *skuPriceMap;
@property(nonatomic, retain) NSMutableDictionary *skuQuantityMap;


@property(nonatomic, copy) BOOL (^addBtnCB)(NSInteger num);
@property(nonatomic, copy) BOOL (^reduceCB)(NSInteger num);
@end

@implementation ItemDetailBuyArea

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _upperLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_BORDERWIDTH)];
        _upperLine.backgroundColor = BUY_AREA_BUYNOW_BORDER_COLOR;
        _upperLine.alpha = 0.25;
        _numNow = 1;
        _numMax = -1;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:_upperLine];
        _seletedRows = [[NSMutableDictionary alloc] init];
        _validRows = [[NSMutableDictionary alloc] init];

        __block ItemDetailBuyArea *selfBlockRef = self;
        _reduceCB = ^(NSInteger num) {
            if (num < 0) {return NO;}
            selfBlockRef.numNow = num;
            return YES;
        };
        _addBtnCB = ^(NSInteger num) {
            if (num < 0) {
                return NO;
            }
            if (selfBlockRef.numMax > 0 && num > selfBlockRef.numMax) {
                return NO;
            }
            selfBlockRef.numNow = num;
            return YES;
        };

    }
    return self;
}

- (void)setAreaStaus:(ItemDetailBuyAreaStaus)areaStaus {


    _areaStaus = areaStaus;
    if (_areaStaus == ItemDetailBuyAreaHide) {
        [self showBuyNow];
        [_skuArea removeFromSuperview];
    } else {
        if (_buyNow) {
            [_buyNow removeFromSuperview];
        }

        if (_baichuanData) {
            if (_skuArea) {
                [_skuArea removeFromSuperview];
            }
            _skuArea = [[UIView alloc] initWithFrame:CGRectZero];
            _viewHeight = 0;

            _skuItemInfoView = [UIView viewFromNibWithFileName:@"SKUView" class:[SkuItemInfoView class] index:0];
            _skuItemInfoView.mainImageUrl = [[[_baichuanData objectForKey:@"itemInfo"] objectForKey:@"pics"] objectAtIndex:0];
            _itemTitle = [[_baichuanData objectForKey:@"itemInfo"] valueForKey:@"title"];
            _skuItemInfoView.title = _itemTitle;
            id priceInfo = [[_baichuanData objectForKey:@"priceInfo"] objectForKey:@"itemPrice"];
            _skuItemInfoView.price = [[[[_baichuanData objectForKey:@"priceInfo"] objectForKey:@"itemPrice"] objectForKey:@"price"] valueForKey:@"price"];

            _skuItemInfoView.price = [priceInfo objectForKey:@"promotionPrice"] ? [[priceInfo objectForKey:@"promotionPrice"] valueForKey:@"price"] : [[priceInfo objectForKey:@"price"] valueForKey:@"price"];
            _skuItemInfoView.isTmall = [[[_aitaobaoShop valueForKey:@"shopType"] uppercaseString] isEqualToString:@"B"];
            _skuItemInfoView.stock = [[_baichuanData objectForKey:@"stockInfo"] valueForKey:@"itemQuantity"];

            _skuItemInfoView.selected = @"颜色分类";

            float siivHeight = [_skuItemInfoView getHeight];
            [_skuArea addSubview:_skuItemInfoView];
//            _skuItemInfoView.frame
            NSMutableDictionary *viewsDictionary = [@{@"skuItemInfoView" : _skuItemInfoView} mutableCopy];
            NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"%@%f%@", @"V:|-0-[skuItemInfoView(", siivHeight, @")]"]
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:viewsDictionary];
            NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[skuItemInfoView]-0-|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:viewsDictionary];

            [_skuArea addConstraints:constraint_POS_V];
            [_skuArea addConstraints:constraint_POS_H];

            _viewHeight += siivHeight;

            [self setUpSkus];
            _skuProps = [[_baichuanData objectForKey:@"skuInfo"] objectForKey:@"skuProps"];


            if (_skuProps) {
                float skuPropsHeight = DEFAULT_SKU_LINE_HEIGHT1;
                if (_skuProps.count <= 2) {
                    skuPropsHeight = (_skuProps.count - 1) * DEFAULT_SKU_LINE_HEIGHT + DEFAULT_SKU_LINE_HEIGHT1;
                } else {
                    skuPropsHeight = DEFAULT_SKU_LINE_HEIGHT + DEFAULT_SKU_LINE_HEIGHT1;
                }


                UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
                layout.headerReferenceSize = CGSizeMake(self.frame.size.width, DEFAULT_SKU_HEADER_HEIGHT);
                layout.footerReferenceSize = CGSizeMake(self.frame.size.width, DEFAULT_SKU_FOOTER_HEIGHT);


                _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
                _collectionView.delegate = self;
//                _collectionView.dele
                _collectionView.dataSource = self;
                [_collectionView registerClass:[SkusCell class] forCellWithReuseIdentifier:@"SkusCell"];
                [_collectionView registerClass:[SkusHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SkusHeader"];
                [_collectionView registerClass:[SkusFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SkusFooter"];
                [_collectionView registerClass:[SkuViewFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SkuViewFooter"];
                [_skuArea addSubview:_collectionView];
                _collectionView.backgroundColor = [UIColor clearColor];
                _collectionView.translatesAutoresizingMaskIntoConstraints = NO;

                _viewHeight += skuPropsHeight;
                [viewsDictionary setObject:_collectionView forKey:@"collectionView"];
                NSArray *constraint_POS_HForCV = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:viewsDictionary];
                NSArray *constraint_POS_HForCV_V = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"%@%f%@", @"V:|-0-[skuItemInfoView]-0-[collectionView(", skuPropsHeight, @")]"]
                                                                                           options:0
                                                                                           metrics:nil
                                                                                             views:viewsDictionary];


                [_skuArea addConstraints:constraint_POS_HForCV_V];
                [_skuArea addConstraints:constraint_POS_HForCV];


            }


            _footer = [UIView viewFromNibWithFileName:@"SKUView" class:[SkuViewConfirm class] index:5];
            [_skuArea addSubview:_footer];
            [_footer setUp];
              __block ItemDetailBuyArea *selfBlockRef = self;
            
            _footer.confirmBtnCB = ^{
                if (selfBlockRef.numNow > 0) {
                    if(selfBlockRef.skuProps && [selfBlockRef.skuProps count] > 0){
                        if(!selfBlockRef.skuIdNow) {
                            [selfBlockRef makeToast:@"请先选择颜色分类" duration:0.3f position:@"center"];
                            return;
                        }
                    }

                    if ([[TaeSession sharedInstance] isLogin]) {
                        TaeOrderItem *orderItem1 = [[TaeOrderItem alloc] init];
                        orderItem1.itemId = selfBlockRef.openiid;
                        orderItem1.skuId = selfBlockRef.skuIdNow;
                        orderItem1.quantity = [NSNumber numberWithInt:selfBlockRef.numNow];
                        NSLog(@"订单数据 itemId :%@ skuId : %@ quantity %@ %@", orderItem1.itemId, orderItem1.skuId, orderItem1.quantity, orderItem1 );
                        TaeWebViewUISettings *settings = [[TaeWebViewUISettings alloc] init];
                        settings.title = selfBlockRef.itemTitle;
                        settings.barTintColor = VIEW_THEME_COLOR;

                        settings.backButtonBackgroundImage = [UIImage imageNamed:@"top_back_btn"];
                        settings.titleBackgroundColor = [UIColor clearColor];
                        settings.titleColor = [UIColor whiteColor];

                        [[TaeSDK sharedInstance] showOrder:[selfBlockRef viewController]
                                                isNeedPush:NO
                                         webViewUISettings:settings
                                                orderItems:@[orderItem1]
                               tradeProcessSuccessCallback:^(TaeTradeProcessResult *tradeProcessResult) {
                                   [[selfBlockRef viewController] dismissViewControllerAnimated:YES completion:nil];
                               }
                         
                                tradeProcessFailedCallback:^(NSError *error) {
                                    NSLog(@"订单失败 %@", error);
                                      [[selfBlockRef viewController]dismissViewControllerAnimated:YES completion:nil];
                                }];

                    } else {
                        [[TaeSDK sharedInstance] showLogin:[selfBlockRef viewController] successCallback:nil failedCallback:nil];
                    }
                }else{
                    [selfBlockRef makeToast:@"请选择购买的数量" duration:0.3f position:@"center"];
                }

            };
            _footer.translatesAutoresizingMaskIntoConstraints = NO;
            float footHeight = [SkuViewConfirm getHeight];
            _viewHeight += footHeight;
            [viewsDictionary setObject:_footer forKey:@"SkuViewConfirm"];
            NSArray *constraint_POS_V_SVF = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"%@%f%@", @"V:[SkuViewConfirm(", footHeight, @")]-0-|"]
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:viewsDictionary];
            NSArray *constraint_POS_H_SVF = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[SkuViewConfirm]-0-|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:viewsDictionary];
            [_skuArea addConstraints:constraint_POS_V_SVF];
            [_skuArea addConstraints:constraint_POS_H_SVF];


            _skuArea.frame = CGRectMake(0, 0, SCREEN_WIDTH, _viewHeight);
            [self addSubview:_skuArea];
        }

    }


}

- (void)setUp {
//    if(_areaStaus ==ItemDetailBuyAreaHide){
//        [self showBuyNow];
//    }
}

- (void)showBuyNow {
    if (!_buyNow) {

        _buyNow = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - DEFAULT_SPACE - BUY_AREA_BUYNOW_BUTTON_WIDTH, (BUY_AREA_BUYNOW_BUTTON_AREA_HEIGHT - BUY_AREA_BUYNOW_BUTTON_HEIGHT) / 2, BUY_AREA_BUYNOW_BUTTON_WIDTH, BUY_AREA_BUYNOW_BUTTON_HEIGHT)];

        _buyNow.layer.cornerRadius = 2.5;
        [_buyNow setTitle:@"立即购买" forState:UIControlStateNormal];
        _buyNow.titleLabel.font = BUY_AREA_BUYNOW_FONT;
        [_buyNow setBackgroundColor:BUY_AREA_BUYNOW_BSCKGROUND_COLOR];
//        addTarget:self action:@selector(ClickControlAction:) forControlEvents:UIControlEventTouchUpInside
        [_buyNow addTarget:self action:@selector(buyNowClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    [self addSubview:_buyNow];
}

- (void)buyNowClick:(id)sender {
    [self setAreaStaus:ItemDetailBuyAreaShow];
    if (_buyNowButtonCB) {
        _buyNowButtonCB(_viewHeight);
    }


}

- (CGFloat)getHeight {
    if (_areaStaus == ItemDetailBuyAreaHide) {
        return BUY_AREA_BUYNOW_BUTTON_AREA_HEIGHT;
    } else {
        if (_baichuanData) {
            return _viewHeight;
        } else {
            return 0;
        }
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (_skuProps) {
        NSMutableArray *values = [self getValues:section];
        return values.count;
    }
    return 0;
}


- (NSMutableArray *)getValues:(NSInteger)section {
    return [[_skuProps objectAtIndex:section] objectForKey:@"values"];
}

#pragma mark -  获取indexpath对应的cell

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {


    UICollectionReusableView *reusableview = [collectionView dequeueReusableCellWithReuseIdentifier:@"SkusCell" forIndexPath:indexPath];

    if (reusableview == nil) {
        reusableview = [UIView viewFromNibWithFileName:@"SKUView" class:[SkusCell class] index:2];
    }
    NSMutableArray *values = [self getValues:indexPath.section];
    NSString *name = [[values objectAtIndex:indexPath.item] valueForKey:@"name"];
    SkusCell *cell = (SkusCell *) reusableview;
    [cell setTitle:name];
    if ([[_seletedRows objectForKey:[NSNumber numberWithInt:indexPath.section]] containsObject:indexPath]) {
        [cell setCellStaus:SKUCELLON];
    }
    else if ([_validRows objectForKey:[NSNumber numberWithInt:indexPath.section]]) {
        NSArray *array = [_validRows objectForKey:[NSNumber numberWithInt:indexPath.section]];
        if ([array count] > 0) {
            NSString *pv = [self getSkuPvWithIndexPath:indexPath];
            if ([array containsObject:pv]) {
                [cell setCellStaus:SKUCELLOFF];
            } else {
                [cell setCellStaus:SKUCELLDISABLE];
            }
        }
    }

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (_skuProps) {
        return _skuProps.count;
    }
    return 0;
}


#pragma mark - 获取header or footer

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {

        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SkusHeader" forIndexPath:indexPath];

        if (reusableview == nil) {
            reusableview = [UIView viewFromNibWithFileName:@"SKUView" class:[SkusHeader class] index:3];
        }
        NSString *title = [[_skuProps objectAtIndex:indexPath.section] objectForKey:@"propName"];
        SkusHeader *header = (SkusHeader *) reusableview;
        header.titleLable.text = title;
        return reusableview;
    }
    else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *reusableview;
        if (_skuProps) {
            if (indexPath.section == (_skuProps.count - 1)) {
                reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SkuViewFooter" forIndexPath:indexPath];
                SkuViewFooter *skuViewFooter = (SkuViewFooter *) reusableview;
                skuViewFooter.reduceBtnCB = _reduceCB;
                skuViewFooter.addBtnCB = _addBtnCB;
                skuViewFooter.numLabel.text = [NSString stringWithFormat:@"%d", _numNow];
                [skuViewFooter setUp];
            } else {
                reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SkusFooter" forIndexPath:indexPath];

            }
            return reusableview;
        }
    }
    return nil;
}

#pragma mark - 这里是cell的点击事件

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

//    NSMutableArray *values = [self getValues:indexPath.section];
    //   NSLog(@"item -%d row -%d section-%d \n data - %@", indexPath.item, indexPath.row, indexPath.section, _skuProps);
    NSNumber *sectionKey = [NSNumber numberWithInt:indexPath.section];


    if ([_validRows objectForKey:[NSNumber numberWithInt:indexPath.section]]) {
        NSArray *array = [_validRows objectForKey:[NSNumber numberWithInt:indexPath.section]];
        NSString *pv = [self getSkuPvWithIndexPath:indexPath];
        if (![array containsObject:pv]) {
            return;
        }
    }

    if (![_seletedRows objectForKey:sectionKey]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:indexPath];
        [_seletedRows setObject:array forKey:sectionKey];
    } else {
        NSMutableArray *array = [_seletedRows objectForKey:sectionKey];
        [array removeAllObjects];
        [array addObject:indexPath];
    }

//    NSString *seletedName = @"";
    NSString *pvPath = @"";
//    _skuItemInfoView.selected = seletedName;
    for (NSMutableArray *array in _seletedRows.allValues) {
        if (array && ([array isKindOfClass:[NSMutableArray class]] || [array isKindOfClass:[NSArray class]])) {
            for (NSIndexPath *indexPath in array) {
              //  NSMutableArray *values = [self getValues:indexPath.section];
//                seletedName = [NSString stringWithFormat:@"%@%@%@%@", seletedName, @"\"", [[values objectAtIndex:indexPath.item] valueForKey:@"name"], @"\""];

                NSString *sPv = [self getSkuPvWithIndexPath:indexPath];

                pvPath = [NSString stringWithFormat:@"%@%@%@", pvPath, [pvPath isEqualToString:@""] ? @"" : @";", sPv];
            }
        }
    }
    NSLog(@"pv path %@", pvPath);
    if (_skuPriceList && _pvSkuIdMap) {
        NSString *skuId = [_pvSkuIdMap valueForKey:pvPath];
        if (skuId) {
            _skuIdNow = skuId;
            id item = [_skuPriceMap objectForKey:skuId];
            if (item) {
                _skuItemInfoView.price = [item objectForKey:@"promotionPrice"] ? [[item objectForKey:@"promotionPrice"] valueForKey:@"price"] : [[item objectForKey:@"price"] valueForKey:@"price"];
            }

            NSString *quantity = [_skuQuantityMap objectForKey:skuId];
            if (quantity) {
                _numMax = [quantity intValue];
                if (_numNow > _numMax) {
                    _numNow = _numMax;
                }
                _skuItemInfoView.stock = quantity;
            }

        }
    } else {
        id priceInfo = [[_baichuanData objectForKey:@"priceInfo"] objectForKey:@"itemPrice"];
        _skuItemInfoView.price = [priceInfo objectForKey:@"promotionPrice"] ? [[priceInfo objectForKey:@"promotionPrice"] valueForKey:@"price"] : [[priceInfo objectForKey:@"price"] valueForKey:@"price"];
    }


    if (_pvMapSkuList && [_skuProps count] > 1) {
        NSString *pv = [self getSkuPvWithIndexPath:indexPath];
        if (indexPath.section == 0) {
            [_validRows setObject:[[_pvMap objectForKey:@0] objectForKey:pv] forKey:@1];
        } else {
            [_validRows setObject:[[_pvMap objectForKey:@1] objectForKey:pv] forKey:@0];
        }
    }

//    _skuItemInfoView.selected = seletedName;
    [_collectionView reloadData];
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets result = UIEdgeInsetsMake(DEFAULT_SPACE, DEFAULT_SPACE, DEFAULT_SPACE, DEFAULT_SPACE);
    return result;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *values = [self getValues:indexPath.section];
    NSString *name = [[values objectAtIndex:indexPath.item] valueForKey:@"name"];
    float stringWidth = DEFAULT_SKU_CELL_WIDTH;
    if ([name length] > 2) {

        float tmpWidth = [name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) withTextFont:[UIFont systemFontOfSize:12] withLineSpacing:0].width;
        tmpWidth += 2 * DEFAULT_SPACE;
        if (tmpWidth > stringWidth) {
            stringWidth = tmpWidth;
        }

    }
    return CGSizeMake(stringWidth, DEFAULT_SKU_CELL_HEIGHT);
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return DEFAULT_SPACE;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (_skuProps) {
        return CGSizeMake(self.frame.size.width, DEFAULT_SKU_HEADER_HEIGHT);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (_skuProps) {
        if (section == (_skuProps.count - 1))
            return CGSizeMake(self.frame.size.width, OTHER_SKU_FOOTER_HEIGHT);
        else
            return CGSizeMake(self.frame.size.width, DEFAULT_SKU_FOOTER_HEIGHT);
    }
    return CGSizeZero;
}


#pragma mark -  获取某个indexpath的sku pv值

- (NSString *)getSkuPvWithIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *values = [self getValues:indexPath.section];
    NSString *propId = [[_skuProps objectAtIndex:indexPath.section] valueForKey:@"propId"];
    NSDictionary *item = [values objectAtIndex:indexPath.item];
    NSString *pv = [NSString stringWithFormat:@"%@%@%@", propId, @":", [item valueForKey:@"valueId"]];
    return pv;

}


#pragma mark -  setup sku相关信息

- (void)setUpSkus {
    _openiid = [_itemFullData valueForKey:@"openiid"];

    _pvMapSkuList = [[_baichuanData objectForKey:@"skuInfo"] objectForKey:@"pvMapSkuList"];
    _skuPriceList = [[_baichuanData objectForKey:@"priceInfo"] objectForKey:@"skuPriceList"];

    if (_skuPriceList) {
        _skuPriceMap = [[NSMutableDictionary alloc] init];
        for (id item in _skuPriceList) {

            NSString *skuId = [item valueForKey:@"skuId"];
            [_skuPriceMap setObject:item forKey:skuId];
        }
    }

    if (_pvMapSkuList) {
        _pvMap = [[NSMutableDictionary alloc] init];
        _pvSkuIdMap = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *pvMapSub0 = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *pvMapSub1 = [[NSMutableDictionary alloc] init];
        [_pvMap setObject:pvMapSub0 forKey:@0];
        [_pvMap setObject:pvMapSub1 forKey:@1];

        for (id item in _pvMapSkuList) {
            NSString *pv = [item valueForKey:@"pv"];
            NSString *skuId = [item valueForKey:@"skuId"];

            [_pvSkuIdMap setObject:skuId forKey:pv];
            NSArray *array = [pv componentsSeparatedByString:@";"];
            NSString *key = [array objectAtIndex:0];
            NSString *value = [array objectAtIndex:1];
            if ([pvMapSub0 objectForKey:key]) {
                NSMutableArray *array1 = [pvMapSub0 objectForKey:key];
                [array1 addObject:value];
                [pvMapSub0 setObject:array1 forKey:key];
            } else {
                NSMutableArray *array1 = [[NSMutableArray alloc] init];
                [array1 addObject:value];
                [pvMapSub0 setObject:array1 forKey:key];
            }

            if ([pvMapSub1 objectForKey:value]) {
                NSMutableArray *array1 = [pvMapSub1 objectForKey:value];
                [array1 addObject:key];
                [pvMapSub1 setObject:array1 forKey:value];
            } else {
                NSMutableArray *array1 = [[NSMutableArray alloc] init];
                [array1 addObject:key];
                [pvMapSub1 setObject:array1 forKey:value];
            }
        }
    }


    NSMutableArray *skuQList = [[_baichuanData objectForKey:@"stockInfo"] objectForKey:@"skuQuantityList"];
    if (skuQList) {
        _skuQuantityMap = [[NSMutableDictionary alloc] init];
        for (id item in skuQList) {
            [_skuQuantityMap setObject:[item valueForKey:@"quantity"] forKey:[item valueForKey:@"skuId"]];
        }


    }

}


@end
