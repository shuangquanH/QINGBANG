//
//  OrderFooterView.m
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderFooterView.h"
#import "OrderManagerController.h"

@implementation OrderFooterView
{
    UILabel * _orderPriceLabel;
    UILabel * _orderNumLabel;
}
- (instancetype)init
{
    if(self = [super init])
    {
        self.backgroundColor = colorWithYGWhite;
        self.frame = CGRectMake(0, 0, YGScreenWidth, 73);
        [self configUI];
    }
    return self;
}


- (void)configUI
{
    _orderPriceLabel = [[UILabel alloc] init];
    _orderPriceLabel.textColor = colorWithOrangeColor;
    _orderPriceLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [self addSubview:_orderPriceLabel];
    [_orderPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-12.5);
    }];
    
    UILabel * label = [[UILabel alloc] init];
    label.text = @"合计:";
    label.textColor = colorWithBlack;
    label.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_orderPriceLabel.mas_centerY);
        make.right.equalTo(_orderPriceLabel.mas_left).offset(-10);
    }];
    _orderNumLabel = [[UILabel alloc] init];
    _orderNumLabel.textColor = colorWithBlack;
    _orderNumLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [self addSubview:_orderNumLabel];
    [_orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_orderPriceLabel.mas_centerY);
        make.right.equalTo(label.mas_left).offset(-10);
    }];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = colorWithTable;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(_orderPriceLabel.mas_bottom).offset(10);
        make.height.offset(1);
    }];
}

- (void)setModel:(OrderModel *)model
{
    _orderPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",model.cost.floatValue];
    _orderNumLabel.text = [NSString stringWithFormat:@"共%@张票",model.count];
    switch (model.type.intValue)
    {
        case PAYMENTPENDINGORDER:
        {
            UIButton * goPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            goPayButton.frame = CGRectMake(YGScreenWidth - 12.5 - 70, self.height - 5 - 25, 70, 25);
            [goPayButton setTitle:@"去支付" forState:UIControlStateNormal];
            [goPayButton addTarget:self action:@selector(goPayButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [goPayButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
            goPayButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            goPayButton.layer.cornerRadius = 12.5;
            goPayButton.layer.masksToBounds = YES;
            goPayButton.layer.borderColor = colorWithMainColor.CGColor;
            goPayButton.layer.borderWidth = 0.8;
            [self addSubview:goPayButton];
            
            UIButton * cancelOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelOrderButton.frame = CGRectMake(CGRectGetMinX(goPayButton.frame) - 15 - 70, self.height - 5 - 25, 70, 25);
            [cancelOrderButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [cancelOrderButton addTarget:self action:@selector(cancelOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [cancelOrderButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            cancelOrderButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            cancelOrderButton.layer.cornerRadius = 12.5;
            cancelOrderButton.layer.masksToBounds = YES;
            cancelOrderButton.layer.borderColor =colorWithTabNaviLine.CGColor;
            cancelOrderButton.layer.borderWidth = 0.8;
            [self addSubview:cancelOrderButton];
        }
            break;
        case PARTICIPATEINORDER:
        {
            UIButton * cancelActiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelActiveButton.frame = CGRectMake(YGScreenWidth - 12.5 - 70, self.height - 5 - 25, 70, 25);
            [cancelActiveButton setTitle:@"取消活动" forState:UIControlStateNormal];
            [cancelActiveButton addTarget:self action:@selector(cancelActiveButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [cancelActiveButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            cancelActiveButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            cancelActiveButton.layer.cornerRadius = 12.5;
            cancelActiveButton.layer.masksToBounds = YES;
            cancelActiveButton.layer.borderColor =colorWithTabNaviLine.CGColor;
            cancelActiveButton.layer.borderWidth = 0.8;
            [self addSubview:cancelActiveButton];
        }
            break;
        case OVERORDER:
        {
            UIButton * delOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
            delOrderButton.frame = CGRectMake(YGScreenWidth - 12.5 - 70, self.height - 5 - 25, 70, 25);
            [delOrderButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [delOrderButton addTarget:self action:@selector(delOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [delOrderButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            delOrderButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            delOrderButton.layer.cornerRadius = 12.5;
            delOrderButton.layer.masksToBounds = YES;
            delOrderButton.layer.borderColor =colorWithTabNaviLine.CGColor;
            delOrderButton.layer.borderWidth = 0.8;
            [self addSubview:delOrderButton];
        }
            break;
        case REFUNDSINGORDER:
        {
            self.frame = CGRectMake(0, 0, YGScreenWidth, 40);

//            UIButton * delOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            delOrderButton.frame = CGRectMake(YGScreenWidth - 12.5 - 70, self.height - 5 - 25, 70, 25);
//            [delOrderButton setTitle:@"删除订单" forState:UIControlStateNormal];
//            [delOrderButton addTarget:self action:@selector(delOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
//            [delOrderButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
//            delOrderButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
//            delOrderButton.layer.cornerRadius = 12.5;
//            delOrderButton.layer.masksToBounds = YES;
//            delOrderButton.layer.borderColor =colorWithLightGray.CGColor;
//            delOrderButton.layer.borderWidth = 0.8;
//            [self addSubview:delOrderButton];
        }
            break;
        case REFUNDSEDORDER:
        {
            UIButton * delOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
            delOrderButton.frame = CGRectMake(YGScreenWidth - 12.5 - 70, self.height - 5 - 25, 70, 25);
            [delOrderButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [delOrderButton addTarget:self action:@selector(delOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [delOrderButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            delOrderButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            delOrderButton.layer.cornerRadius = 12.5;
            delOrderButton.layer.masksToBounds = YES;
            delOrderButton.layer.borderColor =colorWithTabNaviLine.CGColor;
            delOrderButton.layer.borderWidth = 0.8;
            [self addSubview:delOrderButton];
        }
            break;
    }
}


- (void)goPayButtonClick
{
    [self.delegate payOrderButtonClickedWithOrderFooterView:self];
}

- (void)cancelOrderButtonClick
{
    [self.delegate cancelOrderButtonClickedWithOrderFooterView:self];
}

- (void)cancelActiveButtonClick
{
    [self.delegate cancelActiveButtonClickedWithOrderFooterView:self];
}
- (void)delOrderButtonClick
{
    [self.delegate delOrderButtonClickedWithOrderFooterView:self];
}
@end
