//
//  CCTabBarItemModel.m
//  TabBarControllerModel
//
//  Created by wangtian on 14-6-25.
//  Copyright (c) 2014年 wangtian. All rights reserved.
//

#import "CCTabBarItemModel.h"

@implementation CCTabBarItemModel

- (CCTabBarItemModel *)initMALTabBarItemModelWithTitle:(NSString *)itemTitle itemImageName:(NSString *)itemImageName controllerName:(NSString *)controllerName selectedItemImageName:(NSString *)selectedItemImageName
{
    
    if (self = [super init]) {
        
        self.itemTitle = itemTitle;
        self.controllerName = controllerName;
        self.itemImageName = itemImageName;
        self.selectedItemImageName = selectedItemImageName;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@",self.controllerName, self.itemTitle, self.itemImageName];
}
@end
