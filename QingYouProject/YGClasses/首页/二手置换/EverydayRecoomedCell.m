//
//  EverydayRecoomedCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/12/11.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "EverydayRecoomedCell.h"

@implementation EverydayRecoomedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(SecondMainRecommendModel *)model
{
    _model = model;
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:YGDefaultImgThree_Four];
    
    self.nameLabel.text = model.title;
    
}

@end
