//
//  MyViewTableCell.m
//  demo
//
//  Created by huamulou on 14-9-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "MyViewTableCell.h"
#import "UIView+nib.h"

@implementation MyViewTableCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
              self = [UIView viewFromNibWithFileName:@"SubViewsOfMyView" owner:self index:0];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [UIView viewFromNibWithFileName:@"SubViewsOfMyView" owner:self index:0];
    }

    return self;
}



@end
