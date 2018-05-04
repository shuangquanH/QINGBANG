//
//  DesignEffectCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "DesignEffectCell.h"

@implementation DesignEffectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(DesignEffectModel *)model
{
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"%@m²/%@",model.areaCount,model.style];
    self.designerLabel.text = [NSString stringWithFormat:@"设计方:%@",model.pictureName1];
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.pictureUrl1] placeholderImage:YGDefaultImgFour_Three];
}

@end
