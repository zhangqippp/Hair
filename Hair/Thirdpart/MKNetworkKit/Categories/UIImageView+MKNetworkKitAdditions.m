//
//  UIImageView+MKNetworkKitAdditions.m
//  MKNetworkKitDemo
//
//  Created by Mugunth Kumar (@mugunthkumar) on 18/01/13.
//  Copyright (C) 2011-2020 by Steinlogic Consulting and Training Pte Ltd

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "UIImageView+MKNetworkKitAdditions.h"

#import "MKNetworkEngine.h"
#import "YQMessageHelper.h"
#import "UIViewAdditions.h"
#import <objc/runtime.h>



static MKNetworkEngine *DefaultEngine;

static char imageFetchOperationKey;

const float kFromCacheAnimationDuration = 0.1f;
const float kFreshLoadAnimationDuration = 0.35f;

@interface UIImageView (/*Private Methods*/)
@property (strong, nonatomic) MKNetworkOperation *imageFetchOperation;
@end

@implementation UIImageView (MKNetworkKitAdditions)

-(MKNetworkOperation*) imageFetchOperation {
    
    return (MKNetworkOperation*) objc_getAssociatedObject(self, &imageFetchOperationKey);
}

-(void) setImageFetchOperation:(MKNetworkOperation *)imageFetchOperation {
    
    objc_setAssociatedObject(self, &imageFetchOperationKey, imageFetchOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void) setDefaultEngine:(MKNetworkEngine*) engine {
    
    DefaultEngine = engine;
}

-(MKNetworkOperation*) setImageFromURL:(NSURL*) url {
    
    return [self setImageFromURL:url placeHolderImage:nil];
}

-(MKNetworkOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image {
    
    return [self setImageFromURL:url placeHolderImage:image usingEngine:DefaultEngine animation:YES];
}

-(MKNetworkOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image animation:(BOOL) yesOrNo {
    
    return [self setImageFromURL:url placeHolderImage:image usingEngine:DefaultEngine animation:yesOrNo];
}

-(MKNetworkOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image usingEngine:(MKNetworkEngine*) imageCacheEngine animation:(BOOL) yesOrNo {
    
    if(image) self.image = image;
    [self.imageFetchOperation cancel];
    if(!imageCacheEngine) imageCacheEngine = DefaultEngine;
    __weak UIImageView *weakSelf = self;
    if(imageCacheEngine) {
        self.imageFetchOperation = [imageCacheEngine imageAtURL:url
                                                           size:self.frame.size
                                              completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
                                                  if(isInCache)
                                                  {
                                                      [weakSelf updateWithImage:fetchedImage];
                                                  }
                                                  else
                                                  {
                                                      __weak UIImageView *weakSelf = self;
                                                      [UIView transitionWithView:self.superview
                                                                        duration:isInCache?kFromCacheAnimationDuration:kFreshLoadAnimationDuration
                                                                         options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction
                                                                      animations:^{
                                                                          //                                                                    if(fetchedImage.imageOrientation != UIImageOrientationUp)
                                                                          //                                                                    {
                                                                          //                                                                        UIImage *imgTmp = [UIImage imageWithCGImage:fetchedImage.CGImage scale:1 orientation:UIImageOrientationUp];
                                                                          //                                                                        self.image = imgTmp;
                                                                          //                                                                    }
                                                                          //                                                                    else
                                                                          //                                                                    {
                                                                          //                                                                       self.image = fetchedImage;
                                                                          //                                                                    }
                                                                          [weakSelf updateWithImage:fetchedImage];
                                                                      } completion:nil];
                                                  }
                                              } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                                                  
                                                  DLog(@"%@", error);
                                              }];
    } else {
        
        DLog(@"No default engine found and imageCacheEngine parameter is null")
    }
    
    return self.imageFetchOperation;
}

- (void)updateWithImage:(UIImage *)fetchedImage
{
    if(fetchedImage.size.width < 10 || fetchedImage.size.height < 10)
    {
        return ;
    }
    if(fetchedImage.imageOrientation != UIImageOrientationUp)
    {
        UIImage *imgTmp = [UIImage imageWithCGImage:fetchedImage.CGImage scale:1 orientation:UIImageOrientationRight];
        self.image = imgTmp;
        CGFloat tmp = self.width;
        self.width = self.height;
        self.height = tmp;
    }
    else
    {
        self.image = fetchedImage;
        
        //后台图片尺寸有时会将长和宽进行颠倒，并且又不是精确颠倒，为了避免出现显示拉伸的问题，此处只好对后台长宽尺寸作出容错处理
        if(fabs(self.height -fetchedImage.size.width) < 5 && fabs(self.width - fetchedImage.size.height) < 5)
        {
            self.width = fetchedImage.size.width;
            self.height = fetchedImage.size.height;
        }
    }
}

-(MKNetworkOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image usingEngine:(MKNetworkEngine*) imageCacheEngine showSpinner:(BOOL)showSpinner animation:(BOOL) yesOrNo {
    
    if(image) self.image = image;
    [self.imageFetchOperation cancel];
    if(!imageCacheEngine) imageCacheEngine = DefaultEngine;
    
    if(imageCacheEngine) {
        if (showSpinner) {
            [YQMessageHelper showHUDActivity:self];
        }
        self.imageFetchOperation = [imageCacheEngine imageAtURL:url
                                                           size:self.frame.size
                                              completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
                                                  if (showSpinner) {
                                                      [YQMessageHelper hideHUDActivity:self];
                                                  }
                                                  [UIView transitionWithView:self.superview
                                                                    duration:isInCache?kFromCacheAnimationDuration:kFreshLoadAnimationDuration
                                                                     options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction
                                                                  animations:^{
                                                                      self.image = fetchedImage;
                                                                  } completion:nil];
                                                  
                                              } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                                                  
                                                  DLog(@"%@", error);
                                              }];
    } else {
        
        DLog(@"No default engine found and imageCacheEngine parameter is null")
    }
    
    return self.imageFetchOperation;
}
- (MKNetworkOperation*)setOriginImageFromURL:(NSURL *)url
                            placeHolderImage:(UIImage *)image
                             queryImageBlock:(queryImageBlock)queryImageBlock

{
    if(image) self.image = image;
    [self.imageFetchOperation cancel];
    MKNetworkEngine *imageCacheEngine = DefaultEngine;
    
    if(imageCacheEngine) {
        self.imageFetchOperation = [imageCacheEngine imageAtURL:url
                                              completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
                                                  if(queryImageBlock)
                                                  {
                                                      queryImageBlock(fetchedImage, url, isInCache);
                                                  }
                                                  
                                              } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                                              }];
    } else {
        
        DLog(@"No default engine found and imageCacheEngine parameter is null")
    }
    
    return self.imageFetchOperation;
}

