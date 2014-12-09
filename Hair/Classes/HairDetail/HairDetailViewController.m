//
//  HairDetailViewController.m
//  Hair
//
//  Created by 琦张 on 14/12/8.
//  Copyright (c) 2014年 zhphy. All rights reserved.
//

#import "HairDetailViewController.h"

@interface HairDetailViewController ()

@property (nonatomic,strong) UIButton *cameraBtn;

@end

@implementation HairDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cameraBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [self.cameraBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - method
- (void)enterCamera
{
    
}

@end
