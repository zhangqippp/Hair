//
//  HairDetailViewController.m
//  Hair
//
//  Created by 琦张 on 14/12/8.
//  Copyright (c) 2014年 zhphy. All rights reserved.
//

#import "HairDetailViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
#import "ExperienceVC.h"

@interface HairDetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIImage *hairImage;
@property (nonatomic,strong) UIImage *styleImage;
@property (nonatomic,strong) UIImageView *hairDetailView;
@property (nonatomic,strong) UIButton *experienceBtn;

@end

@implementation HairDetailViewController

- (id)initWithDetailImage:(UIImage *)hairDetailImage andStyleImage:(UIImage *)styleImage
{
    self = [super init];
    if (self) {
        self.hairImage = hairDetailImage;
        self.styleImage = styleImage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.hairDetailView];
    
    self.experienceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.experienceBtn setTitle:@"体验" forState:UIControlStateNormal];
    [self.experienceBtn addTarget:self action:@selector(enterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.experienceBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.experienceBtn];
    
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

#pragma mark - getter
- (UIImageView *)hairDetailView
{
    if (!_hairDetailView) {
        _hairDetailView = [[UIImageView alloc] init];
        _hairDetailView.frame = self.view.bounds;
        _hairDetailView.backgroundColor = [UIColor whiteColor];
    }
    return _hairDetailView;
}

#pragma mark - setter
- (void)setHairImage:(UIImage *)hairImage
{
    _hairImage = hairImage;
    self.hairDetailView.image = hairImage;
    self.hairDetailView.frame = CGRectMake(0, 0, self.view.bounds.size.height*hairImage.size.width/hairImage.size.height, self.view.bounds.size.height);
    self.hairDetailView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
}

#pragma mark - method
- (void)enterCamera
{
    NSLog(@"enter camera...");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *originImage = info[UIImagePickerControllerOriginalImage];
        ExperienceVC *experience = [[ExperienceVC alloc] init];
        experience.originImage = originImage;
        experience.styleImage = self.styleImage;
        [self.navigationController pushViewController:experience animated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
