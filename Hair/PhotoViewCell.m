//
//  PhotoViewCell.m
//  Hair
//
//  Created by yewei on 14/12/20.
//  Copyright (c) 2014年 zhphy. All rights reserved.
//

#import "PhotoViewCell.h"
#import "HairStyleModel.h"

#define kPhotoViewTag 1000

@interface PhotoView : UIView

@property (nonatomic, strong) UIImageView *avatarImg;

@end

@implementation PhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.avatarImg = [[UIImageView alloc] init];
        _avatarImg.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:_avatarImg];
    }
    return self;
}

@end



@interface PhotoViewCell ()

@property (nonatomic, strong) NSMutableArray *photoViews;

@end

@implementation PhotoViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 40)/3;
        CGFloat padding = 10;
        
        for (NSInteger i = 0; i < 3; i++) {
            
            PhotoView *photoView = [[PhotoView alloc] initWithFrame:CGRectMake(padding+i*(width+padding), 10, width, 800*width/480)];
            photoView.tag = kPhotoViewTag + i;
            photoView.hidden = YES;
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
            [photoView addGestureRecognizer:singleTap];
            
            [self.contentView addSubview:photoView];
            
            [self.photoViews addObject:photoView];
        }
    }
    return self;
}

- (void)singleTap:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectedPhotoViewCellIndex:indexPath:)]) {
        [self.delegate didSelectedPhotoViewCellIndex:sender.view.tag - kPhotoViewTag indexPath:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setObject:(id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        
        NSArray *array = (NSArray *)object;
        
        for (NSInteger i = 0; i < array.count; i++) {
            HairStyleModel *model = [array objectAtIndex:i];
            
            PhotoView *memberView = [self.photoViews objectAtIndex:i];
            memberView.hidden = NO;
            [memberView.avatarImg setImageFromURL:[NSURL URLWithString:model.mtFilePath] placeHolderImage:[UIImage imageNamed:@""]];
        }
        
        for (NSInteger i = array.count; i < 3; i++) {
            PhotoView *memberView = [self.photoViews objectAtIndex:i];
            memberView.hidden = YES;
        }
    }
}

#pragma mark - getter

- (NSMutableArray *)photoViews
{
    if (!_photoViews) {
        _photoViews = [[NSMutableArray alloc] init];
    }
    return _photoViews;
}

@end
