//
//  HairStyleDao.h
//  Hair
//
//  Created by yewei on 15/2/11.
//  Copyright (c) 2015年 zhphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HairStyleModel.h"

@interface HairStyleDao : NSObject

+ (NSMutableArray *)getAllHairStyles;

+ (NSMutableArray *)getDuplicateHairStyles;

+ (void)clearAllHairStyles;

+ (NSMutableArray *)getFilterHairStylesWithParentId:(NSString *)parentId subId:(NSString *)subId;


@end
