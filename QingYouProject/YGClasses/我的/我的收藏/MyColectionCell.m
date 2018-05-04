//
//  MyColectionCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/9.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyColectionCell.h"

@implementation MyColectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cancelButton.layer.cornerRadius = 12;
    self.cancelButton.clipsToBounds = YES;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = colorWithMainColor.CGColor;
    
    self.picImageView.layer.cornerRadius = 5;
    self.picImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
