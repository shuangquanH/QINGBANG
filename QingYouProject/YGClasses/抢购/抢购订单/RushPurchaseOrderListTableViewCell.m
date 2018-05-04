//
//  RushPurchaseOrderListTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RushPurchaseOrderListTableViewCell.h"
#import "GoodsPlaceView.h"//收货人信息:地址 电话 姓名
#import "GoodsDetailView.h"//商品详情
#import "DeliveryWayView.h"
#import "TotalPrice.h"
@interface RushPurchaseOrderListTableViewCell ()
{
    DeliveryWayView * _orderNumberAndStaus;
    GoodsDetailView * _goodsDetailView;
    UILabel * _priceLable;
    UIView *_bottomView;
    UIButton * _receiveButton;
    UIButton * _chargebackButton;
    UILabel *_line;
}
@end

@implementation RushPurchaseOrderListTableViewCell

- (void)setModel:(RushPurchaseOrderListModel *)model{

    _model = model;

    //商品信息
      [_goodsDetailView pushPurchaseReloadDataWithImage:model.commodityImg name:model.commodityName price:[NSString stringWithFormat:@"%@",model.unitPrice] count:[NSString stringWithFormat:@"x%@",model.commodityNum]];

    //合计总价
//    NSString * totalString = [NSString stringWithFormat:@"￥%@(含运费￥%@)",model.totalPrice,model.freight];
//    [_priceView reloadDataWithLeftText:@"合计:" rightText:totalString lineTopColor:LDEFPaddingColor lineBottomColor:LDEFPaddingColor];

    if([_model.refundsType isEqualToString:@"4"])
        _chargebackButton.hidden =YES;
    else
        _chargebackButton.hidden =NO;
}

