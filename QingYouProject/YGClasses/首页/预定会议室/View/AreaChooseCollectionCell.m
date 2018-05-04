//
//  AreaChooseCollectionCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AreaChooseCollectionCell.h"

@implementation AreaChooseCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
}

-(void)setModel:(MeetingAreaModel *)model
{
    _model = model;
    self.areaLabel.text = model.areaName;
    NSURL *picURL = [NSURL URLWithString:model.imgUrl];
    [self.areaImageView sd_setImageWithURL:picURL placeholderImage:YGDefaultImgFour_Three];
}

@end
