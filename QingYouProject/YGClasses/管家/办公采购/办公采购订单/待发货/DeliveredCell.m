//
//  DeliveredCell.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "DeliveredCell.h"
#import "DeliveryWayView.h"
#import "GoodsDetailView.h"//商品详情
#import "DeliveryWayView.h"//配送方式
#import "IntegralView.h"//青币购
#import "TotalPrice.h"//合计多少钱
#import "LDPayItemView.h"//支付视图
#import "AllOfficePurchaseModel.h"//订单模型
@interface DeliveredCell ()
/** 订单号,订单状态  */
@property (nonatomic,strong) DeliveryWayView * orderNumberAndStaus;
/** 商品详情  */
@property (nonatomic,strong) GoodsDetailView * goodsDetailView;
/** 合计多少钱  */
@property (nonatomic,strong) TotalPrice * priceView;
/** 底部视图  */
@property (nonatomic,strong) UIView * bottomView;
@end


@implementation DeliveredCell

- (void)setModel:(AllOfficePurchaseModel *)model{
    
    _model = model;
    
    //订单编号
    [self.orderNumberAndStaus reloadDataWithLetfTitle:[NSString stringWithFormat:@"订单编号: %@",model.orderNumber] rightTitle:model.orderStatus leftColor:LD9ATextColor rightColor:LDFFTextColor];
    
    //商品信息
    [self.goodsDetailView reloadDataWithImage:model.commodityImg name:model.commodityName rule:[NSString stringWithFormat:@"%@",model.commodityValueName] price:model.commodityPrice count:[NSString stringWithFormat:@"x%@",model.commodityCount]];
    
    //合计总价
    NSString * totalString = [NSString stringWithFormat:@"￥%@(含运费￥%@)",model.totalPrice,model.freight];
    [self.priceView reloadDataWithLeftText:@"合计:" rightText:totalString lineTopColor:LDEFPaddingColor lineBottomColor:LDEFPaddingColor];
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
    [self.contentView addSubview:lineTop];
    
    //订单号,订单状态
    self.orderNumberAndStaus = [[DeliveryWayView alloc] initWithFrame:CGRectMake(0, 10, kScreenW, 4 * LDVPadding)];
    [self.contentView addSubview:self.orderNumberAndStaus];
    //商品View
    self.goodsDetailView = [[GoodsDetailView alloc] initWithFrame:CGRectMake(0, 5 * LDVPadding, kScreenW, 10 * LDVPadding)];
    [self.contentView addSubview:self.goodsDetailView];
    
    //合计总价
    self.priceView = [[TotalPrice alloc] initWithFrame:CGRectMake(0, 15 * LDVPadding, kScreenW, 4 * LDVPadding)];
    [self.contentView addSubview:self.priceView];
    
    //底部视图
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 19 * LDVPadding, kScreenW, 4 * LDVPadding)];
    //    self.bottomView.backgroundColor = kBlueColor;
    [self.contentView addSubview:self.bottomView];
    
    
    UIButton * chargebackButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:@"申请退单" selectedTitle:@"申请退单" normalTitleColor:LD16TextColor selectedTitleColor:LD16TextColor backGroundColor:kWhiteColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:12];
    
    [chargebackButton addTarget:self action:@selector(chargebackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:chargebackButton];
    
    
    [chargebackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- LDHPadding);
        make.top.offset(8);
        make.bottom.offset(-8);
        make.width.offset([UILabel calculateWidthWithString:@"申请退单" textFont:LDFont(12) numerOfLines:1].width + 30);
    }];
    
    
    
    
    
    
    //假数据
    lineTop.backgroundColor = LDEEPaddingColor;
    //商品信息View
    self.goodsDetailView.backgroundColor = colorWithTable;
    chargebackButton.layer.borderWidth = 1;
    chargebackButton.layer.cornerRadius = 12;
    chargebackButton.layer.masksToBounds = YES;
    chargebackButton.layer.borderColor = colorWithLine.CGColor;
  
}
#pragma mark - 申请退单点击事件
- (void)chargebackButtonClick:(UIButton *)chargebackButton{
    [self.delegate deliveredCellReturnWithRow:self.row];
}

#pragma mark - 刷新数据
- (void)reloadData{

}

@end
