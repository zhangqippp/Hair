//
//  PhotoViewCell.h
//  Hair
//
//  Created by yewei on 14/12/20.
//  Copyright (c) 2014年 zhphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@protocol PhotoViewCellDelegate;

@interface PhotoViewCell : BaseTableViewCell

@property (nonatomic, weak) id<PhotoViewCellDelegate> delegate;

@end

@protocol PhotoViewCellDelegate <NSObject>

- (void)didSelectedPhotoViewCellIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath;

@end
