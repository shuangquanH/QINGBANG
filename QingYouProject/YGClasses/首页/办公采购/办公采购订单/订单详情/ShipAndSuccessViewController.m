//
//  ShipAndSuccessViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//已发货.交易成功 订单详情

#import "ShipAndSuccessViewController.h"
#import "GoodsPlaceView.h"//收货人信息:地址 电话 姓名
#import "GoodsDetailView.h"//商品详情
#import "DeliveryWayView.h"//配送方式
#import "IntegralView.h"//青币购
#import "TotalPrice.h"//合计多少钱
#import "OrderDetailHeaderView.h"//订单头部视图
#import "OrderDetailBottomView.h"//订单底部View
#import "AllOfficePurchaseDetailModel.h"
#import "OfficePurchaseRefundViewController.h"
#import "GoodsCommentViewController.h"



@interface ShipAndSuccessViewController ()<IntegralViewDelegate,GoodsPlaceViewDelegate,OrderDetailBottomViewDelegate>
/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** ScrollowView容器View  */
@property (nonatomic,strong) UIView * container;
/** 地址View  */
@property (nonatomic,strong) GoodsPlaceView * placeView;
/** 商品View  */
@property (nonatomic,strong) GoodsDetailView * goodsView;
/**  运费  */
@property (nonatomic,strong) DeliveryWayView * deliveryPrice;
/** 配送方式 快递  */
@property (nonatomic,strong) DeliveryWayView * deliveryView;
/** 青币购  */
@property (nonatomic,strong) DeliveryWayView * integralView;
/** 一共多少钱 */
@property (nonatomic,strong) TotalPrice * totalPrice;
/** 订单顶部信息 */
@property (nonatomic,strong) OrderDetailHeaderView * orderHeaderView;
/** 订单底部视图 */
@property (nonatomic,strong) OrderDetailBottomView * orderBottomView;
@property (nonatomic,strong) AllOfficePurchaseDetailModel * model;

@end


@implementation ShipAndSuccessViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviTitle = @"订单详情";
    
    //设置UI
    [self setupUI];
    
    //网络请求
    [self loadDataFromServer];
    //设置导航栏
    [self setupNav];
}
#pragma mark - 设置导航栏
- (void)setupNav{
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem =     [self createBarbuttonWithNormalImageName:@"service_green" selectedImageName:@"service_green" selector:@selector(rightBarButtonClick:)];
}
#pragma mark - 导航栏右侧按钮点击
- (void)rightBarButtonClick:(UIButton *)rightBarButton{
    
    [self contactWithCustomerServerWithType:ContactServerOfficePurchase button:rightBarButton];
}
#pragma mark - 网络请求

- (void)loadDataFromServer
{
    NSDictionary *parameters = @{
                                 @"orderID":self.OrderID,
                                 };
    NSString *url = @"ProcurementOrderDetail";
    
    NSLog(@"self.OrderID -- %@",self.OrderID);
    [YGNetService YGPOST:url parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        self.model = [AllOfficePurchaseDetailModel mj_objectWithKeyValues:responseObject[@"orderDetail"]];
        
        
        //收货人
        [self.placeView reloadDataWithName:[NSString stringWithFormat:@"收货人: %@",self.model.userName] phone:self.model.userPhone place:[NSString stringWithFormat:@"收货地址：%@",self.model.userAddress]];
        
        self.placeView.isShowNewButton = NO;
        //商品信息View
        [self.goodsView reloadDataWithImage:self.model.commodityImg name:self.model.commodityName rule:self.model.commodityValue price:self.model.commodityPrice count:[NSString stringWithFormat:@"x%@",self.model.commodityCount]];
        
        
        //运费
        [self.deliveryPrice reloadDataWithLetfTitle:@"运费:" rightTitle:[NSString stringWithFormat:@"￥%@",self.model.freight] lineTopColor:LDEEPaddingColor lineBottomColor:kClearColor];
        
        //快递
        [self.deliveryView reloadDataWithLetfTitle:[NSString stringWithFormat:@"%@：%@",self.model.expressName,self.model.expressNumber] rightTitle:@"" lineTopColor:kClearColor lineBottomColor:LDEEPaddingColor];
        
        //运费
//        [self.deliveryView reloadDataWithLetfTitle:@"运费:" rightTitle:[NSString stringWithFormat:@"￥%@",self.model.freight] lineTopColor:LDEEPaddingColor lineBottomColor:kClearColor];
        
        //合计
        NSString * totalString = [NSString stringWithFormat:@"￥%@(含运费￥%@)",self.model.totalPrice,self.model.freight];
        [self.totalPrice reloadDataWithLeftText:@"合计:" rightText:totalString lineTopColor:LDEFPaddingColor lineBottomColor:kClearColor];

        switch (self.status) {
            case 3:
                {
                    [self.orderHeaderView reloadDataWithOrderStatus:@"已发货" orderTime:[NSString stringWithFormat:@"创建时间: %@",self.model.orderDate]];

                    //底部订单
                    NSArray * orderNumber = @[self.model.orderNumber,self.model.orderDate,self.model.payDate,self.model.deliverDate];
                    NSArray * titleArry = @[@"订单单号：",@"下单时间：",@"支付时间：",@"发货时间："];
                    [self.orderBottomView reloadDataWithTitleArry:titleArry WithOrderNumber:orderNumber];
                }
                break;
            case 4:
            {
                [self.orderHeaderView reloadDataWithOrderStatus:@"交易成功" orderTime:[NSString stringWithFormat:@"创建时间: %@",self.model.orderDate]];

                //底部订单
                NSArray * orderNumber = @[self.model.orderNumber,self.model.orderDate,self.model.payDate,self.model.deliverDate,self.model.confirmDate];
                NSArray * titleArry = @[@"订单单号：",@"下单时间：",@"支付时间：",@"发货时间：",@"确认时间："];
                [self.orderBottomView reloadDataWithTitleArry:titleArry WithOrderNumber:orderNumber];
            }
                break;
                
            default:
                break;
        }
                
       
        
        
    } failure:nil];
}

