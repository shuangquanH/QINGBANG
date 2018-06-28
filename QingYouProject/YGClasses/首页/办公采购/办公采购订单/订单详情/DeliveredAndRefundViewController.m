//
//  DeliveredAndRefundViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//退款 和 待发货 订单详情

#import "DeliveredAndRefundViewController.h"
#import "GoodsPlaceView.h"//收货人信息:地址 电话 姓名
#import "GoodsDetailView.h"//商品详情
#import "DeliveryWayView.h"//配送方式
#import "IntegralView.h"//青币购
#import "TotalPrice.h"//合计多少钱
#import "OrderDetailHeaderView.h"//订单头部视图
#import "OrderDetailBottomView.h"//订单底部View
#import "AllOfficePurchaseDetailModel.h"
#import "OfficePurchaseRefundViewController.h"




@interface DeliveredAndRefundViewController ()<IntegralViewDelegate,GoodsPlaceViewDelegate,OrderDetailBottomViewDelegate,OfficePurchaseRefundViewControllerDelegate>
/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** ScrollowView容器View  */
@property (nonatomic,strong) UIView * container;
/** 地址View  */
@property (nonatomic,strong) GoodsPlaceView * placeView;
/** 商品View  */
@property (nonatomic,strong) GoodsDetailView * goodsView;
/** 配送方式  */
@property (nonatomic,strong) DeliveryWayView * deliveryView;
/** 青币购  */
@property (nonatomic,strong) DeliveryWayView * integralView;
/** 一共多少钱 */
@property (nonatomic,strong) TotalPrice * totalPrice;
/** 订单顶部信息 */
@property (nonatomic,strong) OrderDetailHeaderView * orderHeaderView;
/** 订单底部视图 */
@property (nonatomic,strong) OrderDetailBottomView * orderBottomView;
@property (nonatomic, strong) AllOfficePurchaseDetailModel *model;
@end

@implementation DeliveredAndRefundViewController

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
    self.navigationItem.rightBarButtonItem =  [self createBarbuttonWithNormalImageName:@"service_green" selectedImageName:@"service_green" selector:@selector(rightBarButtonClick:)];
}
#pragma mark - 导航栏右侧按钮点击
- (void)rightBarButtonClick:(UIButton *)rightBarButton{
    
    [self contactWithCustomerServerWithType:ContactServerOfficePurchase button:rightBarButton];

}

- (void)loadDataFromServer
{
    NSDictionary *parameters = @{
                                 @"orderID":self.OrderID,
                                 };
    NSString *url = @"ProcurementOrderDetail";
    
    
    [YGNetService YGPOST:url parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        self.model = [AllOfficePurchaseDetailModel mj_objectWithKeyValues:responseObject[@"orderDetail"]];
        
        switch (self.status) {
            case 2:
            {
                [self.orderHeaderView reloadDataWithOrderStatus:@"待发货" orderTime:[NSString stringWithFormat:@"创建时间: %@",self.model.orderDate]];
                //青币
                NSString * detailString = [NSString stringWithFormat:@"￥%@(%@青币)",self.model.pointPrice,self.model.point];
                [self.integralView reloadDataWithAttributedTextLetfTitle:@"青币抵扣" rightTitle:detailString lineTopColor:kClearColor lineBottomColor:LDEEPaddingColor];
                self.integralView.userInteractionEnabled = NO;
                //底部订单
                NSArray * orderNumber = @[self.model.orderNumber,self.model.orderDate,self.model.payDate];
                NSArray * titleArry = @[@"订单单号：",@"下单时间：",@"支付时间："];
                
                [self.orderBottomView reloadDataWithTitleArry:titleArry WithOrderNumber:orderNumber];

            }
                break;
            case 5:
            {
                [self.orderHeaderView reloadDataWithOrderStatus:@"退款中" orderTime:[NSString stringWithFormat:@"创建时间: %@",self.model.orderDate]];
                //底部订单
                NSArray * orderNumber = @[self.model.orderNumber,self.model.orderDate,self.model.refundDate];
                NSArray * titleArry = @[@"订单单号：",@"下单时间：",@"退款时间："];
                
                [self.orderBottomView reloadDataWithTitleArry:titleArry WithOrderNumber:orderNumber];
            }
                break;
            case 6:
            {
                [self.orderHeaderView reloadDataWithOrderStatus:@"退款成功" orderTime:[NSString stringWithFormat:@"创建时间: %@",self.model.orderDate]];
                //底部订单
                NSArray * orderNumber = @[self.model.orderNumber,self.model.orderDate,self.model.refundDate,self.model.refundSuccessDate];
                NSArray * titleArry = @[@"订单单号：",@"下单时间：",@"退款时间：",@"退款成功："];
                
                [self.orderBottomView reloadDataWithTitleArry:titleArry WithOrderNumber:orderNumber];
                
            }
                break;
            case 7:
            {
                [self.orderHeaderView reloadDataWithOrderStatus:@"退款失败" orderTime:[NSString stringWithFormat:@"创建时间: %@",self.model.orderDate]];
                //底部订单
                NSArray * orderNumber = @[self.model.orderNumber,self.model.orderDate];
                NSArray * titleArry = @[@"订单单号：",@"下单时间："];
                [self.orderBottomView reloadDataWithTitleArry:titleArry WithOrderNumber:orderNumber];
            }
                break;
        }
        
        //收货人
        [self.placeView reloadDataWithName:[NSString stringWithFormat:@"收货人: %@",self.model.userName] phone:self.model.userPhone place:[NSString stringWithFormat:@"收货地址：%@",self.model.userAddress]];
        
        self.placeView.isShowNewButton = NO;
        //商品信息View
        [self.goodsView reloadDataWithImage:self.model.commodityImg name:self.model.commodityName rule:self.model.commodityValue price:self.model.commodityPrice count:[NSString stringWithFormat:@"x%@",self.model.commodityCount]];
        
        //运费
        [self.deliveryView reloadDataWithLetfTitle:@"运费:" rightTitle:[NSString stringWithFormat:@"￥%@",self.model.freight] lineTopColor:LDEEPaddingColor lineBottomColor:kClearColor];
        
        //合计
        NSString * totalString = [NSString stringWithFormat:@"￥%@(含运费￥%@)",self.model.totalPrice,self.model.freight];
        [self.totalPrice reloadDataWithLeftText:@"合计:" rightText:totalString lineTopColor:LDEFPaddingColor lineBottomColor:kClearColor];
        
 
        
    } failure:nil];
}

