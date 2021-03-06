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
#import "T8SandboxHelper.h"
#import "HairService.h"
#import "YQMessageHelper.h"
#import "QRCodeGenerator.h"

#define Detail_Alert_Save_Tag 101

@interface ExperienceVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIButton *editBtn;
@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,strong) UIButton *resetBtn;
@property (nonatomic,strong) UILabel *scoreLabel;
@property (nonatomic,strong) UIImageView *photoView;
@property (nonatomic,strong) HairDisplayView *hairView;

@property (nonatomic,strong) UIView *QRCodeView;
@property (nonatomic,strong) UIImageView *QRCodeImg;

@property (nonatomic,assign) CGFloat score;
@property (nonatomic,assign) CGFloat scoreAfterAdjust;
@property (nonatomic,assign) CGPoint basePoint;

@end

@implementation ExperienceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(enterCamera)];
    
    self.photoView = [[UIImageView alloc] init];
    self.photoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.photoView.userInteractionEnabled = YES;
    [self.view addSubview:self.photoView];
    [self.photoView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    [self.hairView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.saveBtn.backgroundColor = [UIColor whiteColor];
    self.saveBtn.layer.cornerRadius = 5;
    self.saveBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.saveBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.saveBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    [self.saveBtn addConstraint:[NSLayoutConstraint constraintWithItem:self.saveBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:60]];
    [self.saveBtn addConstraint:[NSLayoutConstraint constraintWithItem:self.saveBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:40]];
    
    [self.view addSubview:self.resetBtn];
    self.resetBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    [self.resetBtn addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:60]];
    [self.resetBtn addConstraint:[NSLayoutConstraint constraintWithItem:self.resetBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:40]];
    
    [self.view addSubview:self.scoreLabel];
    self.scoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scoreLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scoreLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scoreLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:40]];
    
    [self.view addSubview:self.QRCodeView];
    self.QRCodeView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.photoView removeObserver:self forKeyPath:@"image" context:nil];
    [self.hairView removeObserver:self forKeyPath:@"center" context:nil];
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

- (void)setStyleImageUrl:(NSString *)styleImageUrl
{
    _styleImageUrl = styleImageUrl;
    if (styleImageUrl) {
        [self.hairView setImageFromURL:[NSURL URLWithString:styleImageUrl] placeHolderImage:nil];
    }
}

- (void)setScore:(CGFloat)score
{
    _score = score;
    self.scoreAfterAdjust = score;
}

- (void)setScoreAfterAdjust:(CGFloat)scoreAfterAdjust
{
    _scoreAfterAdjust = scoreAfterAdjust;
    if (_scoreAfterAdjust < 0) {
        _scoreAfterAdjust = 0;
    }
//    if (scoreAfterAdjust < 100) {
        self.scoreLabel.text = [NSString stringWithFormat:@"  您的得分为：%.1f分  ",_scoreAfterAdjust];
//    }else{
//        self.scoreLabel.text = [NSString stringWithFormat:@"  您的得分已突破天际：%.1f分  ",_scoreAfterAdjust];
//    }
}

#pragma mark - getter
- (HairDisplayView *)hairView
{
    if (!_hairView) {
        _hairView = [[HairDisplayView alloc] init];
    }
    return _hairView;
}

- (UIButton *)resetBtn
{
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _resetBtn.backgroundColor = [UIColor whiteColor];
        _resetBtn.layer.cornerRadius = 5;
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

- (UIView *)QRCodeView
{
    if (!_QRCodeView) {
        _QRCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _QRCodeView.backgroundColor = [UIColor whiteColor];
        
        _QRCodeImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/4, (self.view.height-self.view.width/2)/2, self.view.width/2, self.view.width/2)];
        [_QRCodeView addSubview:_QRCodeImg];
        
        UILabel *noticeLabel = [[UILabel alloc] init];
        noticeLabel.textAlignment = NSTextAlignmentCenter;
        noticeLabel.size = CGSizeMake(300, 50);
        noticeLabel.center = CGPointMake(_QRCodeView.centerX, _QRCodeImg.bottom+50);
        noticeLabel.text = @"扫描二维码，下载发型效果";
        [_QRCodeView addSubview:noticeLabel];
        
        
//        UIButton *hideButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        
//        hideButton.backgroundColor = [UIColor whiteColor];
//        hideButton.layer.cornerRadius = 5;
//        [hideButton setTitle:@"确定" forState:UIControlStateNormal];
//        [hideButton addTarget:self action:@selector(shareHair:) forControlEvents:UIControlEventTouchUpInside];
//        [_QRCodeView addSubview:hideButton];
    }
    return _QRCodeView;
}

- (UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = UIColorFromRGB(0x057aff);
        _scoreLabel.backgroundColor = [UIColor whiteColor];
        _scoreLabel.layer.cornerRadius = 5;
        _scoreLabel.layer.masksToBounds = YES;
    }
    return _scoreLabel;
}

