//
//  SecondhandReplaceOtherHomePageTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplaceOtherHomePageTableViewCell.h"
#import "SecondhandReplaceOtherHomePageModel.h"

@implementation SecondhandReplaceOtherHomePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.goodsTitle.textColor =colorWithBlack;
    self.goodsDetail.textColor =colorWithDeepGray;
    
}
-(void)setModel:(SecondhandReplaceOtherHomePageModel *)model
{
    _model = model;
    _goodsTitle.text = model.title;
    _goodsDetail.text = model.introduce;
    [_goodImg sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:YGDefaultImgSquare];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
