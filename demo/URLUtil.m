//
// Created by huamulou on 14-9-5.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import "URLUtil.h"
#import "SignUtil.h"
#import "Constants.h"


@implementation URLUtil {

}
+ (NSString *)getURLWithParms:(NSDictionary *)parms withPath:(NSString *)path {
    if (path) {
        NSMutableDictionary *newDic;
        if (parms) {
            newDic = [NSMutableDictionary dictionaryWithDictionary:parms];
        } else {
            newDic = [[NSMutableDictionary alloc] init];
        }
        NSString *url = [NSString stringWithFormat:@"%@", path];

        [newDic setObject:HTTP_API_APPKEY forKey:HTTP_API_PARMS_APPKEY];
        NSString *sign = [SignUtil genSign:newDic];
        [newDic setObject:sign forKey:HTTP_API_PARMS_SIGN];

        int i = 0;
        for (id key in [newDic allKeys]) {
            NSString *key_s = (NSString *) key;
            NSString *value;
            id valueId =  [newDic objectForKey:key];
            if([valueId isKindOfClass:[NSNumber class]]){
                value = [[NSString alloc] initWithFormat:@"%@", valueId];
            } else{
                value = [newDic valueForKey:key];
            }
            if (i == 0) {
                url = [url stringByAppendingString:@"?"];
            } else {
                url = [url stringByAppendingString:@"&"];
            }
            i++;
            url = [[[url stringByAppendingString:key_s] stringByAppendingString:@"="] stringByAppendingString:[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        return url;
    }
    return nil;

}

+ (NSDictionary *)getParms:(NSDictionary *)parms {
    NSMutableDictionary *newDic;
    if (parms) {
        newDic = [NSMutableDictionary dictionaryWithDictionary:parms];
    } else {
        newDic = [[NSMutableDictionary alloc] init];
    }
    [newDic setObject:HTTP_API_APPKEY forKey:HTTP_API_PARMS_APPKEY];
    NSString *sign = [SignUtil genSign:newDic];
    [newDic setObject:sign forKey:HTTP_API_PARMS_SIGN];


    return [NSDictionary dictionaryWithDictionary:newDic];


}

@end