#pragma mark - 设置UI界面
- (void)setupUI{
    
    [self.view addSubview:self.backScrollowView];
    CGFloat placeViewY = 75;
    CGFloat placeViewH = 90;
    CGFloat goodsViewH = 100;
    CGFloat itemViewH = 40;
    
    //订单顶部信息
    self.orderHeaderView = [[OrderDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, placeViewY)];
    //self.orderHeaderView.backgroundColor = kBlueColor;
    [self.container addSubview:self.orderHeaderView];
    
    //快递
    self.deliveryView = [[DeliveryWayView alloc] initWithFrame:CGRectMake(0, placeViewY, kScreenW, itemViewH)];
    [self.container addSubview:self.deliveryView];
    
    //订单地址信息
    self.placeView = [[GoodsPlaceView alloc] initWithFrame:CGRectMake(0, placeViewY + itemViewH, kScreenW, placeViewH)];
    self.placeView.delegate = self;
    self.placeView.arrowImageView.hidden = YES;
    self.placeView.bottomImageView.hidden = YES;
    [self.container addSubview:self.placeView];
    
    //商品View
    self.goodsView = [[GoodsDetailView alloc] initWithFrame:CGRectMake(0, placeViewH + placeViewY + itemViewH - self.placeView.bottomImageView.height -LDVPadding, kScreenW, goodsViewH)];
    [self.container addSubview:self.goodsView];
    self.goodsView.backgroundColor = colorWithTable;
    //青币购
//    self.integralView = [[DeliveryWayView alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + placeViewY + itemViewH, kScreenW, itemViewH)];
//    [self.container addSubview:self.integralView];
    
    //运费
    self.deliveryPrice = [[DeliveryWayView alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + itemViewH + placeViewY -LDVPadding, kScreenW, itemViewH)];
    [self.container addSubview:self.deliveryPrice];
    
    //合计总价
    self.totalPrice = [[TotalPrice alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + itemViewH * 2 + placeViewY -LDVPadding, kScreenW, itemViewH)];
    [self.container addSubview:self.totalPrice];
    
    //订单状态
    NSString * leftButtonTitle = @"";
    NSString * rightButtonTitle = @"";
    
    if (self.status == 4) {//交易成功
        leftButtonTitle = @"删除订单";
        rightButtonTitle = @"";

    }else{//已发货
        
        leftButtonTitle = @"申请退单";
        rightButtonTitle = @"确认收货";

    }
    
    CGFloat maxY = CGRectGetMaxY(self.totalPrice.frame);
    self.orderBottomView = [[OrderDetailBottomView alloc] initOrderDetailBottomViewWithY:maxY leftButtonTitle:leftButtonTitle rightButtonTitle:rightButtonTitle bottomNumber:5];
    [self.container addSubview:self.orderBottomView];
    self.orderBottomView.delegate = self;
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.orderBottomView).offset(YGNaviBarHeight + YGBottomMargin);
    }];
}

- (void)orderDetailBottomViewCancelBtnClick:(UIButton *)btn
{
    OfficePurchaseRefundViewController * refundView =[[OfficePurchaseRefundViewController alloc]init];
    refundView.model = self.model;
    refundView.row = self.row;
    [self.navigationController pushViewController:refundView animated:YES];
}
- (void)orderDetailBottomViewPayBtnClick:(UIButton *)btn
{
    
    [YGAlertView showAlertWithTitle:@"是否确认收货？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:@"ProcurementTakeOrder" parameters:@{@"orderID":_model.orderID} showLoadingView:YES scrollView:nil success:^(id responseObject) {
                
                GoodsCommentViewController * vc = [[GoodsCommentViewController alloc] init];
                vc.commodityID =_model.commodityID;
                [self.navigationController pushViewController:vc animated:YES];
                
            } failure:nil];
        }
    }];
}
#pragma mark - GoodsPlaceViewDelegate 地址点击代理事件
- (void)goodsPlaceViewNewerPlaceButtonClick{
    
//    [YGAppTool showToastWithText:@"新建地址"];
}


#pragma mark - IntegralViewDelegate 青币点击代理事件
- (void)integralViewRightButtonDidClick{
    
//    [YGAppTool showToastWithText:@"青币点击"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView *)backScrollowView{
    if (!_backScrollowView) {
        _backScrollowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - YGNaviBarHeight - YGStatusBarHeight)];
        _backScrollowView.backgroundColor = kWhiteColor;
        _backScrollowView.alwaysBounceVertical = YES;
        //容器视图
        self.container = [[UIView alloc] init];
        self.container.backgroundColor = kWhiteColor;
        [self.backScrollowView addSubview:self.container];
        [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.offset(0);
            make.width.equalTo(_backScrollowView);
        }];
        
    }
    return _backScrollowView;
}


@end
