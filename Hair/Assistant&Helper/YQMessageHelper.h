//
//  XHMessageHelper.h
//  XHNews
//
//  Created by yewei on 14-1-3.
//  Copyright (c) 2014年 yewei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQMessageHelper : NSObject

#pragma - wrapper of MBProgressHUD that will disable interaction with app
+ (void)showHUDMessage:(NSString *)message;
+ (void)showHUDMessage:(NSString *)message detail:(NSString *)detail;
+ (void)showHUDImage:(NSString *)imageName;
+ (void)showHudMessage:(NSString *)message image:(NSString *)imageName;
+ (void)showHudMessage:(NSString *)message detail:(NSString *)detail image:(NSString *)imageName;

+ (void)showHUDActivity:(UIView *)parentView;
+ (void)showHUDActivity:(NSString *)message parentView:(UIView *)parentView;
+ (void)hideHUDActivity:(UIView *)parentView;
+ (void)hideHUDActivityWithoutAnimation:(UIView *)parentView;

#pragma - creates a view and displays it as toast
+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message duration:(CGFloat)interval position:(id)position;
+ (void)showMessage:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title;
+ (void)showMessage:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title image:(UIImage *)image;
+ (void)showMessage:(NSString *)message duration:(CGFloat)interval position:(id)position image:(UIImage *)image;

#pragma - displays toast with an activity spinner
+ (void)showActivity;
+ (void)showActivity:(id)position;
+ (void)hideActivity;

#pragma - the showView methods display any view as toast
+ (void)showView:(UIView *)toast;
+ (void)showView:(UIView *)toast duration:(CGFloat)interval position:(id)point;

#pragma - simple alert view
+ (void)showAlert:(NSString *)message title:(NSString *)title;
+ (void)showAlert:(NSString *)message title:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle cancelButtonBlock:(void (^)())block;
+ (void)showAlert:(NSString *)message title:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle cancelButtonBlock:(void (^)())cancelBlock okButtonTitle:(NSString *)okTitle okButtonBlock:(void (^)())okBlock;

#pragma - 获取当前应用的顶级窗口
+ (UIWindow *)getTopWindow;

@end