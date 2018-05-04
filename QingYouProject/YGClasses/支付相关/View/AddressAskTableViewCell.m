//
//  AddressAskTableViewCell.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/9/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AddressAskTableViewCell.h"
#import "AddressAskConfig.h"
#import "AddressAskModel.h"
#import "FinancialAccountingOrderModel.h"
#import "NetManagerModel.h"
#import "ADManagerModel.h"
#import "CommercialRegistrationModel.h"
#import "AddressAskAndRegisterModel.h"
#import "VIPServiceManagerModel.h"

@implementation AddressAskTableViewCell
{
    //订单号
    UILabel *_orderIdLabel;
    //上部标题label（大字）
    UILabel *_titleLabel;
    //下部详情label（小字）
    UILabel *_subDetailLabel;
    //vip包月 或 xx维修
    UILabel *_typeLabel;
    //vip包月 或 xx维修左侧小图
    UIImageView *_iconImageView;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _orderIdLabel = [[UILabel alloc] init];
    _orderIdLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    _orderIdLabel.textColor = colorWithLightGray;
    [self.contentView addSubview:_orderIdLabel];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorWithLine;
    [self.contentView addSubview:lineView];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.numberOfLines = 0;
    _titleLabel.preferredMaxLayoutWidth = YGScreenWidth - 24;
    [self.contentView addSubview:_titleLabel];

    _subDetailLabel = [[UILabel alloc] init];
    _subDetailLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _subDetailLabel.textColor = colorWithBlack;
    _subDetailLabel.numberOfLines = 0;
    _subDetailLabel.preferredMaxLayoutWidth = YGScreenWidth - 24;
    [self.contentView addSubview:_subDetailLabel];

    [_orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];

    if (self.reuseIdentifier.intValue == AddressAskPageTypeNetManager || self.reuseIdentifier.intValue == AddressAskPageTypeVIPServiceManager)
    {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = _orderIdLabel.font;
        _typeLabel.textColor = colorWithMainColor;
        [_typeLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [_typeLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_typeLabel];

        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];

        [_orderIdLabel mas_updateConstraints:^(MASConstraintMaker *make)
        {
            make.right.mas_equalTo(_iconImageView.mas_left).offset(-10);
        }];

        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(_orderIdLabel);
        }];

        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.centerY.mas_equalTo(_typeLabel);
            make.right.mas_equalTo(_typeLabel.mas_right).offset(-5);
        }];
    }

    [lineView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(_orderIdLabel.mas_bottom).offset(12);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.mas_equalTo(_orderIdLabel.mas_left);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(lineView.mas_bottom).offset(12);
    }];

    [_subDetailLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.mas_equalTo(_orderIdLabel);
        make.right.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(12);
        make.bottom.mas_equalTo(self.contentView).offset(-12);
    }];
}

- (void)setAddressAskModel:(AddressAskModel *)addressAskModel
{
    _addressAskModel = addressAskModel;
    _orderIdLabel.text = [NSString stringWithFormat:@"订单号 %@",addressAskModel.orderId];
    _titleLabel.text = addressAskModel.orderTitle;
    NSString *detailString = [NSString stringWithFormat:@"创建时间：%@\n%@    %@\n支付金额：￥%@",addressAskModel.orderDate,addressAskModel.orderName,addressAskModel.orderPhone,addressAskModel.orderPay];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:detailString];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:colorWithMainColor
                             range:NSMakeRange(detailString.length - addressAskModel.orderPay.length - 1, addressAskModel.orderPay.length + 1)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10; // 调整行间距
    NSRange range = NSMakeRange(0, detailString.length);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    _subDetailLabel.attributedText = attributedString;
}

- (void)setAdManagerModel:(ADManagerModel *)adManagerModel
{
    _adManagerModel = adManagerModel;
    _orderIdLabel.text = [NSString stringWithFormat:@"订单号 %@",adManagerModel.orderId];
    NSString *titleString = [NSString stringWithFormat:@"%@\n%@",adManagerModel.orderTitle,adManagerModel.orderSubTitle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:titleString];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:colorWithMainColor
                             range:NSMakeRange(0, titleString.length - adManagerModel.orderSubTitle.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10; // 调整行间距
    NSRange range = NSMakeRange(0, titleString.length);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    _titleLabel.attributedText = attributedString;

    [_subDetailLabel addAttributedWithString:[NSString stringWithFormat:@"创建时间：%@\n%@    %@\n%@",adManagerModel.orderDate,adManagerModel.orderName,adManagerModel.orderPhone,adManagerModel.orderAddress] lineSpace:10];

}

- (void)setFinancialAccountingOrderModel:(FinancialAccountingOrderModel *)financialAccountingOrderModel
{
    _financialAccountingOrderModel = financialAccountingOrderModel;
    _orderIdLabel.text = [NSString stringWithFormat:@"订单号 %@",financialAccountingOrderModel.orderId];
    _titleLabel.text = financialAccountingOrderModel.orderTitle;
    NSString *detailString = [NSString stringWithFormat:@"类别：%@\n年限：%@\n创建时间：%@\n%@    %@\n支付金额：￥%@",financialAccountingOrderModel.orderKind,financialAccountingOrderModel.orderYear,financialAccountingOrderModel.orderDate,financialAccountingOrderModel.orderName,financialAccountingOrderModel.orderPhone,financialAccountingOrderModel.orderPay];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:detailString];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:colorWithMainColor
                             range:NSMakeRange(detailString.length - financialAccountingOrderModel.orderPay.length - 1, financialAccountingOrderModel.orderPay.length + 1)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10; // 调整行间距
    NSRange range = NSMakeRange(0, detailString.length);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    _subDetailLabel.attributedText = attributedString;
}

