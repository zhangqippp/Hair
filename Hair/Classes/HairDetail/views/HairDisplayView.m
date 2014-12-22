//
//  HairDisplayView.m
//  Hair
//
//  Created by 琦张 on 14/12/22.
//  Copyright (c) 2014年 zhphy. All rights reserved.
//

#import "HairDisplayView.h"

@interface HairDisplayView ()

@property (nonatomic,assign) BOOL isDragging;
@property (nonatomic,assign) CGPoint beginLoc;

@end

@implementation HairDisplayView

- (id)init
{
    self = [super init];
    if (self) {
        self.isDragable = YES;
        self.userInteractionEnabled = YES;
        
        // 旋转手势
        UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
        [self addGestureRecognizer:rotationGestureRecognizer];
        
        // 缩放手势
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        [self addGestureRecognizer:pinchGestureRecognizer];
        
        // 移动手势
//        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
//        [self addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.isDragging = NO;
    [super touchesBegan:touches withEvent:event];
    self.beginLoc = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.isDragable) {
//        if (self.isDragging==NO) {
//            if ([self.delegate respondsToSelector:@selector(dragBegin:)]) {
//                [self.delegate dragBegin:self];
//            }
//        }else{
//            if ([self.delegate respondsToSelector:@selector(dragMove:)]) {
//                [self.delegate dragMove:self];
//            }
//        }
        self.isDragging = YES;
        
        if (self.superview) {
            [self.superview bringSubviewToFront:self];
        }
        
        UITouch *touch = [touches anyObject];
        CGPoint currentLocation = [touch locationInView:self];
        
        float offsetX = currentLocation.x - self.beginLoc.x;
        float offsetY = currentLocation.y - self.beginLoc.y;
        
        self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
        
//        CGRect superviewFrame = self.superview.frame;
//        CGRect frame = self.frame;
//        CGFloat leftLimitX = frame.size.width / 2;
//        CGFloat rightLimitX = superviewFrame.size.width - leftLimitX;
//        CGFloat topLimitY = frame.size.height / 2;
//        CGFloat bottomLimitY = superviewFrame.size.height - topLimitY;
        
//        if (self.center.x > rightLimitX) {
//            self.center = CGPointMake(rightLimitX, self.center.y);
//        }else if (self.center.x <= leftLimitX) {
//            self.center = CGPointMake(leftLimitX, self.center.y);
//        }
//        
//        if (self.center.y > bottomLimitY) {
//            self.center = CGPointMake(self.center.x, bottomLimitY);
//        }else if (self.center.y <= topLimitY){
//            self.center = CGPointMake(self.center.x, topLimitY);
//        }
        
//        if ([self.delegate respondsToSelector:@selector(dragMove:)]) {
//            [self.delegate dragMove:self];
//        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded: touches withEvent: event];
    
    //点击非拖拽的情况
//    if (!self.isDragging && [self.delegate respondsToSelector:@selector(touchBegin:)]) {
//        [self.delegate touchBegin:self];
//        return;
//    }
    
    //拖拽结束的情况
//    if ([self.delegate respondsToSelector:@selector(dragEnd:)]) {
//        [self.delegate dragEnd:self];
//    }
    
    //    if (self.isDragging && _dragDoneBlock) {
    //        _dragDoneBlock(self);
    //        _singleTapBeenCanceled = YES;
    //    }
    
    //    if (_isDragging && _autoDocking) {
    //        CGRect superviewFrame = self.superview.frame;
    //        CGRect frame = self.frame;
    //        CGFloat middleX = superviewFrame.size.width / 2;
    //
    //        if (self.center.x >= middleX) {
    //            [UIView animateWithDuration:RC_AUTODOCKING_ANIMATE_DURATION animations:^{
    //                self.center = CGPointMake(superviewFrame.size.width - frame.size.width / 2, self.center.y);
    //                if (_autoDockingBlock) {
    //                    _autoDockingBlock(self);
    //                }
    //            } completion:^(BOOL finished) {
    //                if (_autoDockingDoneBlock) {
    //                    _autoDockingDoneBlock(self);
    //                }
    //            }];
    //        } else {
    //            [UIView animateWithDuration:RC_AUTODOCKING_ANIMATE_DURATION animations:^{
    //                self.center = CGPointMake(frame.size.width / 2, self.center.y);
    //                if (_autoDockingBlock) {
    //                    _autoDockingBlock(self);
    //                }
    //            } completion:^(BOOL finished) {
    //                if (_autoDockingDoneBlock) {
    //                    _autoDockingDoneBlock(self);
    //                }
    //            }];
    //        }
    //    }
    
    _isDragging = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isDragging = NO;
    [super touchesCancelled:touches withEvent:event];
}

@end
