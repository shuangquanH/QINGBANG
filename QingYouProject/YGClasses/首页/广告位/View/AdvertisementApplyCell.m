//
//  AdvertisementApplyCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/9/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AdvertisementApplyCell.h"

@implementation AdvertisementApplyCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deleteButton.clipsToBounds = YES;
    self.deleteButton.layer.cornerRadius = 10;
    self.deleteButton.layer.borderWidth = 0.5;
    self.deleteButton.layer.borderColor = colorWithDeepGray.CGColor;
}

-(void)setOrderModel:(OrderListModel *)orderModel
{
    _orderModel = orderModel;
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号:%@",orderModel.number];
    self.titleNameLabel.text = orderModel.adsName;
    self.instructionLabel.text = orderModel.companyName;
    self.timeLabel.text = [NSString stringWithFormat:@"创建时间：%@",orderModel.createDate];
    self.receiverLabel.text = [NSString stringWithFormat:@"%@ %@",orderModel.addressName,orderModel.addressPhone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
