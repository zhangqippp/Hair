//
//  SPGlobal.h
//  Activity
//
//  Created by yewei on 14-4-30.
//  Copyright (c) 2014年 yewei. All rights reserved.
//

#import <Foundation/Foundation.h>

//单实例
#define SYNTHESIZE_SINGLETON_FOR_HEADER(classname)\
+ (classname *)shared##classname;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[super allocWithZone:NULL] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
return [self shared##classname];\
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// iPad
#define kIsiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// UIImage STRETCH
#define STRETCH_IMAGE(image, edgeInsets) (CURRENT_SYS_VERSION < 6.0 ? [image stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top] : [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch])

//用此键值从返回结果的dict中获取网络请求对应的yqNetworkIdString, 表示当前发送的网络请求的唯一标示
#define KYQNetworkIdString  @"KYQNetworkIdString"

//网络请求底层失败的原因
#define KYQNetworkErrorMsg  @"KYQNetworkErrorMsg"

//通知键值定义
#define YQNotification_Key_Tabbar_Toggle @"YQNotification_Key_Tabbar_Toggle"
#define YQNotification_Key_Application_BecomeActive @"YQNotification_Key_Application_BecomeActive"  //应用从后台切到前台激活
#define YQNotification_Key_Receive_PrivateMessage @"YQNotification_Key_Receive_PrivateMessage"      //收到私聊
#define YQNotification_Key_Receive_GroupMessage @"YQNotification_Key_Receive_GroupMessage"          //收到群聊
#define YQNotification_Key_LocalContacts_Update @"YQNotification_Key_LocalContacts_Update"          //本地通讯录更新完成
#define YQNotification_Key_NumberOfSelectedContacts @"YQNotification_Key_NumberOfSelectedContacts"  //更新选中的联系人数量

//应用打开次数
#define appOpenCount @"appOpenCount"

#define STRUCT_REFRESH_TIME @"STRUCT_REFRESH_TIME"
#define STRUCT_DATA         @"STRUCT_DATA"

#define STYLE_REFRESH_TIME  @"STYLE_REFRESH_TIME"
#define STYLE_DATA          @"STYLE_DATA"

@interface YQGlobalHelper : NSObject

// 判断是否为手机号
+ (BOOL)isPhoneNumberFormat:(NSString *)accountStr;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
// 判断是否为邮箱
+ (BOOL)isEmailFormat:(NSString *)accountStr;
// 判断是否为6位数字
+ (BOOL)isVerifyCodeFormat:(NSString *)codeStr;
// 判断是否为密码格式  6-16位数字、字母组合
+ (BOOL)isCorrectPasswordFormat:(NSString *)pwdStr;
// 判断是否为空或者空格字符串
+ (BOOL)isBlankString:(NSString *)string;

//取消UITableView多余的分割线
+ (void)setExtraCellLineHidden: (UITableView *)tableView;

+ (UIImage*)createBackgroundImageWithImageName:(NSString*)imageName edgeInsets:(UIEdgeInsets)insets;

//  是否可以拨打电话
+ (BOOL)canMakePhoneCalls;

@end
