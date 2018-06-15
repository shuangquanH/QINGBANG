//
//  MyCollectionTextCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/12/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyCollectionTextCell.h"

@implementation MyCollectionTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cancelButton.layer.cornerRadius = 12;
    
    self.cancelButton.clipsToBounds = YES;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = colorWithMainColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
