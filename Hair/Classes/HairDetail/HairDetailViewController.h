//
//  HairDetailViewController.h
//  Hair
//
//  Created by 琦张 on 14/12/8.
//  Copyright (c) 2014年 zhphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HairDetailViewController : UIViewController

- (id)initWithDetailImage:(UIImage *)hairDetailImage andStyleImage:(UIImage *)styleImage;

- (id)initWithDetailUrl:(NSString *)hairDetailUrl andStyleUrl:(NSString *)styleUrl;

@end
