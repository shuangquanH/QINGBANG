//
//  PictureLeftTextRightCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PictureLeftTextRightCell.h"

@implementation PictureLeftTextRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel.preferredMaxLayoutWidth = YGScreenWidth - 30; //fd适配高度 numberOfLines为0的label加上这句话 等于的宽度是实际的宽度 如果不加这句话在手机是10.2的时候会崩溃
    self.leftimageView.layer.cornerRadius = 5;
    self.leftimageView.clipsToBounds = YES;
}


-(void)setOrderModel:(TakePhotosOrderModel *)orderModel
{
    _orderModel = orderModel;
//    NSURL *picUrl = [NSURL URLWithString:orderModel.img];
//    [self.leftimageView sd_setImageWithURL:picUrl];
    self.timeLabel.text = [NSString stringWithFormat:@"下单时间:%@",orderModel.createDate];
    self.nameLabel.text = orderModel.descript;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
