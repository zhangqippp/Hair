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

+ (NSMutableArray *)getDuplicateHairStyles
{
    NSString *stringFormat = @"GROUP BY hair_id";
    NSArray *filters = [HairStyleModel findByCriteria:stringFormat];
    return [filters mutableCopy];
}

+ (void)clearAllHairStyles
{
    NSMutableArray *models = [self getAllHairStyles];
    for (HairStyleModel *model in models) {
        [model deleteObject];
    }
}

@end
