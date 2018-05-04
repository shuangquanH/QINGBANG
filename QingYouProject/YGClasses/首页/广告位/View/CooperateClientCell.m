//
//  CooperateClientCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CooperateClientCell.h"

@implementation CooperateClientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = colorWithBlack;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
