//
//  HairStyleDao.m
//  Hair
//
//  Created by yewei on 15/2/11.
//  Copyright (c) 2015年 zhphy. All rights reserved.
//

#import "HairStyleDao.h"

@implementation HairStyleDao

+ (NSMutableArray *)getAllHairStyles
{
    return [[HairStyleModel allObjects] mutableCopy];
}

+ (void)clearAllHairStyles
{
    NSMutableArray *models = [self getAllHairStyles];
    for (HairStyleModel *model in models) {
        [model deleteObject];
    }
}

@end