#pragma mark - method
- (void)enterCamera
{
    NSLog(@"enter camera...");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
    picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

- (void)saveAction:(id)sender
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否要将头像保存至照片库？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.tag = Detail_Alert_Save_Tag;
//    [alert show];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存至本地照片库", @"保存至云相册", nil];
    [sheet showInView:self.view];
}

- (void)resetAction:(id)sender
{
    self.originImage = self.originImage;
}

- (void)shareHair:(UIButton *)sender
{
    self.QRCodeView.hidden = YES;
//    [YQMessageHelper showMessage:@"正在开发中"];
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
    if ([keyPath isEqualToString:@"center"]) {
        
        CGPoint base = self.basePoint;
        CGPoint current = self.hairView.center;
        CGFloat distance = sqrt((base.x-current.x)*(base.x-current.x)+(base.y-current.y)*(base.y-current.y));

        if (distance <= 0) {
            return;
        }else if (distance <= 80){
            self.scoreAfterAdjust = self.score + 5.0f*((rand()%10000)/10000.0f);
        }else{
            self.scoreAfterAdjust = self.score - (distance - 80.0f)*(distance - 80.0f)/200;
        }
        
    }else if ([keyPath isEqualToString:@"image"]){
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
        
        for (UIImageView *img in self.photoView.subviews) {
            [img removeFromSuperview];
        }
        if (features.count<=0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未识别到头像，请重拍" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        for (CIFaceFeature *feature in features) {
            
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
            
            faceView.backgroundColor = [UIColor clearColor];
            [self.photoView addSubview:faceView];
            CGRect frame = CGRectMake(0, 0, 480*rect.size.width/240, (480*rect.size.width/240)*800/480);
            self.hairView.frame = frame;
            self.basePoint = CGPointMake(faceView.center.x, faceView.center.y+100);
            self.hairView.center = CGPointMake(faceView.center.x, faceView.center.y+100);
            [self.photoView addSubview:self.hairView];
            
            //打分机制
            self.score = 70.0f;
            
            CGFloat angleScore = 10.0f;
            if (ABS(feature.faceAngle) < 5.0) {
                angleScore = 10.0f;
            }else if (ABS(feature.faceAngle) < 45.0){
                angleScore -= angleScore*(ABS(feature.faceAngle)-5.0)/40;
            }else{
                angleScore = 0;
            }
            self.score += angleScore;
            
            CGFloat locationXScore = 10.0f;
            if (rect.origin.x<0 || rect.origin.x+rect.size.width>self.photoView.frame.size.width) {
                locationXScore = 0;
            }else{
                locationXScore -= locationXScore*(ABS(((rect.origin.x + rect.size.width)/2) - self.photoView.frame.size.width/2)/(self.photoView.frame.size.width/2 - rect.size.width/2));
            }
            self.score += locationXScore;
            
            CGFloat locationYScore = 10.0f;
            if (rect.origin.y<0 || rect.origin.y+rect.size.height>self.photoView.frame.size.height) {
                locationYScore = 0;
            }
            self.score += locationYScore;
            
            if (feature.hasSmile) {
                self.score += 5;
            }
            
            if (!feature.hasLeftEyePosition) {
                self.score -= 3;
            }
            
            if (!feature.hasRightEyePosition) {
                self.score -= 3;
            }
            
            if (!feature.hasMouthPosition) {
                self.score -= 3;
            }
        }

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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"照片已保存到相册" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIGraphicsBeginImageContext(self.photoView.frame.size);
        [self.photoView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"照片已保存到相册" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if (buttonIndex == 1){
        UIGraphicsBeginImageContext(self.photoView.frame.size);
        [self.photoView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        
        NSString* filePath = [[T8SandboxHelper tmpPath] stringByAppendingPathComponent:@"1.jpg"];
        if ([imageData writeToFile:filePath atomically:YES]) {
            
            [YQMessageHelper showActivity];
            __weak typeof(self) weakSelf = self;
            [HairService uploadHairFileWithPath:filePath successBlock:^(NSDictionary *dictRet) {
                [YQMessageHelper hideActivity];
                if ([[dictRet objectForKey:@"code"] integerValue] == 0) {

                    weakSelf.QRCodeView.hidden = NO;
                    weakSelf.QRCodeImg.image = [QRCodeGenerator qrImageForString:[[dictRet objectForKey:@"data"] objectForKey:@"file"] imageSize:self.QRCodeImg.size.width];
                }else{
                    [YQMessageHelper showMessage:[dictRet objectForKey:@"msg"]];
                }
            } failureBlock:^(NSError *error) {
                [YQMessageHelper hideActivity];
                [YQMessageHelper showMessage:@"上传失败"];
            }];
        }
        
    }
}

@end
