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
    
//    self.originImage = [UIImage imageNamed:@"111"];
    self.photoView.image = [UIImage imageNamed:@"111"];
    
    
    
//    CIImage *image = self.originImage.CIImage;
//    CIContext *detectContext = [CIContext contextWithOptions:nil];                    // 1
//    NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };      // 2
//    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
//                                              context:detectContext
//                                              options:opts];                    // 3
//    opts = @{ CIDetectorImageOrientation : [[image properties] valueForKey:kCGImagePropertyOrientation] }; // 4
//    NSArray *features = [detector featuresInImage:image options:opts];        // 5
    
//    NSLog(@"features:%@",features);

    
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
        self.photoView.image = originImage;
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
    for (CIFaceFeature *feature in features) {
        NSLog(@"face bounds:%f,%f,%f,%f",feature.bounds.origin.x,feature.bounds.origin.y,feature.bounds.size.width,feature.bounds.size.height);
    }
}

@end