- (MKNetworkOperation*)setOriginImageFromURL:(NSURL *)url
                            placeHolderImage:(UIImage *)image
                                 sucessBlock:(queryImageBlock)queryImageBlock
                                failureBlock:(errorQueryBlock)errorQueryBlock

{
    if(image) self.image = image;
    [self.imageFetchOperation cancel];
    MKNetworkEngine *imageCacheEngine = DefaultEngine;
    
    if(imageCacheEngine) {
        self.imageFetchOperation = [imageCacheEngine imageAtURL:url
                                              completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
                                                  if(queryImageBlock)
                                                  {
                                                      queryImageBlock(fetchedImage, url, isInCache);
                                                  }
                                                  
                                              } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//                                                  NSLog(@"Loading Image: NetWorkFailure");
                                                  if (errorQueryBlock) {
                                                      errorQueryBlock(completedOperation, error);
                                                  }
                                              }];
    } else {
        
        DLog(@"No default engine found and imageCacheEngine parameter is null")
    }
    
    return self.imageFetchOperation;
}

- (MKNetworkOperation*) setImageFromURL:(NSURL *) url
                       placeHolderImage:(UIImage *) image
                             usingCache:(BOOL)yesOrNo
{
    return [self setImageFromURL:url placeHolderImage:image usingCache:yesOrNo usingEngine:DefaultEngine animation:NO];
}

- (MKNetworkOperation*) setImageFromURL:(NSURL *) url
                       placeHolderImage:(UIImage *) image
                             usingCache:(BOOL)yesOrNo
                            usingEngine:(MKNetworkEngine*) imageCacheEngine
                              animation:(BOOL)animation
{
    if(image) self.image = image;

    if(!imageCacheEngine) imageCacheEngine = DefaultEngine;
    __weak UIImageView *weakSelf = self;
    if(imageCacheEngine) {
        self.imageFetchOperation = [imageCacheEngine imageAtURL:url
                                                           size:self.frame.size
                                                            usingCache:yesOrNo
                                              completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
                                                  if(animation)
                                                  {
                                                      [weakSelf updateWithImage:fetchedImage];
                                                  }
                                                  else
                                                  {
                                                      __weak UIImageView *weakSelf = self;
                                                      [UIView transitionWithView:self.superview
                                                                        duration:isInCache?kFromCacheAnimationDuration:kFreshLoadAnimationDuration
                                                                         options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction
                                                                      animations:^{
                                                                          [weakSelf updateWithImage:fetchedImage];
                                                                      } completion:nil];
                                                  }                                              } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                                                  
                                                  DLog(@"%@", error);
                                              }];
    } else {
        
        DLog(@"No default engine found and imageCacheEngine parameter is null")
    }
    
    return self.imageFetchOperation;
}
@end
