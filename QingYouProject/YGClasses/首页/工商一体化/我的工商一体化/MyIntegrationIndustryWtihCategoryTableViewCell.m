//
//  MyIntegrationIndustryWtihCategoryTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/11/30.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyIntegrationIndustryWtihCategoryTableViewCell.h"
#import "IntegrationIndustryModel.h"

@implementation MyIntegrationIndustryWtihCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.topLine.backgroundColor = colorWithLine;
    self.line.backgroundColor =colorWithLine;
    self.OrderNumber.textColor =colorWithDeepGray;
    self.addressLabel.textColor =colorWithBlack;
    self.createTime.textColor =colorWithDeepGray;
    self.contactLabel.textColor =colorWithDeepGray;
    self.moneyLabel.textColor =colorWithDeepGray;
    self.categoryLabel.textColor =colorWithDeepGray;
}
-(void)setModel:(IntegrationIndustryModel *)model
{
    _model =model;
    self.OrderNumber.text = [NSString stringWithFormat:@"订单号：%@",model.number];
    self.addressLabel.text = model.commerceName;
    self.createTime.text = [NSString stringWithFormat:@"创建时间：%@",model.createDate];
    self.contactLabel.text = [NSString stringWithFormat:@"%@ %@",model.addressName,model.addressPhone];
    self.OrderNumber.text = [NSString stringWithFormat:@"订单编号：%@",model.number];
    self.categoryLabel.text = [NSString stringWithFormat:@"类别：%@",model.label];

    [self.moneyLabel addAttributedWithString:[NSString stringWithFormat:@"支付金额：¥%@",model.cost] range:NSMakeRange([NSString stringWithFormat:@"%@",@"支付金额："].length, [NSString stringWithFormat:@"¥%@",model.cost].length) color:colorWithMainColor];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
