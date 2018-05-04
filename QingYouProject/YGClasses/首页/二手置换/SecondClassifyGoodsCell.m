//
//  SecondClassifyGoodsCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/12/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondClassifyGoodsCell.h"

@implementation SecondClassifyGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(SecondClassfilyGoodsModel *)model
{
    _model = model;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.picture]];
    self.goodsNameLabel.text = model.title;
    self.addressLabel.text = model.address;
}

@end
