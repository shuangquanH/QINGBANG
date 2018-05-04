//
//  PlayTogetherCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/9/29.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PlayTogetherCell.h"

@implementation PlayTogetherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageView.layer.cornerRadius = self.headImageView.height / 2;
    self.headImageView.clipsToBounds = YES;
    self.tagLabel.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
    
    //富文本
//    NSString *priceString = [NSString stringWithFormat:@"%@%@",@"报名费¥",@"1000"];
//    self.priceLabel.attributedText = [priceString ld_attributedStringFromNSString:priceString startLocation:3 forwardFont:[UIFont systemFontOfSize:12] backFont:[UIFont systemFontOfSize:17] forwardColor:colorWithOrangeColor backColor:colorWithOrangeColor];
    
}

-(void)setModel:(ActivityListModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.userName;
    if ([model.price isEqualToString:@"0"]) {
        self.priceLabel.text = @"免费";
        self.priceLabel.textColor = colorWithMainColor;
    }else
    {
//        self.priceLabel.text = [NSString stringWithFormat:@"报名费¥%@",model.price];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"报名费¥%@",model.price]];
        [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, 4)];
        self.priceLabel.attributedText = AttributedStr;
        self.priceLabel.textColor = colorWithOrangeColor;
    }
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.userImg]placeholderImage:YGDefaultImgAvatar];
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:YGDefaultImgTwo_One];
    self.remarkLabel.text = model.name;
    self.detailLabel.text = [NSString stringWithFormat:@"%@ %@开始",model.address,model.beginTime];
    self.tagLabel.text = [NSString stringWithFormat:@" %@ ",model.official];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
