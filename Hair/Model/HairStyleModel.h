//
//  HairStyleModel.h
//  Hair
//
//  Created by yewei on 15/2/2.
//  Copyright (c) 2015年 zhphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLitePersistentObject.h"

typedef NS_ENUM(NSInteger, HandleType)
{
    HandleTypeDelete = 0,
    HandleTypeAdd = 1
};

@interface HairStyleModel : SQLitePersistentObject

@property (nonatomic, strong) NSString *hairId;
@property (nonatomic, assign) NSInteger parentId;
@property (nonatomic, assign) NSInteger subId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *tagsTitle;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *mtFilePath;
@property (nonatomic, strong) NSString *utime;
@property (nonatomic, assign) HandleType handleType;

- (id)initWithDict:(NSDictionary *)dict;

@end
