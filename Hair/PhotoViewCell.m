//
//  PhotoViewCell.m
//  Hair
//
//  Created by yewei on 14/12/20.
//  Copyright (c) 2014年 zhphy. All rights reserved.
//

#import "PhotoViewCell.h"

@implementation PhotoViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.photoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (width-40)/3, 300)];
        [self.contentView addSubview:self.photoImg];
    }
    return self;
}

@end
