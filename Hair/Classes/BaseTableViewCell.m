//
//  T8BaseTableViewCell.m
//  tinfinite
//
//  Created by yewei on 14/12/25.
//  Copyright (c) 2014年 Tinfinite. All rights reserved.
//

#import "BaseTableViewCell.h"

static UILabel *label;

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    }
    
    return self;
}

- (void)setObject:(id)object {
    _object = object;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 44;
}

@end
