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
    
    
    return [[BaseNetworkEngine sharedInstance] postRequestUrlPath:@"/v1.0/passport/signin" dictParams:mutDict successBlock:^(NSDictionary *dictRet) {
        successBlock(dictRet);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    }];
}

@end
