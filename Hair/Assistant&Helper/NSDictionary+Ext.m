//
//  NSDictionary+Ext.m
//  新华炫闻
//
//  Created by yewei on 14-3-5.
//  Copyright (c) 2014年 yewei. All rights reserved.
//

#import "NSDictionary+Ext.h"

@implementation NSDictionary (Ext)

-(NSString *)stringForKey:(NSString *)key withDefault:(NSString *)defVal{
    
    return ([self objectForKey:key] != nil && ![[self objectForKey:key] isEqual:[NSNull null]] && [[self objectForKey:key] isKindOfClass:[NSString class]])? [self objectForKey:key] : defVal;
}

-(NSDictionary *)dictForKey:(NSString *)key withDefault:(NSDictionary *)defVal
{
    return ([self objectForKey:key] != nil && [[self objectForKey:key] isKindOfClass:[NSDictionary class]])? [self objectForKey:key] : defVal;
}

-(NSArray *)arrayForKey:(NSString *)key withDefault:(NSArray *)defVal
{
    return ([self objectForKey:key] != nil && [[self objectForKey:key] isKindOfClass:[NSArray class]])? [self objectForKey:key] : defVal;
}

-(CGFloat)floatForKey:(NSString *)key withDefault:(CGFloat)defVal{
    @try {
        return [[self objectForKey:key] floatValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}

-(NSTimeInterval)timeIntervalForKey:(NSString *)key withDefault:(NSTimeInterval)defVal{
    @try {
        return [[self objectForKey:key] doubleValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}

-(NSInteger)intForKey:(NSString *)key withDefault:(NSInteger)defVal{
    @try {
        return [[self objectForKey:key] intValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}

-(long long)longLongForKey:(NSString *)key withDefault:(long long)defVal{
    @try {
        return [[self objectForKey:key] longLongValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}

-(long)longForKey:(NSString *)key withDefault:(long)defVal{
    @try {
        return [[self objectForKey:key] longValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}

-(int)intValueForKey:(NSString *)key withDefault:(int)defVal{
    @try {
        return [[self objectForKey:key] intValue];
    }
    @catch (NSException *exception) {
        return defVal;
    }
}



@end
