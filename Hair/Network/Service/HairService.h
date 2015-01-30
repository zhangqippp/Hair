//
//  HairService.h
//  Hair
//
//  Created by yewei on 15/1/25.
//  Copyright (c) 2015年 zhphy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HairService : NSObject

/**
 *  发型列表
 *
 *  @param lastUpdateTime 最后更新时间，默认为0
 *  @param successBlock
 *  @param failureBlock
 *
 *  @return
 */
+ (NetService *)getHairListWithLastUpdateTime:(NSString *)lastUpdateTime
                                 successBlock:(YQRequestSuccess)successBlock
                                 failureBlock:(YQRequestFailuer)failureBlock;

/**
 *  上传合成之后的发型
 *
 *  @param successBlock
 *  @param failureBlock
 *
 *  @return
 */
+ (NetService *)uploadHairFileWithPath:(NSString *)filePath
                          successBlock:(YQRequestSuccess)successBlock
                          failureBlock:(YQRequestFailuer)failureBlock;

@end
