//
//  MyFinancialAccountTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyFinancialAccountTableViewCell.h"
#import "MyFinancialAccountDetailModel.h"

@implementation MyFinancialAccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.topLabel.backgroundColor =colorWithLine;
    self.line.backgroundColor = colorWithLine;
    self.orderNumber.textColor = colorWithPlaceholder;
    self.titleLable.textColor = colorWithBlack;
    self.classiFication.textColor = colorWithDeepGray;
    self.yearsLabel.textColor = colorWithDeepGray;
    self.createTime.textColor = colorWithDeepGray;
    self.contactLabel.textColor = colorWithDeepGray;
    self.payMoney.textColor = colorWithDeepGray;

}
-(void)setModel:(MyFinancialAccountDetailModel *)model
{
    _model =model;
    self.titleLable.text =  model.financeName;
    self.orderNumber.text = [NSString stringWithFormat:@"订单号：%@",model.number];
    self.yearsLabel.text = [NSString stringWithFormat:@"年限：半年x%@",model.count];
    self.createTime.text = [NSString stringWithFormat:@"创建时间：%@",model.createDate];
    self.contactLabel.text = [NSString stringWithFormat:@"%@   %@",model.addressName,model.addressPhone];
    
    [self.payMoney addAttributedWithString:[NSString stringWithFormat:@"支付金额：¥%@",model.cost] range:NSMakeRange([NSString stringWithFormat:@"%@",@"支付金额："].length, [NSString stringWithFormat:@"¥%@",model.cost].length) color:colorWithMainColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
