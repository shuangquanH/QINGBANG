//
//  AllianceOrderDetailHeaderView.m
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceOrderDetailHeaderView.h"

@implementation AllianceOrderDetailHeaderView
{
    UILabel * _orderStateLabel;
    UILabel * _orderNumberLabel;//交易单号
    UILabel * _orderDateLabel;//创建时间
}
- (instancetype)init
{
    if(self = [super init])
    {
        self.frame = CGRectMake(0, 0, YGScreenWidth, 95);
        self.backgroundColor = colorWithYGWhite;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _orderStateLabel = [[UILabel alloc] init];
    _orderStateLabel.textColor = colorWithOrangeColor;
    _orderStateLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    [self addSubview:_orderStateLabel];
    [_orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12.5);
        make.top.equalTo(self.mas_top).offset(15);
    }];
    
    _orderNumberLabel = [[UILabel alloc] init];
    _orderNumberLabel.textColor = colorWithLightGray;
    _orderNumberLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [self addSubview:_orderNumberLabel];
    [_orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderStateLabel.mas_left);
        make.top.equalTo(_orderStateLabel.mas_bottom).offset(15);
    }];
    
    _orderDateLabel = [[UILabel alloc] init];
    _orderDateLabel.textColor = colorWithLightGray;
    _orderDateLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [self addSubview:_orderDateLabel];
    [_orderDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12.5);
        make.top.equalTo(_orderNumberLabel.mas_bottom).offset(10);
    }];
}

- (void)setModel:(OrderModel *)model
{
    _model = model;
//    switch (model.type.intValue)
//    {
//        case 1:
//            _orderStateLabel.text = @"待付款";
//            break;
//        case 2:
//            _orderStateLabel.text = @"待参与";
//            break;
//        case 3:
//            _orderStateLabel.text = @"已完成";
//            break;
//        case 4:
//            _orderStateLabel.text = @"退款中";
//            break;
//        case 5:
//            _orderStateLabel.text = @"退款成功";
//            break;
//
//    }
        switch (model.type.intValue)
        {
            case 0:
                _orderStateLabel.text = @"待支付";
                break;
            case 1:
                _orderStateLabel.text = @"待参与";
                break;
            case 2:
                _orderStateLabel.text = @"已完成";
                break;
            case 3:
                _orderStateLabel.text = @"退款中";
                break;
            case 4:
                _orderStateLabel.text = @"退款成功";
                break;
            case 5:
                _orderStateLabel.text = @"退款成功";
                break;
        }
    _orderNumberLabel.text = [NSString stringWithFormat:@"交易单号:  %@",model.number];
    _orderDateLabel.text = [NSString stringWithFormat:@"创建时间:  %@",model.createDate];
}
@end
