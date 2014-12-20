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

@interface HairDetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIButton *cameraBtn;
@property (nonatomic,strong) UIImageView *photoView;
@property (nonatomic,strong) UIImage *originImage;

@end

@implementation HairDetailViewController

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
    [self.view addSubview:self.photoView];
    
    [self.photoView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"123" ofType:@"jpg"]];
    self.originImage = img;
    
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
        self.photoView.image = self.originImage;
    }
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
        CGPoint center = faceView.center;
        float m = center.x;
        center.x = center.y;
        center.y = m;
        faceView.center = center;
        faceView.backgroundColor = [UIColor clearColor];
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        faceView.layer.borderWidth = 1;
        [self.photoView addSubview:faceView];
        CGRect frame = CGRectMake(0, 0, 480*rect.size.width/240, (480*rect.size.width/240)*800/480);
        UIImageView *hairView = [[UIImageView alloc] init];
        hairView.frame = frame;
        hairView.center = CGPointMake(faceView.center.x+15, faceView.center.y+75);
        hairView.layer.borderColor = [[UIColor blueColor] CGColor];
        hairView.layer.borderWidth = 1;
        [self.photoView addSubview:hairView];
        
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

@end
