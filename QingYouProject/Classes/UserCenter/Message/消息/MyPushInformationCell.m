//
//  MyPushInformationCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/12/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyPushInformationCell.h"

@implementation MyPushInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 10;
    self.bgView.clipsToBounds = YES;
}
-(void)setModel:(MyInformationModel *)model
{
    _model = model;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.createDateLabel.text = model.createDate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
