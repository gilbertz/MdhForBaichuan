//
// Created by huamulou on 14-9-5.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface URLUtil : NSObject


+ (NSString *)getURLWithParms:(NSDictionary *)parms withPath: (NSString *) path ;

+ (NSDictionary *)getParms:(NSDictionary *)parms;
@end