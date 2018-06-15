//
//  TransactionSuccessCell.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "TransactionSuccessCell.h"
#import "DeliveryWayView.h"
#import "GoodsPlaceView.h"//收货人信息:地址 电话 姓名
#import "GoodsDetailView.h"//商品详情
#import "DeliveryWayView.h"//配送方式
#import "IntegralView.h"//青币购
#import "TotalPrice.h"//合计多少钱
#import "AllOfficePurchaseModel.h"//订单模型

@interface TransactionSuccessCell ()
/** 订单号,订单状态  */
@property (nonatomic,strong) DeliveryWayView * orderNumberAndStaus;
/** 商品详情  */
@property (nonatomic,strong) GoodsDetailView * goodsDetailView;
/** 合计多少钱  */
@property (nonatomic,strong) TotalPrice * priceView;
/** 底部视图  */
@property (nonatomic,strong) UIView * bottomView;

@end

@implementation TransactionSuccessCell

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
    [self.contentView addSubview:self.bottomView];
    UIButton * receiveButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:@"删除订单" selectedTitle:@"删除订单" normalTitleColor:colorWithBlack selectedTitleColor:colorWithBlack backGroundColor:kWhiteColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:12];
    [receiveButton addTarget:self action:@selector(receiveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:receiveButton];
    
    [receiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- LDHPadding);
        make.top.offset(8);
        make.bottom.offset(-8);
        make.width.offset([UILabel calculateWidthWithString:@"删除订单" textFont:LDFont(12) numerOfLines:1].width + 30);
    }];
    
    //假数据
    lineTop.backgroundColor =  LDEEPaddingColor;
    //商品信息View
    self.goodsDetailView.backgroundColor = colorWithTable;
    receiveButton.layer.borderWidth = 1;
    receiveButton.layer.cornerRadius = 12;
    receiveButton.layer.masksToBounds = YES;
    receiveButton.layer.borderColor = colorWithLine.CGColor;
    
}
#pragma mark - 确认收货点击事件
- (void)receiveButtonClick:(UIButton *)receiveButton{
    
    [YGAlertView showAlertWithTitle:@"确认删除订单？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            NSDictionary * parameters =@{
                                         @"orderID":_model.orderID,
                                         };
            [YGNetService YGPOST:@"ProcurementOrderDelete" parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
                [YGAppTool showToastWithText:@"删除订单成功"];
         
                [self.delegate transactionSuccessCellDeleteWithRow:self.row];
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}

#pragma mark - 申请退单点击事件
- (void)chargebackButtonClick:(UIButton *)chargebackButton{
    [self.delegate transactionSuccessCellDeleteWithRow:self.row];
}

@end
