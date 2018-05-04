//
//  BabyImageCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/12/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "BabyImageCell.h"

@implementation BabyImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setPicString:(NSString *)picString
{
    _picString = picString;
    __weak typeof(self) strongSelf = self;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:self.picString] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [strongSelf changeMaonryByImage:self.picImageView.image];
    }];
}

-(void)changeMaonryByImage:(UIImage *)image
{
    if (image == nil) return;
    //自适应大小
//    float showWidth = YGScreenWidth;
    float showHeight = image.size.height/image.size.width * (YGScreenWidth-26);
    [self.picImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(13);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.height.mas_equalTo(showHeight);
        [self layoutIfNeeded];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
