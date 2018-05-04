//
//  TextOnlyCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "TextOnlyCell.h"

@implementation TextOnlyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel.preferredMaxLayoutWidth = YGScreenWidth - 30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
