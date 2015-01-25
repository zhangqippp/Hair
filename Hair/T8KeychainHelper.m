//
//  T8KeychainHelper.m
//  Tinfinite
//
//  Created by yewei on 14/11/21.
//  Copyright (c) 2014年 Tinfinite. All rights reserved.
//

#import "T8KeychainHelper.h"
#import <Security/Security.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

static NSString * const kUUIDStringKey = @"com.tinfinite.ios";

@implementation T8KeychainHelper

+ (NSString *)UDID
{
    NSString *UUIDString = [NSString stringWithFormat:@"i_%@",[self dataForKey:kUUIDStringKey]];
    if (![self dataForKey:kUUIDStringKey]) {
        //ios5
        if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_6_0) {
            CFUUIDRef UUIDRef = CFUUIDCreate(kCFAllocatorDefault);
            CFStringRef UUIDSRef = CFUUIDCreateString(kCFAllocatorDefault, UUIDRef);
            UUIDString = [(NSString *)CFStringCreateCopy(kCFAllocatorDefault, UUIDSRef) autorelease];
            CFRelease(UUIDRef);
            CFRelease(UUIDSRef);
        } else {
            UUIDString = [UIDevice currentDevice].identifierForVendor.UUIDString;
        }
        [self saveData:UUIDString forKey:kUUIDStringKey];
    }
    
    return UUIDString;
}

+ (NSMutableDictionary *)keychainQueryDictForKey:(NSString *)key
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            //以密码的形式保存
            (id)kSecClassGenericPassword,(id)kSecClass,
            //账户名
            key, (id)kSecAttrAccount,
            //访问级别,一直可访问,并且用户备份时不进入备份
            (id)kSecAttrAccessibleAlwaysThisDeviceOnly,(id)kSecAttrAccessible,
            nil];
}

+ (void)saveData:(id)data forKey:(NSString *)key
{
    NSMutableDictionary *keychainQuery = [self keychainQueryDictForKey:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)dataForKey:(NSString *)key
{
    id returnValue = nil;
    NSMutableDictionary *keychainQuery = [self keychainQueryDictForKey:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData);
    if (status == noErr) {
        @try {
            returnValue = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)keyData];
        } @catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed: %@", key, exception);
            SecItemDelete((CFDictionaryRef)keychainQuery);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return returnValue;
}


@end
