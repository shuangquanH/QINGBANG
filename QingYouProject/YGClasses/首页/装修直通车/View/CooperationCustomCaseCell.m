//
//  CooperationCustomCaseCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CooperationCustomCaseCell.h"

@implementation CooperationCustomCaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.baseView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.55];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
