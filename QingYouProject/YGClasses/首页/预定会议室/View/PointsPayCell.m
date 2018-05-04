//
//  PointsPayCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/30.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PointsPayCell.h"

@implementation PointsPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.pointsRadioButton.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
