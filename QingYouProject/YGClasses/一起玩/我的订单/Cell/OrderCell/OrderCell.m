//
//  OrderCell.m
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell
{
    UIView * _baseView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth*0.32*0.5+20)];
    _baseView.backgroundColor = colorWithTable;
    [self.contentView addSubview:_baseView];
    
    _orderGoodsImageView = [[UIImageView alloc] init];
    _orderGoodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    _orderGoodsImageView.layer.cornerRadius = 5;
    _orderGoodsImageView.clipsToBounds = YES;
    [_baseView addSubview:_orderGoodsImageView];
    [_orderGoodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseView.mas_left).offset(12.5);
        make.top.equalTo(_baseView.mas_top).offset(10);
        make.bottom.equalTo(_baseView.mas_bottom).offset(-10);
        make.width.offset(YGScreenWidth*0.32);
//        make.height.offset(YGScreenWidth*0.32*0.5);
    }];
    
    _orderGoodsNameLabel = [[UILabel alloc] init];
    _orderGoodsNameLabel.textColor = colorWithBlack;
    _orderGoodsNameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [_baseView addSubview:_orderGoodsNameLabel];
    [_orderGoodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderGoodsImageView.mas_right).offset(10);
        make.top.equalTo(_orderGoodsImageView.mas_top).offset(4);
        make.right.mas_equalTo(_baseView.mas_right).mas_offset(-10);
    }];
    
    _orderGoodsDatelabel = [[UILabel alloc] init];
    _orderGoodsDatelabel.textColor = colorWithDeepGray;
    _orderGoodsDatelabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_baseView addSubview:_orderGoodsDatelabel];
    [_orderGoodsDatelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderGoodsNameLabel.mas_left);
        make.top.equalTo(_orderGoodsNameLabel.mas_bottom).offset(7);
        make.right.mas_equalTo(_baseView.mas_right).mas_offset(-10);
    }];
    
    _orderGoodsAddressLabel = [[UILabel alloc] init];
    _orderGoodsAddressLabel.textColor = colorWithDeepGray;
    _orderGoodsAddressLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_baseView addSubview:_orderGoodsAddressLabel];
    [_orderGoodsAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderGoodsNameLabel.mas_left);
        make.top.equalTo(_orderGoodsDatelabel.mas_bottom).offset(6);
        make.right.mas_equalTo(_baseView.mas_right).mas_offset(-10);
    }];
    
    _orderGoodsTypeLabel = [[UILabel alloc] init];
    _orderGoodsTypeLabel.textColor = colorWithBlack;
    _orderGoodsTypeLabel.text = @"报名费";
    _orderGoodsTypeLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [self.contentView addSubview:_orderGoodsTypeLabel];
    [_orderGoodsTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12.5);
        make.top.equalTo(_baseView.mas_bottom).offset(10);
    }];
    
    _orderGoodsPriceLabel = [[UILabel alloc] init];
    _orderGoodsPriceLabel.textColor = colorWithBlack;
    _orderGoodsPriceLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [self.contentView addSubview:_orderGoodsPriceLabel];
    [_orderGoodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12.5);
        make.centerY.equalTo(_orderGoodsTypeLabel.mas_centerY);
    }];
    
    _orderGoodsNumLabel = [[UILabel alloc] init];
    _orderGoodsNumLabel.textColor = colorWithBlack;
    _orderGoodsNumLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [self.contentView addSubview:_orderGoodsNumLabel];
    [_orderGoodsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_orderGoodsPriceLabel.mas_left).offset(-15);
        make.centerY.equalTo(_orderGoodsTypeLabel.mas_centerY);
    }];
}

- (void)setModel:(OrderModel *)model
{
    _model = model;
    [_orderGoodsImageView sd_setImageWithURL:[NSURL URLWithString:model.activityImg] placeholderImage:YGDefaultImgTwo_One];
    _orderGoodsNameLabel.text = model.activityName;
    _orderGoodsDatelabel.text = [NSString stringWithFormat:@"%@开始",_model.activityBeginTime];
    _orderGoodsAddressLabel.text = model.activityAddress;
    _orderGoodsPriceLabel.text = [NSString stringWithFormat:@"%.2f",model.price.floatValue];
    if(model.number)
    {
        _orderGoodsNumLabel.text = [NSString stringWithFormat:@"x%@",model.count];
    }
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
