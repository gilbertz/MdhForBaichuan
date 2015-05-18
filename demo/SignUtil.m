//
// Created by huamulou on 14-9-5.
// Copyright (c) 2014 alibaba. All rights reserved.
//

#import "SignUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "Constants.h"


@interface SignUtil () {

}


+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;
@end

@implementation SignUtil {

}
+ (NSString *)genSign:(NSDictionary *)parms {


    if (parms) {

        NSMutableArray *keyArray = [NSMutableArray arrayWithArray:[parms allKeys]];
        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:parms];
        BOOL flag = NO;
        for (id key in keyArray) {
            NSString *key_s = (NSString *) key;
            if ([key_s isEqualToString:HTTP_API_PARMS_APPKEY]) {
                flag = YES;
            }
        }
        [newDic removeObjectForKey:HTTP_API_PARMS_SIGN];
        if (!flag) {
            [newDic setObject:HTTP_API_APPKEY forKey:HTTP_API_PARMS_APPKEY];
        }
        NSArray *keySorted = [[newDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSString *str = @"";//TOP分配给用户的App Secret，方便的话自定义个宏。
        for (id key in keySorted) {
            str = [NSString stringWithFormat:@"%@%@%@", str, key, [newDic objectForKey:key]];
        }

        str = [[str stringByAppendingString:HTTP_API_PARMS_APPSECRET] stringByAppendingString:HTTP_API_APPSECRET];

        return [[self getMd5_32Bit_String:str] uppercaseString];
    }
    return nil;
}

+ (NSString *)getMd5_32Bit_String:(NSString *)srcString {
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];

    return result;
}

@end