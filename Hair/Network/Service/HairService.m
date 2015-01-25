//
//  HairService.m
//  Hair
//
//  Created by yewei on 15/1/25.
//  Copyright (c) 2015年 zhphy. All rights reserved.
//

#import "HairService.h"

@implementation HairService

+ (NetService *)loginWithPhoneNum:(NSString *)phoneNum
                         password:(NSString *)password
                     successBlock:(YQRequestSuccess)successBlock
                     failureBlock:(YQRequestFailuer)failureBlock
{
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
    [mutDict addObject:phoneNum forKey:@"phone"];
    [mutDict addObject:password forKey:@"password"];
    [mutDict addObject:@"ture" forKey:@"has_user_filters"];
    [mutDict addObject:@"ture" forKey:@"has_user_groups"];
    
    return [[BaseNetworkEngine sharedInstance] postRequestUrlPath:@"/v1.0/passport/signin" dictParams:mutDict successBlock:^(NSDictionary *dictRet) {
        successBlock(dictRet);
    } failureBlock:^(NSDictionary *dictRet, NSError *error) {
        failureBlock(dictRet,error);
    }];
}

@end
