//
//  NDateCell.h
//  demo
//
//  Created by huamulou on 14-9-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Npin.h"

@interface NDateCell : UICollectionViewCell<NCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UILabel *dayLabel;





@end
