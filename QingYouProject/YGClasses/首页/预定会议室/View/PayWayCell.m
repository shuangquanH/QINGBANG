//
//  PayWayCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PayWayCell.h"

@implementation PayWayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.radioButton.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
