//
//  SecondhandReplacementIBoughtTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplacementIBoughtTableViewCell.h"
#import "GoodsPlaceView.h"//收货人信息:地址 电话 姓名
#import "GoodsDetailView.h"//商品详情
#import "DeliveryWayView.h"
#import "TotalPrice.h"
#import "SecondhandReplacementIBoughtModel.h"

@interface SecondhandReplacementIBoughtTableViewCell ()
{
    DeliveryWayView * _orderNumberAndStaus;
    GoodsDetailView * _goodsDetailView;
    UILabel * _priceLable;
    UIView *_bottomView;
    UIButton * _receiveButton;
    UIButton * _chargebackButton;
    UIButton * _logisticsButton;

    UILabel *_line;
}
@end
@implementation SecondhandReplacementIBoughtTableViewCell


- (void)setValeForSellOutWithModel:(SecondhandReplacementIBoughtModel *)model{
    NSString * typeStr = @"";
    NSInteger status = [model.status integerValue];

    switch (status) {
        case 2://待发货
        {
            typeStr =@"待发货";
            _receiveButton.hidden = NO;
            _chargebackButton.hidden =YES;
            _logisticsButton.hidden =YES;
            [_receiveButton setTitle:@"填写物流单号" forState:UIControlStateNormal];
            float w = ([UILabel calculateWidthWithString:_receiveButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30);
            _receiveButton.frame = CGRectMake(YGScreenWidth - 15 - w, 8, w, 24);

        }
            break;
        case 3://已发货
        {
            typeStr =@"待对方确认收货";
            _receiveButton.hidden =YES;
            _chargebackButton.hidden =YES;
            _logisticsButton.hidden =NO;
            [_logisticsButton setTitle:@"查看物流" forState:UIControlStateNormal];
            float w = ([UILabel calculateWidthWithString:_receiveButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30);
            _logisticsButton.frame = CGRectMake(YGScreenWidth - 15 - w, 8, w, 24);

        }
            break;
        case 4://交易成功
        {
            typeStr =@"交易成功";
            _receiveButton.hidden =YES;
            _chargebackButton.hidden =NO;
            _logisticsButton.hidden =NO;
            [_logisticsButton setTitle:@"查看物流" forState:UIControlStateNormal];
            [_chargebackButton setTitle:@"删除订单" forState:UIControlStateNormal];
            float w = ([UILabel calculateWidthWithString:_logisticsButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30);

            _logisticsButton.frame = CGRectMake(YGScreenWidth - 15 - w , 8, w, 24);
            _chargebackButton.frame = CGRectMake(YGScreenWidth - 15 - w *2  -10,  8, w, 24);

        }
            break;
        default:
            break;
    }
    [_orderNumberAndStaus reloadDataWithLetfTitle:[NSString stringWithFormat:@"订单编号: %@",model.orderNum] rightTitle:typeStr leftColor:LD9ATextColor rightColor:LDFFTextColor];
    
    NSString * buyPrice =@"";
    NSInteger  buyWay = [model.buyWay integerValue];
    switch (buyWay) {
        case 1:
        {
            buyPrice = [NSString stringWithFormat:@"%@青币",model.price];
        }
            break;
        case 2:
        {
            buyPrice = [NSString stringWithFormat:@"%@元",model.price];
        }
            break;
            
        default:
            break;
    }
    //商品信息
    [_goodsDetailView pushPurchaseReloadDataWithImage:model.seller name:model.merchandiseId price:buyPrice count:@" "];
}

-(void)setModel:(SecondhandReplacementIBoughtModel *)model
{
    _model =model;
    NSString * typeStr = @"";
    NSInteger status = [model.status integerValue];
    switch (status) {
        case 1://待付款
        {
            typeStr =@"待支付";
            [_receiveButton setTitle:@"立即支付" forState:UIControlStateNormal];
            _chargebackButton.hidden =YES;
            _logisticsButton.hidden =NO;
            _receiveButton.hidden =NO;
            
            [_logisticsButton setTitle:@"删除订单" forState:UIControlStateNormal];
            _logisticsButton.frame = CGRectMake(YGScreenWidth - 15 - 90*2  -10,  8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
        }
            break;
        case 2://待发货
        {
            typeStr =@"待发货";
            _receiveButton.hidden =YES;
            _chargebackButton.hidden =YES;
            _logisticsButton.hidden =YES;
        }
            break;
        case 3://已发货
        {
            typeStr =@"待收货";
            _receiveButton.hidden =NO;
            _chargebackButton.hidden =NO;
            _logisticsButton.hidden =NO;
            [_chargebackButton setTitle:@"申请售后" forState:UIControlStateNormal];
            [_receiveButton setTitle:@"确认收货" forState:UIControlStateNormal];
            [_logisticsButton setTitle:@"查看物流" forState:UIControlStateNormal];
            _logisticsButton.frame = CGRectMake(YGScreenWidth - 15 - 90*2  -10,  8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);

        }
            break;
        case 4://交易成功
        {
            typeStr =@"交易成功";
            _receiveButton.hidden =YES;
            _chargebackButton.hidden =YES;
            _logisticsButton.hidden = NO;
            [_logisticsButton setTitle:@"删除订单" forState:UIControlStateNormal];
            _logisticsButton.frame = CGRectMake(YGScreenWidth - 15 - 90,  8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
        }
            break;
       default:
            break;
    }
    [_orderNumberAndStaus reloadDataWithLetfTitle:[NSString stringWithFormat:@"订单编号: %@",model.orderNum] rightTitle:typeStr leftColor:LD9ATextColor rightColor:LDFFTextColor];
    
    NSString * buyPrice =@"";
    NSInteger  buyWay = [model.buyWay integerValue];
    switch (buyWay) {
        case 1:
        {
            buyPrice = [NSString stringWithFormat:@"应付青币：%@",model.price];
        }
            break;
        case 2:
        {
            buyPrice = [NSString stringWithFormat:@"应付金额：%@元",model.price];
        }
            break;
            
        default:
            break;
    }
    //商品信息
    [_goodsDetailView pushPurchaseReloadDataWithImage:model.seller name:model.merchandiseId price:buyPrice count:@" "];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}
- (void)setupUI{
    //顶部分割线
    UIView * lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, LDVPadding / 2)];
    lineTop.backgroundColor = colorWithLine;
    [self.contentView addSubview:lineTop];
    
    //订单号,订单状态
    _orderNumberAndStaus = [[DeliveryWayView alloc] initWithFrame:CGRectMake(0, 10, kScreenW, 4 * LDVPadding)];
    [self.contentView addSubview:_orderNumberAndStaus];
    //商品View
    _goodsDetailView = [[GoodsDetailView alloc] initWithFrame:CGRectMake(0, 5 * LDVPadding, kScreenW, 10 * LDVPadding)];
    [self.contentView addSubview:_goodsDetailView];
    _goodsDetailView.backgroundColor =colorWithTable;
    
    
    //底部视图
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _goodsDetailView.height + _goodsDetailView.y, kScreenW, 4 * LDVPadding)];
    [self.contentView addSubview:_bottomView];
    
    _receiveButton = [[UIButton alloc]init];
    [_bottomView addSubview:_receiveButton];
    [_receiveButton addTarget:self action:@selector(receiveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _receiveButton.layer.borderWidth = 1;
    _receiveButton.layer.cornerRadius = 12;
    _receiveButton.layer.masksToBounds = YES;
    _receiveButton.layer.borderColor = colorWithMainColor.CGColor;
    _receiveButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_receiveButton setTitle:@"确认收货" forState:UIControlStateNormal];
    [_receiveButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    
    _logisticsButton = [[UIButton alloc]init];
    [_bottomView addSubview:_logisticsButton];
    [_logisticsButton addTarget:self action:@selector(logisticsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _logisticsButton.layer.borderWidth = 1;
    _logisticsButton.layer.cornerRadius = 12;
    _logisticsButton.layer.masksToBounds = YES;
    _logisticsButton.layer.borderColor = colorWithLine.CGColor;
    _logisticsButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_logisticsButton setTitle:@"查看物流" forState:UIControlStateNormal];
    [_logisticsButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    
    _chargebackButton = [[UIButton alloc]init];
    [_bottomView addSubview:_chargebackButton];
    [_chargebackButton addTarget:self action:@selector(chargebackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _chargebackButton.layer.borderWidth = 1;
    _chargebackButton.layer.cornerRadius = 12;
    _chargebackButton.layer.masksToBounds = YES;
    _chargebackButton.layer.borderColor = colorWithLine.CGColor;
    _chargebackButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_chargebackButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [_chargebackButton setTitle:@"申请售后" forState:UIControlStateNormal];
    
    
    _receiveButton.frame = CGRectMake(YGScreenWidth - 15 - 90, 8, ([UILabel calculateWidthWithString:_receiveButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
    
    _logisticsButton.frame = CGRectMake(YGScreenWidth - 15 - 90*2  -10,  8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);

    _chargebackButton.frame = CGRectMake(YGScreenWidth - 15 - 90*3  -20,  8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
    
}

-(void)receiveButtonClick:(UIButton *)btn
{
    [self.delegate secondhandReplacementIBoughtTableViewCellPayButton:btn withRow:self.row];
}
-(void)logisticsButtonClick:(UIButton *)btn
{
    [self.delegate secondhandReplacementIBoughtTableViewCellLogisticsButton:btn withRow:self.row];
}
-(void)chargebackButtonClick:(UIButton *)btn
{
    [self.delegate secondhandReplacementIBoughtTableViewCellCustomerServiceButton:btn withRow:self.row];
}
@end


