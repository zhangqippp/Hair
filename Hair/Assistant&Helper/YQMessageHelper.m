//
//  YFMessageHelper.m
//  SPNews
//
//  Created by yewei on 14-1-3.
//  Copyright (c) 2014年 yewei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YQMessageHelper.h"
#import "BlockAlertView.h"
#import "Toast+UIView.h"
#import "MBProgressHUD.h"


@implementation YQMessageHelper

+ (UIWindow *)getTopWindow
{
    for (int i = 0; i < [UIApplication sharedApplication].windows.count; ++i) {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:i];
        if([[window description]hasPrefix:@"<UITextEffectsWindow"]) {
            return window;
        }
    }
    if (![UIApplication sharedApplication].keyWindow) {
        return [[UIApplication sharedApplication].delegate window];
    }
    return [UIApplication sharedApplication].keyWindow;
}

#pragma - creates a view and displays it as toast
+ (void)showMessage:(NSString *)message
{
    [[YQMessageHelper getTopWindow] makeToast:message];
}

+ (void)showMessage:(NSString *)message
           duration:(CGFloat)interval
           position:(id)position
{
    [[YQMessageHelper getTopWindow] makeToast:message
                                     duration:interval
                                     position:position];
}

+ (void)showMessage:(NSString *)message
           duration:(CGFloat)interval
           position:(id)position
              title:(NSString *)title
{
    [[YQMessageHelper getTopWindow] makeToast:message
                                     duration:interval
                                     position:position
                                        title:title];
}

+ (void)showMessage:(NSString *)message
           duration:(CGFloat)interval
           position:(id)position
              title:(NSString *)title
              image:(UIImage *)image
{
    [[YQMessageHelper getTopWindow] makeToast:message
                                     duration:interval
                                     position:position
                                        title:title
                                        image:image];
}

+ (void)showMessage:(NSString *)message
           duration:(CGFloat)interval
           position:(id)position
              image:(UIImage *)image
{
    [[YQMessageHelper getTopWindow] makeToast:message
                                     duration:interval
                                     position:position
                                        image:image];
}

#pragma - displays toast with an activity spinner
+ (void)showActivity
{
    [[YQMessageHelper getTopWindow] makeToastActivity];
}

+ (void)showActivity:(id)position
{
    [[YQMessageHelper getTopWindow] makeToastActivity:position];
}

+ (void)hideActivity
{
    [[YQMessageHelper getTopWindow] hideToastActivity];
}

#pragma - the showView methods display any view as toast
+ (void)showView:(UIView *)toast
{
    [[YQMessageHelper getTopWindow] showToast:toast];
}

+ (void)showView:(UIView *)toast
        duration:(CGFloat)interval
        position:(id)point
{
    [[YQMessageHelper getTopWindow] showToast:toast
                                     duration:interval
                                     position:point];
}

#pragma - simple alert view
+ (void)showAlert:(NSString *)message title:(NSString *)title
{
    [BlockAlertView showInfoAlertWithTitle:title message:message];
}

+ (void)showAlert:(NSString *)message title:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle cancelButtonBlock:(void (^)())block
{
    BlockAlertView *alertView = [BlockAlertView alertWithTitle:title message:message];
    [alertView setCancelButtonWithTitle:cancelTitle block:block];
    [alertView show];
}

+ (void)showAlert:(NSString *)message title:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle cancelButtonBlock:(void (^)())cancelBlock okButtonTitle:(NSString *)okTitle okButtonBlock:(void (^)())okBlock
{
    BlockAlertView *alertView = [BlockAlertView alertWithTitle:title message:message];
    [alertView setCancelButtonWithTitle:cancelTitle block:cancelBlock];
    [alertView setDestructiveButtonWithTitle:okTitle block:okBlock];
    [alertView show];
}

#pragma - wrapper of MBProgressHUD that will disable interaction with app
+ (void)showHUDMessage:(NSString *)message
{
    UIWindow *window = [YQMessageHelper getTopWindow];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:window];
    [window addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = message;
    hud.mode = MBProgressHUDModeText;
    [hud showWhileExecuting:@selector(delayTask) onTarget:self withObject:nil animated:YES];
}

+ (void)showHUDMessage:(NSString *)message detail:(NSString *)detail
{
    UIWindow *window = [YQMessageHelper getTopWindow];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:window];
    [window addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = message;
    hud.detailsLabelText = detail;
    hud.mode = MBProgressHUDModeText;
    [hud showWhileExecuting:@selector(delayTask) onTarget:self withObject:nil animated:YES];
}

+ (void)showHUDImage:(NSString *)imageName
{
    UIWindow *window = [YQMessageHelper getTopWindow];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:window];
    [window addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    [hud showWhileExecuting:@selector(delayTask) onTarget:self withObject:nil animated:YES];
}

+ (void)showHudMessage:(NSString *)message image:(NSString *)imageName
{
    UIWindow *window = [YQMessageHelper getTopWindow];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:window];
    [window addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = message;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    [hud showWhileExecuting:@selector(delayTask) onTarget:self withObject:nil animated:YES];
}

+ (void)showHudMessage:(NSString *)message detail:(NSString *)detail image:(NSString *)imageName
{
    UIWindow *window = [YQMessageHelper getTopWindow];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:window];
    [window addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = message;
    hud.detailsLabelText = detail;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    [hud showWhileExecuting:@selector(delayTask) onTarget:self withObject:nil animated:YES];
}

+ (void)delayTask
{
    [NSThread sleepForTimeInterval:2.0];
}

+ (void)showHUDActivity:(UIView *)parentView
{
    UIView *window = (parentView == nil ? [YQMessageHelper getTopWindow] : parentView);
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:window];
    [window addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
}

+ (void)showHUDActivity:(NSString *)message parentView:(UIView *)parentView
{
    UIView *window = (parentView == nil ? [YQMessageHelper getTopWindow] : parentView);
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:window];
    [window addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = message;
    [hud show:YES];
}
+ (void)hideHUDActivityWithoutAnimation:(UIView *)parentView{
    UIView *window = (parentView == nil ? [YQMessageHelper getTopWindow] : parentView);
    [MBProgressHUD hideAllHUDsForView:window animated:NO];
}
+ (void)hideHUDActivity:(UIView *)parentView
{
    UIView *window = (parentView == nil ? [YQMessageHelper getTopWindow] : parentView);
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
}

@end
