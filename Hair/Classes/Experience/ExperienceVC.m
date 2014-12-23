//
//  ExperienceVC.m
//  Hair
//
//  Created by 琦张 on 14/12/24.
//  Copyright (c) 2014年 zhphy. All rights reserved.
//

#import "ExperienceVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
#import "HairDisplayView.h"

#define Detail_Alert_Save_Tag 101

@interface ExperienceVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIButton *cameraBtn;
@property (nonatomic,strong) UIButton *editBtn;
@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,strong) UIImageView *photoView;
@property (nonatomic,strong) HairDisplayView *hairView;

@end

@implementation ExperienceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cameraBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [self.cameraBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.cameraBtn addTarget:self action:@selector(enterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cameraBtn];
    
    self.photoView = [[UIImageView alloc] init];
    self.photoView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    self.photoView.backgroundColor = [UIColor grayColor];
    self.photoView.userInteractionEnabled = YES;
    [self.view addSubview:self.photoView];
    [self.photoView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.saveBtn.backgroundColor = [UIColor whiteColor];
    self.saveBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.saveBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.saveBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    [self.saveBtn addConstraint:[NSLayoutConstraint constraintWithItem:self.saveBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:60]];
    [self.saveBtn addConstraint:[NSLayoutConstraint constraintWithItem:self.saveBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:40]];
    
    //    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"123" ofType:@"jpg"]];
    //    self.originImage = img;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.photoView removeObserver:self forKeyPath:@"image" context:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - setter
- (void)setOriginImage:(UIImage *)originImage
{
    _originImage = originImage;
    if (originImage) {
        self.photoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width*self.originImage.size.height/self.originImage.size.width);
        self.photoView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        self.photoView.image = originImage;
    }
}

- (void)setStyleImage:(UIImage *)styleImage
{
    _styleImage = styleImage;
    if (styleImage) {
        self.hairView.image = styleImage;
    }
}

#pragma mark - getter
- (HairDisplayView *)hairView
{
    if (!_hairView) {
        _hairView = [[HairDisplayView alloc] init];
    }
    return _hairView;
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

- (void)saveAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否要将头像保存至照片库？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = Detail_Alert_Save_Tag;
    [alert show];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *originImage = info[UIImagePickerControllerOriginalImage];
        self.originImage = originImage;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"image change ...");
    //    CIImage *image = self.originImage.CIImage;
    
    int exifOrientation;
    switch (self.originImage.imageOrientation) {
        case UIImageOrientationUp:
            exifOrientation = 1;
            break;
        case UIImageOrientationDown:
            exifOrientation = 3;
            break;
        case UIImageOrientationLeft:
            exifOrientation = 8;
            break;
        case UIImageOrientationRight:
            exifOrientation = 6;
            break;
        case UIImageOrientationUpMirrored:
            exifOrientation = 2;
            break;
        case UIImageOrientationDownMirrored:
            exifOrientation = 4;
            break;
        case UIImageOrientationLeftMirrored:
            exifOrientation = 5;
            break;
        case UIImageOrientationRightMirrored:
            exifOrientation = 7;
            break;
        default:
            break;
    }
    
    NSDictionary *detectorOptions = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh }; // TODO: read doc for more tuneups
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    
    NSArray *features = [faceDetector featuresInImage:[CIImage imageWithCGImage:self.originImage.CGImage] options:@{CIDetectorImageOrientation:[NSNumber numberWithInt:exifOrientation]}];
    
    NSLog(@"features:%@",features);
    for (UIImageView *img in self.photoView.subviews) {
        [img removeFromSuperview];
    }
    for (CIFaceFeature *feature in features) {
        NSLog(@"face bounds:%f,%f,%f,%f",feature.bounds.origin.x,feature.bounds.origin.y,feature.bounds.size.width,feature.bounds.size.height);
        UIImageView *faceView = [[UIImageView alloc] init];
        CGRect rect = feature.bounds;
        rect.origin.x *= self.photoView.frame.size.width/self.originImage.size.width;
        rect.origin.y *= self.photoView.frame.size.width/self.originImage.size.width;
        rect.size.width *= self.photoView.frame.size.width/self.originImage.size.width;
        rect.size.height *= self.photoView.frame.size.width/self.originImage.size.width;
        float a = rect.origin.x;
        rect.origin.x = rect.origin.y;
        rect.origin.y = a;
        faceView.frame = rect;
        
        //        CGPoint center = faceView.center;
        //        center.y = self.photoView.frame.size.height - center.y;
        //        faceView.center = center;
        
        //        CGPoint center = faceView.center;
        //        float m = center.x;
        //        center.x = center.y;
        //        center.y = m;
        //        faceView.center = center;
        
        faceView.backgroundColor = [UIColor clearColor];
        //        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        //        faceView.layer.borderWidth = 1;
        [self.photoView addSubview:faceView];
        CGRect frame = CGRectMake(0, 0, 480*rect.size.width/240, (480*rect.size.width/240)*800/480);
        self.hairView.frame = frame;
        self.hairView.center = CGPointMake(faceView.center.x+15, faceView.center.y+75);
        //        self.hairView.layer.borderColor = [[UIColor blueColor] CGColor];
        //        self.hairView.layer.borderWidth = 1;
        [self.photoView addSubview:self.hairView];
        
        //        for (int i=1; i<10; i++) {
        //            hairView.image = [UIImage imageNamed:[NSString stringWithFormat:@"h0%d",i]];
        //            UIGraphicsBeginImageContext(self.photoView.frame.size);
        //            [self.photoView.layer renderInContext:UIGraphicsGetCurrentContext()];
        //            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //            UIGraphicsEndImageContext();
        //            NSData *imageData = UIImageJPEGRepresentation(image, 1);
        //            [imageData writeToFile:[NSString stringWithFormat:@"/Users/qizhang/Desktop/me/%d.jpg",i] atomically:YES];
        //        }
        //        for (int i=10; i<33; i++) {
        //            hairView.image = [UIImage imageNamed:[NSString stringWithFormat:@"h%d",i]];
        //            UIGraphicsBeginImageContext(self.photoView.frame.size);
        //            [self.photoView.layer renderInContext:UIGraphicsGetCurrentContext()];
        //            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //            UIGraphicsEndImageContext();
        //            NSData *imageData = UIImageJPEGRepresentation(image, 1);
        //            [imageData writeToFile:[NSString stringWithFormat:@"/Users/qizhang/Desktop/me/%d.jpg",i] atomically:YES];
        //        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == Detail_Alert_Save_Tag && buttonIndex == 1) {
        UIGraphicsBeginImageContext(self.photoView.frame.size);
        [self.photoView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
}

@end