#pragma mark - 设置UI界面
- (void)setupUI{
    
    [self.view addSubview:self.backScrollowView];
    CGFloat placeViewY = 75;
    CGFloat placeViewH = 90;
    CGFloat goodsViewH = 100;
    CGFloat itemViewH = 40;
    CGFloat scoreitemViewH = 40;

    //订单顶部信息
    self.orderHeaderView = [[OrderDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, placeViewY)];
    //self.orderHeaderView.backgroundColor = kBlueColor;
    [self.container addSubview:self.orderHeaderView];
    //订单地址信息
    self.placeView = [[GoodsPlaceView alloc] initWithFrame:CGRectMake(0, placeViewY, kScreenW, placeViewH)];
    self.placeView.delegate = self;
    [self.container addSubview:self.placeView];
    self.placeView.arrowImageView.hidden = YES;
    self.placeView.bottomImageView.hidden = YES;
    
    //商品View
    self.goodsView = [[GoodsDetailView alloc] initWithFrame:CGRectMake(0, placeViewH + placeViewY -self.placeView.bottomImageView.height - LDVPadding, kScreenW, goodsViewH)];
    [self.container addSubview:self.goodsView];
    self.goodsView.backgroundColor =colorWithTable;
    
    if (self.status == 2) {//待发货
        //青币购
        self.integralView =[[DeliveryWayView alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + placeViewY - LDVPadding, kScreenW, scoreitemViewH)];
        [self.container addSubview:self.integralView];
    }else{//退款
  
        scoreitemViewH = 0;
    }
    
    //配送方式
    self.deliveryView = [[DeliveryWayView alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + scoreitemViewH + placeViewY - LDVPadding, kScreenW, itemViewH)];
    [self.container addSubview:self.deliveryView];
    
    //合计总价
    self.totalPrice = [[TotalPrice alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + itemViewH + scoreitemViewH + placeViewY - LDVPadding, kScreenW, itemViewH)];
    [self.container addSubview:self.totalPrice];
    
    //订单状态
    NSString * leftButtonTitle = @"";
    NSString * rightButtonTitle = @"";
    if (self.status == 2) {//待发货
        leftButtonTitle = @"申请退单";
        //rightButtonTitle = @"确认收货";
    }else  if (self.status == 5) {
        leftButtonTitle = @"";
    }else{//退款
        leftButtonTitle = @"删除订单";
        //rightButtonTitle = @"";
        
    }
    CGFloat maxY = CGRectGetMaxY(self.totalPrice.frame);
    self.orderBottomView = [[OrderDetailBottomView alloc] initOrderDetailBottomViewWithY:maxY leftButtonTitle:leftButtonTitle rightButtonTitle:rightButtonTitle bottomNumber:4];
    self.orderBottomView.delegate = self;
    [self.container addSubview:self.orderBottomView];
    

    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.orderBottomView).offset(YGNaviBarHeight + YGBottomMargin);
    }];
}

- (void)orderDetailBottomViewCancelBtnClick:(UIButton *)btn
{
    switch (self.status) {
        case 2://待发货  - 申请退单
        {
            OfficePurchaseRefundViewController * refundView =[[OfficePurchaseRefundViewController alloc]init];
            refundView.model = self.model;
            refundView.row = self.row;
            [self.navigationController pushViewController:refundView animated:YES];
        }
            break;
        case 6://退款成功
        {
            [self deleteOrder];
        }
            break;
        case 7://退款失败
        {
            [self deleteOrder];
        }
            break;
    }
   
}

-(void)deleteOrder
{
    [YGAlertView showAlertWithTitle:@"确认删除订单？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            NSDictionary * parameters =@{
                                         @"orderID":self.model.orderID,
                                         };
            [YGNetService YGPOST:@"ProcurementOrderDelete" parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
                [YGAppTool showToastWithText:@"删除订单成功"];
                [self.delegate deliveredAndRefundViewControllerDeleteWithRow:self.row];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                
            }];
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