- (void)setModelValeFalseWithType:(NSInteger )type{
    NSString * typeStr ;
    _bottomView.hidden = NO;
    switch (type) {
        case 0://待付款
        {
            
            typeStr =@"待付款";
            _receiveButton.hidden =NO;
            _chargebackButton.hidden =NO;
            [_receiveButton setTitle:@"付款" forState:UIControlStateNormal];
            [_chargebackButton setTitle:@"取消订单" forState:UIControlStateNormal];
            _receiveButton.frame = CGRectMake(YGScreenWidth - 15 - ([UILabel calculateWidthWithString:_receiveButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 8, ([UILabel calculateWidthWithString:_receiveButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
            _chargebackButton.frame = CGRectMake(YGScreenWidth - 15 - ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30)-_receiveButton.width  -10,  8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);

//            _receiveButton.frame = CGRectMake(YGScreenWidth - 15 - 90, 8, ([UILabel calculateWidthWithString:_receiveButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
            
//            _chargebackButton.frame = CGRectMake(YGScreenWidth - 15 - 90*2  -10,  8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
        }
            break;
        case 1://待发货
        {
            typeStr =@"待发货";
            _receiveButton.hidden =YES;
            _chargebackButton.hidden =NO;
            [_chargebackButton setTitle:@"申请退单" forState:UIControlStateNormal];
            _chargebackButton.frame = CGRectMake(YGScreenWidth - 15 - ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30),  8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);

//            _chargebackButton.frame = CGRectMake(YGScreenWidth - 15 - 90, 8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
        }
            break;
        case 2://已发货
        {
            _receiveButton.hidden =NO;
            _chargebackButton.hidden =NO;
            typeStr =@"已发货";
            
            _receiveButton.frame = CGRectMake(YGScreenWidth - 15 - ([UILabel calculateWidthWithString:_receiveButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 8, ([UILabel calculateWidthWithString:_receiveButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);

            _chargebackButton.frame = CGRectMake(YGScreenWidth - 15 - ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30)-_receiveButton.width  -10,  8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);


//            _receiveButton.frame = CGRectMake(YGScreenWidth - 15 - 90, 8, ([UILabel calculateWidthWithString:_receiveButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
            
//            _chargebackButton.frame = CGRectMake(YGScreenWidth - 15 - 90*2  -10,  8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);

        }
            break;
        case 3://交易成功
        {
            typeStr =@"交易成功";
            _receiveButton.hidden =YES;
            _chargebackButton.hidden =NO;
            [_chargebackButton setTitle:@"删除订单" forState:UIControlStateNormal];

            _chargebackButton.frame = CGRectMake(YGScreenWidth - 15 - ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30),  8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);

//            _chargebackButton.frame = CGRectMake(YGScreenWidth - 15 - 90, 8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
        }
            break;
        case 4://售后退款中
        {
            typeStr =@"退款中";
            _line.hidden =YES;
            _chargebackButton.hidden =YES;
            _receiveButton.hidden =YES;
            _bottomView.hidden = YES;
        }
            break;
        case 5://售后退款成功
        {
            typeStr =@"退款成功";
            _receiveButton.hidden =YES;
            [_chargebackButton setTitle:@"删除订单" forState:UIControlStateNormal];
            
            _chargebackButton.frame = CGRectMake(YGScreenWidth - 15 - ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30),  8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);

//            _chargebackButton.frame = CGRectMake(YGScreenWidth - 15 - 90, 8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
        }
            break;
        case 6://售后退失败
        {
            typeStr =@"退款失败";
            _receiveButton.hidden =YES;
            [_chargebackButton setTitle:@"删除订单" forState:UIControlStateNormal];
            _chargebackButton.frame = CGRectMake(YGScreenWidth - 15 - ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30),  8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);

//            _chargebackButton.frame = CGRectMake(YGScreenWidth - 15 - 90, 8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
        }
            break;
    }
    
    [_orderNumberAndStaus reloadDataWithLetfTitle:[NSString stringWithFormat:@"订单编号: %@",_model.orderNum] rightTitle:typeStr leftColor:LD9ATextColor rightColor:LDFFTextColor];

    //商品信息
    [_goodsDetailView pushPurchaseReloadDataWithImage:_model.commodityImg name:_model.commodityName price:[NSString stringWithFormat:@"¥%@",_model.unitPrice] count:_model.commoditySizeName];
    //合计总价
    
    
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共计%@件商品  合计：￥%@(含运费￥%@)",_model.commodityNum,_model.totalPrice,_model.freight]];
    
    NSRange redRange = NSMakeRange([[noteStr string]rangeOfString:_model.totalPrice].location, [[noteStr string]rangeOfString:_model.totalPrice].length);
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:redRange];
    
    [noteStr addAttribute:NSForegroundColorAttributeName value:LDFFTextColor range:redRange];
    
    [_priceLable setAttributedText:noteStr];
    
  
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
    //合计总价
    _priceLable = [[UILabel alloc] initWithFrame:CGRectMake(LDVPadding, 15 * LDVPadding, YGScreenWidth - 2 * LDVPadding, 4 * LDVPadding)];
    _priceLable.font = LDFont(12);
    _priceLable.textAlignment =NSTextAlignmentRight;
    [self.contentView addSubview:_priceLable];

    _line = [[UILabel alloc]initWithFrame:CGRectMake(0, _priceLable.y +_priceLable.height , YGScreenWidth, 1)];
    _line.backgroundColor = colorWithLine;
    [self.contentView addSubview:_line];
    
    //底部视图
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 19 * LDVPadding, kScreenW, 4 * LDVPadding)];
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
    
    _chargebackButton = [[UIButton alloc]init];
    [_bottomView addSubview:_chargebackButton];
    [_chargebackButton addTarget:self action:@selector(chargebackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _chargebackButton.layer.borderWidth = 1;
    _chargebackButton.layer.cornerRadius = 12;
    _chargebackButton.layer.masksToBounds = YES;
    _chargebackButton.layer.borderColor = colorWithLine.CGColor;
    _chargebackButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_chargebackButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [_chargebackButton setTitle:@"申请退单" forState:UIControlStateNormal];

    
    _receiveButton.frame = CGRectMake(YGScreenWidth - 15 - ([UILabel calculateWidthWithString:_receiveButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 8, ([UILabel calculateWidthWithString:_receiveButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);

    _chargebackButton.frame = CGRectMake(YGScreenWidth - 15 - ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30)+_receiveButton.width  -10,  8, ([UILabel calculateWidthWithString:_chargebackButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);

}

-(void)receiveButtonClick:(UIButton *)btn
{
    [self.delegate rushPurchaseOrderListTableViewCellReceiveGoodWithButton:btn withRow:self.row];
}
-(void)chargebackButtonClick:(UIButton *)btn
{
    [self.delegate rushPurchaseOrderListTableViewCellReturnMoneyWithButton:btn withRow:self.row];
}
@end

