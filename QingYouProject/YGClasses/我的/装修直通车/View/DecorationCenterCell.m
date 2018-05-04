//
//  DecorationCenterCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "DecorationCenterCell.h"

@implementation DecorationCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.whiteView.layer.cornerRadius = 5;
    self.whiteView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
