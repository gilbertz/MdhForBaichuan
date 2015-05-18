//
//  SkusCell.h
//  demo
//
//  Created by huamulou on 14-9-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    SKUCELLON = 0,
    SKUCELLOFF,
    SKUCELLDISABLE
} SkusCellStaus;

@interface SkusCell : UICollectionViewCell

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) IBOutlet UILabel *btnTitle;


@property(nonatomic, assign) SkusCellStaus cellStaus;

- (void)on;

- (void)off;
@end
