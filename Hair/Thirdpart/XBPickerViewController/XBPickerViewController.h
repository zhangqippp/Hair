//
//  XBDatePickerViewController.h
//  X-Team
//
//  Created by Ben on 14-8-28.
//  Copyright (c) 2014年 X-Team. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectionCompleteBlock)(NSInteger selectedIndex);

@interface XBPickerViewController : UIViewController

+ (XBPickerViewController *)pickerViewController;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSString *selectedTitle;
@property (nonatomic, copy) SelectionCompleteBlock selectionBlock;

/**
 *  显示PickerView
 *
 *  @param parentViewController 父视图控制器
 */
- (void)showInViewController:(UIViewController *)parentViewController;

@end
