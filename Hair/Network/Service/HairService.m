//
//  HairService.m
//  Hair
//
//  Created by yewei on 15/1/25.
//  Copyright (c) 2015年 zhphy. All rights reserved.
//

#import "HairService.h"

@implementation HairService

+ (NetService *)getTagListsuccessBlock:(YQRequestSuccess)successBlock
                          failureBlock:(YQRequestFailuer)failureBlock
{
    NSString *urlPath = @"/struct/index";
    
    NSString *lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:STRUCT_REFRESH_TIME];
    if (!lastUpdateTime) {
        lastUpdateTime = @"0";
    }
    
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    [muDict setObject:lastUpdateTime forKey:@"utime"];
    
    return [[BaseNetworkEngine sharedInstance] sendRequestUrlPath:urlPath dictParams:muDict successBlock:^(NSDictionary *dictRet) {
        successBlock(dictRet);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    }];
}

+ (NetService *)getHairListWithLastUpdateTime:(NSString *)lastUpdateTime
                                 successBlock:(YQRequestSuccess)successBlock
                                 failureBlock:(YQRequestFailuer)failureBlock
{
    NSString *urlPath = @"/style/list";
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    [muDict setObject:lastUpdateTime forKey:@"utime"];
    
    return [[BaseNetworkEngine sharedInstance] sendRequestUrlPath:urlPath dictParams:nil successBlock:^(NSDictionary *dictRet) {
        successBlock(dictRet);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    }];
}

+ (NetService *)uploadHairFileWithPath:(NSString *)filePath
                          successBlock:(YQRequestSuccess)successBlock
                          failureBlock:(YQRequestFailuer)failureBlock
{
    return [[BaseNetworkEngine sharedInstance] uploadFilefromPath:filePath forKey:@"upfile" strUrlPath:@"/upload/save" dictParams:nil successBlock:^(NSDictionary *dictRet) {
        successBlock(dictRet);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    } ];
}

@end
