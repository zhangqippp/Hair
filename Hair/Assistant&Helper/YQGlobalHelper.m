//
//  SPGlobal.m
//  Activity
//
//  Created by yewei on 14-4-30.
//  Copyright (c) 2014年 yewei. All rights reserved.
//

#import "YQGlobalHelper.h"
//#import "RegexKitLite.h"

@implementation YQGlobalHelper

//// 判断是否为手机号
//+ (BOOL)isPhoneNumberFormat:(NSString *)accountStr {
//    BOOL ret = NO;
//    if(accountStr.length != 0) {
//        ret = [accountStr isMatchedByRegex:@"\\b([01][0-9]{10})\\b"] || [accountStr isMatchedByRegex:@"\\b([0-9]{7,8})\\b"];
//    } else {
//        ret = NO;
//    }
//    
//    NSLog(@"%i", ret);
//    
//    return ret;
//}
//
//// 正则判断手机号码地址格式
//+ (BOOL)isMobileNumber:(NSString *)mobileNum
//{
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
//    
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES)
//        || ([regextestphs evaluateWithObject:mobileNum] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}
//
//
//// 判断是否为邮箱
//+ (BOOL)isEmailFormat:(NSString *)accountStr {
//    BOOL ret;
//    if(accountStr.length != 0) {
//        ret = [accountStr isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"];
//    } else {
//        ret = NO;
//    }
//    return ret;
//}
//
//// 判断是否为6位数字
//+ (BOOL)isVerifyCodeFormat:(NSString *)codeStr {
//    BOOL ret;
//    if(codeStr.length != 0) {
//        ret = [codeStr isMatchedByRegex:@"\\b([0-9]{6})\\b"];
//    } else {
//        ret = NO;
//    }
//    return ret;
//}
//
//// 判断是否为密码格式
//+ (BOOL)isCorrectPasswordFormat:(NSString *)pwdStr {
//    BOOL ret;
//    if(pwdStr.length != 0) {
//        ret = [pwdStr isMatchedByRegex:@"\\b([a-zA-Z0-9]{6,16})\\b"];
//    } else {
//        ret = NO;
//    }
//    return ret;
//}
//
//// 判断是否为空或者空格字符串
//+ (BOOL)isBlankString:(NSString *)string
//{
//    if (string == nil) {
//        return YES;
//    }
//    
//    if (string == NULL) {
//        return YES;
//    }
//    
//    if ([string isKindOfClass:[NSNull class]]) {
//        return YES;
//    }
//    
//    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
//        return YES;
//    }
//    
//    return NO;
//}

+ (UIImage*)createBackgroundImageWithImageName:(NSString*)imageName edgeInsets:(UIEdgeInsets)insets{
    UIImage *image = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0) {
        image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:insets.left topCapHeight:insets.top];
    } else {
        image = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:insets];
    }
    return image;
}

//取消UITableView多余的分割线
+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//  是否可以拨打电话
+ (BOOL)canMakePhoneCalls
{
//    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    return YES;
}

@end
