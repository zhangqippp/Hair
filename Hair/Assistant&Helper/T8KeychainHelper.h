//
//  T8KeychainHelper.h
//  Tinfinite
//
//  Created by yewei on 14/11/21.
//  Copyright (c) 2014年 Tinfinite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface T8KeychainHelper : NSObject

/*
 * 获取设备唯一标示符
 */
+ (NSString*)UDID;

/**
 *  向钥匙串中存储对象
 */
+ (void)saveData:(id)data forKey:(NSString *)key;

/**
 *  从钥匙串中读取对象
 */
+ (id)dataForKey:(NSString *)key;

@end
