//
// Created by huamulou on 14-9-11.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CategoryCell : UICollectionViewCell

@property(weak,nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic)IBOutlet UIView *seletedView;


@property (nonatomic, retain)NSString *name;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, retain)NSString *pic;
@property (weak, nonatomic) IBOutlet UIView *downLine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;
@property (nonatomic, assign)NSInteger sequence;

-(void)addDownLine;

-(void)removeDownLine;

-(void)onSelect ;

-(void)offSelect;
@end