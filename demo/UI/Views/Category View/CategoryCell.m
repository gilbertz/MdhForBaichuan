//
// Created by huamulou on 14-9-11.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import "CategoryCell.h"
#import "Constants.h"


@implementation CategoryCell {

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CategoryCellView" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];

      //  _upperLine= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, VIEW_BORDERWIDTH)];
      //  _upperLine.backgroundColor

     //   _upperLine.backgroundColor = CATEGORY_FATHER_CELL_BORDER_COLOR;
      // _downLine= [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height -VIEW_BORDERWIDTH, self.frame.size.width, VIEW_BORDERWIDTH)];


    }
    return self;
}

-(void)onSelect{
   // _upperLine.frame = CGRectMake(CATEGORY_FATHER_CELL_SELECTED_WIDTH, 0, CATEGORY_FATHER_CELL_WIDTH, VIEW_BORDERWIDTH);
  //  _downLine.frame = CGRectMake(CATEGORY_FATHER_CELL_SELECTED_WIDTH, CATEGORY_FATHER_CELL_HEIGHT-VIEW_BORDERWIDTH, CATEGORY_FATHER_CELL_WIDTH, VIEW_BORDERWIDTH);
    _nameLabel.backgroundColor=[UIColor whiteColor];
    _seletedView.backgroundColor = VIEW_THEME_COLOR;
    _rightLine.backgroundColor = [UIColor whiteColor];
}

-(void)offSelect{
   // _upperLine.frame = CGRectMake(0, 0, CATEGORY_FATHER_CELL_WIDTH, VIEW_BORDERWIDTH);
  //  _downLine.frame = CGRectMake(0, CATEGORY_FATHER_CELL_HEIGHT-VIEW_BORDERWIDTH, CATEGORY_FATHER_CELL_WIDTH, VIEW_BORDERWIDTH);
    _nameLabel.backgroundColor=[UIColor clearColor];
    _seletedView.backgroundColor = [UIColor clearColor];
    _rightLine.backgroundColor = CATEGORY_FATHER_CELL_BORDER_COLOR;
}

-(void)addDownLine{
    _downLine.backgroundColor = CATEGORY_FATHER_CELL_BORDER_COLOR;
}

-(void)removeDownLine{
    _downLine.backgroundColor = [UIColor clearColor];
}
@end