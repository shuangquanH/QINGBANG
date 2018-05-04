//
//  TextTopPictureBottomCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "TextTopPictureBottomCell.h"

@implementation TextTopPictureBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel.preferredMaxLayoutWidth = YGScreenWidth - 30;
    self.leftImageView.layer.cornerRadius = 5;
    self.leftImageView.clipsToBounds = YES;
    self.middleImageView.layer.cornerRadius = 5;
    self.middleImageView.clipsToBounds = YES;
    self.rightImageView.layer.cornerRadius = 5;
    self.rightImageView.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
