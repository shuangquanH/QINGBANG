//
//  ApplyInformationCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/9/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ApplyInformationCell.h"

@implementation ApplyInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.applyTitleLabel.textColor = colorWithDeepGray;
    self.applyTextField.textColor = colorWithDeepGray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
