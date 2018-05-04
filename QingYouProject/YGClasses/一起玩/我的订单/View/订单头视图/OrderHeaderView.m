//
//  OrderHeaderView.m
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderHeaderView.h"

@implementation OrderHeaderView
{
    UIImageView * _orderImageView;
    UILabel * _orderNameLabel;
    UILabel * _orderTypeLabel;
}
- (instancetype)init
{
    if(self = [super init])
    {
        self.frame =CGRectMake(0, 0, YGScreenWidth, 40);
        self.backgroundColor = colorWithYGWhite;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 5)];
    lineView.backgroundColor = colorWithTable;
    [self addSubview:lineView];
    
    _orderImageView = [[UIImageView alloc] init];
    _orderImageView.contentMode = UIViewContentModeScaleAspectFill;
    _orderImageView.clipsToBounds = YES;
    [self addSubview:_orderImageView];
    [_orderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12.5);
        make.top.equalTo(lineView.mas_bottom).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.width.equalTo(_orderImageView.mas_height);
    }];
    
    _orderTypeLabel = [[UILabel alloc] init];
    _orderTypeLabel.textColor = colorWithOrangeColor;
    _orderTypeLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [self addSubview: _orderTypeLabel];
    [_orderTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_orderImageView.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12.5);
    }];
    
    _orderNameLabel = [[UILabel alloc] init];
    _orderNameLabel.textColor = colorWithLightGray;
    _orderNameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [self addSubview:_orderNameLabel];
    [_orderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_orderImageView.mas_centerY);
        make.left.equalTo(_orderImageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-120);
    }];
    

}

- (void)setModel:(OrderModel *)model
{
    _model = model;
    [_orderImageView sd_setImageWithURL:[NSURL URLWithString:model.allianceImg] placeholderImage:[UIImage imageNamed:@""]];
    _orderNameLabel.text = model.allianceName;
    if (![self.detailType isEqualToString:@"1"]) {
        switch (model.type.intValue)
        {
            case 0:
                _orderTypeLabel.text = @"待支付";
                break;
            case 1:
                _orderTypeLabel.text = @"待参与";
                break;
            case 2:
                _orderTypeLabel.text = @"已完成";
                break;
            case 3:
                _orderTypeLabel.text = @"退款中";
                break;
            case 4:
                _orderTypeLabel.text = @"已退款";
                break;
            case 5:
                _orderTypeLabel.text = @"退款中";
                break;
        }
    }
   
}
@end
