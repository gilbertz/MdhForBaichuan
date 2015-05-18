//
//  PinDateCell.h
//  demo
//
//  Created by huamulou on 14-9-7.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "Constants.h"
#import "PSCollectionView.h"

//@interface PinDateCell : TMQuiltViewCell
//@interface PinDateCell : CellBase
@interface PinDateCell : PSCollectionViewCell


- (id)initWithLastUpdate:(NSDate *) lastUpdate;

@property (nonatomic, retain) NSDate *lastUpdate;
+ (CGFloat)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth;

@property (nonatomic, retain)UIView *contentView;
@end
