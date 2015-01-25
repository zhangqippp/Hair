//
//  HairService.h
//  Hair
//
//  Created by yewei on 15/1/25.
//  Copyright (c) 2015年 zhphy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HairService : NSObject

+ (NetService *)loginWithPhoneNum:(NSString *)phoneNum
                         password:(NSString *)password
                     successBlock:(YQRequestSuccess)successBlock
                     failureBlock:(YQRequestFailuer)failureBlock;

@end
