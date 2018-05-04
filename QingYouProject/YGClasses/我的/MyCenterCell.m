//
//  MyCenterCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/7.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyCenterCell.h"

@implementation MyCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.leftImageView sizeToFit];
    [self.centerImageView sizeToFit];
    [self.rightImageVIew sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