- (void)setNetManagerModel:(NetManagerModel *)netManagerModel
{
    _netManagerModel = netManagerModel;
    _orderIdLabel.text = [NSString stringWithFormat:@"订单号 %@",netManagerModel.orderId];
    _typeLabel.text = netManagerModel.orderFixName;
    _titleLabel.text = netManagerModel.orderTitle;
    [_subDetailLabel addAttributedWithString:[NSString stringWithFormat:@"%@    %@\n%@\n创建时间：%@",netManagerModel.orderName,netManagerModel.orderPhone,netManagerModel.orderAddress,netManagerModel.orderDate] lineSpace:10];
    _iconImageView.image = [UIImage imageNamed:@"tab_1_not-selected"];
}

- (void)setVipServiceManagerModel:(VIPServiceManagerModel *)vipServiceManagerModel
{
    _vipServiceManagerModel = vipServiceManagerModel;
    _orderIdLabel.text = [NSString stringWithFormat:@"订单号 %@",vipServiceManagerModel.orderId];
    _typeLabel.text = vipServiceManagerModel.orderVIPType;
    _titleLabel.text = vipServiceManagerModel.orderTitle;
    [_subDetailLabel addAttributedWithString:[NSString stringWithFormat:@"%@    %@\n%@\n创建时间：%@",vipServiceManagerModel.orderName,vipServiceManagerModel.orderPhone,vipServiceManagerModel.orderAddress,vipServiceManagerModel.orderDate] lineSpace:10];
    _iconImageView.image = [UIImage imageNamed:@"tab_1_selected"];
}

- (void)setCommercialRegistrationModel:(CommercialRegistrationModel *)commercialRegistrationModel
{
    _commercialRegistrationModel = commercialRegistrationModel;
    _orderIdLabel.text = [NSString stringWithFormat:@"订单号 %@",commercialRegistrationModel.orderId];
    _titleLabel.text = commercialRegistrationModel.orderTitle;
    NSString *detailString = [NSString stringWithFormat:@"类别：%@\n创建时间：%@\n%@    %@\n支付金额：￥%@",commercialRegistrationModel.orderKind,commercialRegistrationModel.orderDate,commercialRegistrationModel.orderName,commercialRegistrationModel.orderPhone,commercialRegistrationModel.orderPay];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:detailString];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:colorWithMainColor
                             range:NSMakeRange(detailString.length - commercialRegistrationModel.orderPay.length - 1, commercialRegistrationModel.orderPay.length + 1)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10; // 调整行间距
    NSRange range = NSMakeRange(0, detailString.length);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    _subDetailLabel.attributedText = attributedString;
}

- (void)setAddressAskAndRegisterModel:(AddressAskAndRegisterModel *)addressAskAndRegisterModel
{
    _addressAskAndRegisterModel = addressAskAndRegisterModel;
    _orderIdLabel.text = [NSString stringWithFormat:@"订单号 %@",addressAskAndRegisterModel.orderId];
    _titleLabel.text = addressAskAndRegisterModel.orderTitle;
    NSString *detailString = [NSString stringWithFormat:@"类别：%@\n创建时间：%@\n%@    %@\n支付金额：￥%@",addressAskAndRegisterModel.orderKind,addressAskAndRegisterModel.orderDate,addressAskAndRegisterModel.orderName,addressAskAndRegisterModel.orderPhone,addressAskAndRegisterModel.orderPay];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:detailString];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:colorWithMainColor
                             range:NSMakeRange(detailString.length - addressAskAndRegisterModel.orderPay.length - 1, addressAskAndRegisterModel.orderPay.length + 1)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10; // 调整行间距
    NSRange range = NSMakeRange(0, detailString.length);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    _subDetailLabel.attributedText = attributedString;
}

@end
