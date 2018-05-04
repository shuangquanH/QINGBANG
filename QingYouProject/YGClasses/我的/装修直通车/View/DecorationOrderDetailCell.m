//
//  DecorationOrderDetailCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "DecorationOrderDetailCell.h"

@implementation DecorationOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.preferredMaxLayoutWidth = YGScreenWidth - 20 - self.nameLabel.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
