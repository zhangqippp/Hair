//
//  HairStyleModel.m
//  Hair
//
//  Created by yewei on 15/2/2.
//  Copyright (c) 2015年 zhphy. All rights reserved.
//

#import "HairStyleModel.h"
#import "NSDictionary+Ext.h"

@implementation HairStyleModel

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.hairId = [dict stringForKey:@"id" withDefault:@""];
        self.parentId = [dict stringForKey:@"parentid" withDefault:@""];
        self.subId = [dict stringForKey:@"subid" withDefault:@""];
        self.filePath = [dict stringForKey:@"file" withDefault:@""];
        self.mtFilePath = [dict stringForKey:@"mtfile" withDefault:@""];
        self.title = [dict stringForKey:@"title" withDefault:@""];
        self.utime = [dict stringForKey:@"utime" withDefault:@""];
        self.handleType = [dict intForKey:@"del" withDefault:0];
    }
    return self;
}

@end
