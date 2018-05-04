//
//  SecondhandReplacementSubstitutionWaitToGoodsTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplacementSubstitutionWaitToGoodsTableViewCell.h"
#import "GoodsPlaceView.h"//收货人信息:地址 电话 姓名
#import "GoodsDetailView.h"//商品详情
#import "SecondhandReplacementIBoughtModel.h"

@interface SecondhandReplacementSubstitutionWaitToGoodsTableViewCell ()
{
    GoodsDetailView * _goodsDetailView;
    UILabel * _priceLable;
    UIView *_bottomView;
    UIButton * _receiveButton;
    UIButton * _chargebackButton;
    UIButton * _logisticsButton;
    
    UILabel *_line;
    UILabel * _orderNumLable;
    UIButton * _addressBtn;
    UIImageView * _exchangeImage;
}
@end

@implementation SecondhandReplacementSubstitutionWaitToGoodsTableViewCell

-(void)setModel:(SecondhandReplacementIBoughtModel *)model
{
    _model =model;
    _exchangeImage.hidden = YES;
    NSInteger status = [model.status integerValue];

    switch (status) {
        case 1://待支付
        {
            _addressBtn.hidden = YES;
        
            _receiveButton.hidden = NO;
            _chargebackButton.hidden =YES;
            _logisticsButton.hidden =NO;
            [_receiveButton setTitle:@"立即支付" forState:UIControlStateNormal];
            [_logisticsButton setTitle:@"删除订单" forState:UIControlStateNormal];

            _receiveButton.frame = CGRectMake(YGScreenWidth - 15 - 90, 8, ([UILabel calculateWidthWithString:_receiveButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
            [_goodsDetailView pushPurchaseReloadDataWithImage:model.seller name:model.merchandiseId price:[NSString stringWithFormat:@"应付保证金：%@元",model.price] count:@" "];
            _exchangeImage.hidden = NO;

        }
            break;
        case 2://待发货
        {
            _addressBtn.hidden = NO;

            _receiveButton.hidden = YES;
            _chargebackButton.hidden =YES;
            _logisticsButton.hidden =YES;
            
            if([self.relopType isEqualToString:@"1"])
            {
                _addressBtn.userInteractionEnabled =YES;

                if([model.buyWay isEqualToString:@"3"])
                {
                    [_addressBtn setTitle:@"对方收货地址" forState:UIControlStateNormal];
                    CGFloat addressBtnlW = [UILabel calculateWidthWithString:_addressBtn.titleLabel.text textFont:[UIFont systemFontOfSize:YGFontSizeSmallOne] numerOfLines:1].width;
                    _addressBtn.width =addressBtnlW;
                    _addressBtn.x = YGScreenWidth -LDHPadding *2 - _exchangeImage.width - addressBtnlW;
                    _exchangeImage.hidden = NO;

                    NSString * priceStr = [NSString stringWithFormat:@"我方已付保证金：%@元",model.price];
                    [_goodsDetailView pushPurchaseReloadDataWithImage:model.seller name:model.merchandiseId price:priceStr count:@" "];
                }
                else
                {
                    [_addressBtn setTitle:@"平台收货地址" forState:UIControlStateNormal];
                    CGFloat addressBtnlW = [UILabel calculateWidthWithString:_addressBtn.titleLabel.text textFont:[UIFont systemFontOfSize:YGFontSizeSmallOne] numerOfLines:1].width;
                    _addressBtn.width =addressBtnlW;
                    _addressBtn.x = YGScreenWidth -LDHPadding *2 - addressBtnlW;
                    [_goodsDetailView pushPurchaseReloadDataWithImage:model.seller name:model.merchandiseId price:@"" count:@" "];
                }
               
                _receiveButton.hidden = NO;
                float w =([UILabel calculateWidthWithString:@"填写物流单号" textFont:LDFont(12) numerOfLines:1].width + 30);
                
                [_receiveButton setTitle:@"填写物流单号" forState:UIControlStateNormal];
                _receiveButton.frame = CGRectMake(YGScreenWidth - 15 - w, 8, w, 24);
            }
            else
            {
                _exchangeImage.hidden = NO;

                [_addressBtn setTitle:@"待发货" forState:UIControlStateNormal];
                CGFloat addressBtnlW = [UILabel calculateWidthWithString:_addressBtn.titleLabel.text textFont:[UIFont systemFontOfSize:YGFontSizeSmallOne] numerOfLines:1].width;
                _addressBtn.width =addressBtnlW;
                _addressBtn.x = YGScreenWidth -LDHPadding *2 - _exchangeImage.width - addressBtnlW;
                _addressBtn.userInteractionEnabled =NO;
                [_goodsDetailView pushPurchaseReloadDataWithImage:model.seller name:model.merchandiseId price:[NSString stringWithFormat:@"已付：%@元保证金",model.price] count:@" "];
            }
            
        }
            break;
        case 3://待收货
        {
            [_logisticsButton setTitle:@"查看物流" forState:UIControlStateNormal];
            NSString * priceStr = [NSString stringWithFormat:@"我方已付保证金：%@元",model.price];

            if([self.relopType isEqualToString:@"1"])
            {
                _addressBtn.hidden =YES;
                
                _receiveButton.hidden =NO;
                _chargebackButton.hidden =NO;
                _logisticsButton.hidden = NO;
                [_chargebackButton setTitle:@"申请售后" forState:UIControlStateNormal];
                [_receiveButton setTitle:@"确认收货" forState:UIControlStateNormal];
                [_logisticsButton setTitle:@"查看物流" forState:UIControlStateNormal];
                
                if([model.buyWay isEqualToString:@"3"])
                {
                     _exchangeImage.hidden = NO;
                }
                else
                {
                    priceStr = @"平台兜底";
                }
            }
            else
            {
                if([model.buyWay isEqualToString:@"3"])
                {
                     _exchangeImage.hidden = NO;
                }
                else
                {
                    priceStr = @"平台兜底";

                    _addressBtn.hidden = NO;
                    [_addressBtn setTitle:@"平台收货地址" forState:UIControlStateNormal];
                    CGFloat addressBtnlW = [UILabel calculateWidthWithString:_addressBtn.titleLabel.text textFont:[UIFont systemFontOfSize:YGFontSizeSmallOne] numerOfLines:1].width;
                    _addressBtn.width =addressBtnlW;
                    _addressBtn.x = YGScreenWidth - LDHPadding  - addressBtnlW;
                }

                _receiveButton.hidden = YES;
                _chargebackButton.hidden = YES;
                _logisticsButton.hidden = NO;
                
                float w = ([UILabel calculateWidthWithString:@"查看物流" textFont:LDFont(12) numerOfLines:1].width + 30);
                
                [_logisticsButton setTitle:@"查看物流" forState:UIControlStateNormal];
                _logisticsButton.frame = CGRectMake(YGScreenWidth - 15 - w, 8, w, 24);
            }
            [_goodsDetailView pushPurchaseReloadDataWithImage:model.seller name:model.merchandiseId price:priceStr count:@" "];

        }
            break;
        case 4://已完成
        {
            [_addressBtn setTitle:@"交易成功" forState:UIControlStateNormal];
            CGFloat addressBtnlW = [UILabel calculateWidthWithString:_addressBtn.titleLabel.text textFont:[UIFont systemFontOfSize:YGFontSizeSmallOne] numerOfLines:1].width;
            _addressBtn.width =addressBtnlW;
            
            NSString * priceStr = [NSString stringWithFormat:@"对方已付保证金：%@元",model.price];

            if([model.buyWay isEqualToString:@"3"])
            {
                _addressBtn.x = YGScreenWidth -LDHPadding *2 - _exchangeImage.width - addressBtnlW;
                _exchangeImage.hidden = NO;
            }
            else
            {
                priceStr = @"平台兜底";
                _addressBtn.x = YGScreenWidth -LDHPadding *2 - addressBtnlW;
            }
            
            [_logisticsButton setTitle:@"删除订单" forState:UIControlStateNormal];

            
            //商品View
            
            _addressBtn.userInteractionEnabled =NO;
            
            _receiveButton.hidden =YES;
            _chargebackButton.hidden =YES;
            _logisticsButton.hidden = NO;
            _logisticsButton.frame = CGRectMake(YGScreenWidth - 15 - 90, 8, ([UILabel calculateWidthWithString:_logisticsButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);

            [_goodsDetailView pushPurchaseReloadDataWithImage:model.seller name:model.merchandiseId price:[NSString stringWithFormat:@"应付保证金：%@元",model.price] count:@" "];

        }
            break;
        default:
            break;
    }
    _orderNumLable.text =[NSString stringWithFormat:@"订单编号:%@",model.orderNum];

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
    
    CGFloat addressBtnlW = [UILabel calculateWidthWithString:@"对方收货地址" textFont:[UIFont systemFontOfSize:YGFontSizeSmallOne] numerOfLines:1].width;

    _orderNumLable = [UILabel ld_labelWithTextColor:colorWithDeepGray textAlignment:NSTextAlignmentLeft font:LDFont(13) numberOfLines:1];
    [self addSubview:_orderNumLable];
    _orderNumLable.frame =CGRectMake(LDHPadding , lineTop.height + lineTop.y, YGScreenWidth - 4* LDHPadding - 25 - addressBtnlW, 5 * LDVPadding);

    _exchangeImage = [[UIImageView alloc]initWithFrame:CGRectMake(YGScreenWidth - LDHPadding - 20, 19, 20, 20)];
    _exchangeImage.image =[UIImage imageNamed:@"unused_changed_orange"];
    [self addSubview:_exchangeImage];
    
    _addressBtn = [[UIButton alloc]init];
    [_addressBtn setTitle:@"对方收货地址" forState:UIControlStateNormal];
    [_addressBtn addTarget:self action:@selector(addressBtn:) forControlEvents:UIControlEventTouchUpInside];
    _addressBtn.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_addressBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self addSubview:_addressBtn];
    _addressBtn.frame =CGRectMake(YGScreenWidth -LDHPadding *2 - _exchangeImage.width - addressBtnlW, lineTop.height + lineTop.y, addressBtnlW, 5 * LDVPadding);
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
    [self.delegate secondhandReplacementSubstitutionWaitToGoodsTableViewCellPayButton:btn withRow:self.row];
}
-(void)logisticsButtonClick:(UIButton *)btn
{
    [self.delegate secondhandReplacementSubstitutionWaitToGoodsTableViewCellLogisticsButton:btn withRow:self.row];
}
-(void)chargebackButtonClick:(UIButton *)btn
{
    [self.delegate secondhandReplacementSubstitutionWaitToGoodsTableViewCellCustomerServiceButton:btn withRow:self.row];
}
-(void)addressBtn:(UIButton *)btn
{
    [self.delegate secondhandReplacementSubstitutionWaitToGoodsTableViewCelladdressButton:btn withRow:self.row];
}
@end



