//
//  WaitPaidViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//
//待付款 订单详情
#import "WaitPaidViewController.h"
#import "GoodsPlaceView.h"//收货人信息:地址 电话 姓名
#import "GoodsDetailView.h"//商品详情
#import "DeliveryWayView.h"//配送方式
#import "IntegralView.h"//青币购
#import "TotalPrice.h"//合计多少钱
#import "LDPayItemView.h"//支付视图
#import "OrderDetailHeaderView.h"//订单头部视图
#import "OrderDetailBottomView.h"//订单底部View
#import "GoodsCommentViewController.h"//商品评论
#import "AllOfficePurchaseDetailModel.h"
#import "ResultViewController.h"
#import <Pingpp.h>

@interface WaitPaidViewController ()<IntegralViewDelegate,LDPayItemViewDelegate,GoodsPlaceViewDelegate,OrderDetailBottomViewDelegate>
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

@property (nonatomic,strong) AllOfficePurchaseDetailModel * model;

@property (nonatomic,strong) NSString * selectPayWay;

@end

@implementation WaitPaidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviTitle = @"订单详情";
    self.selectPayWay = @"alipay";

    //设置UI
    [self setupUI];
    
    //网络请求
    [self loadDataFromServer];
    
    //设置导航栏
    [self setupNav];
    //接收支付结果的消息
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushViewController:) name:@"paySuccess" object:nil];
    
}
#pragma mark - 设置导航栏
- (void)setupNav{
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"service_green"] highImage:[UIImage imageNamed:@"service_green"] target:self action:@selector(rightBarButtonClick:)];
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
        
        
        [self.orderHeaderView reloadDataWithOrderStatus:@"待付款" orderTime:[NSString stringWithFormat:@"创建时间: %@",self.model.orderDate]];
        //收货人
        [self.placeView reloadDataWithName:[NSString stringWithFormat:@"收货人: %@",self.model.userName] phone:self.model.userPhone place:[NSString stringWithFormat:@"收货地址：%@",self.model.userAddress]];
        
        self.placeView.isShowNewButton = NO;
        //商品信息View
        [self.goodsView reloadDataWithImage:self.model.commodityImg name:self.model.commodityName rule:self.model.commodityValue price:self.model.commodityPrice count:[NSString stringWithFormat:@"x%@",self.model.commodityCount]];
        
        
        //运费
        [self.deliveryView reloadDataWithLetfTitle:@"运费:" rightTitle:[NSString stringWithFormat:@"￥%@",self.model.freight] lineTopColor:LDEEPaddingColor lineBottomColor:kClearColor];
        
        //青币
        //青币
        NSString * detailString = [NSString stringWithFormat:@"￥%@(%@青币)",self.model.pointPrice,self.model.point];
        [self.integralView reloadDataWithAttributedTextLetfTitle:@"青币抵扣" rightTitle:detailString lineTopColor:kClearColor lineBottomColor:LDEEPaddingColor];
        self.integralView.userInteractionEnabled = NO;
        
        //合计
        NSString * totalString = [NSString stringWithFormat:@"￥%@(含运费￥%@)",self.model.totalPrice,self.model.freight];
        [self.totalPrice reloadDataWithLeftText:@"合计:" rightText:totalString lineTopColor:LDEFPaddingColor lineBottomColor:kClearColor];
        
        //底部订单
        NSArray * orderNumber = @[self.model.orderNumber,self.model.orderDate];
        NSArray * titleArry = @[@"订单单号：",@"下单时间："];
        [self.orderBottomView reloadDataWithTitleArry:titleArry WithOrderNumber:orderNumber];
        
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
//    self.orderHeaderView.backgroundColor = kBlueColor;
    [self.container addSubview:self.orderHeaderView];
    //订单地址信息
    self.placeView = [[GoodsPlaceView alloc] initWithFrame:CGRectMake(0, placeViewY, kScreenW, placeViewH)];
    self.placeView.delegate = self;
    self.placeView.arrowImageView.hidden = YES;
    self.placeView.bottomImageView.hidden = YES;
    [self.container addSubview:self.placeView];
    
    //商品View
    self.goodsView = [[GoodsDetailView alloc] initWithFrame:CGRectMake(0, placeViewH + placeViewY - self.placeView.bottomImageView.height - LDVPadding, kScreenW, goodsViewH)];
    self.goodsView.backgroundColor = colorWithTable;
    [self.container addSubview:self.goodsView];
    //青币购
//    self.integralView =[[DeliveryWayView alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + placeViewY, kScreenW, scoreitemViewH)];
//    [self.container addSubview:self.integralView];
    
    self.integralView = [[DeliveryWayView alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + placeViewY - LDVPadding, kScreenW, itemViewH)];
    [self.container addSubview:self.integralView];
    
    //配送方式
    self.deliveryView = [[DeliveryWayView alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + itemViewH + placeViewY - LDVPadding, kScreenW, itemViewH)];
    [self.container addSubview:self.deliveryView];
    
    //合计总价
    self.totalPrice = [[TotalPrice alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + itemViewH * 2 + placeViewY - LDVPadding, kScreenW, itemViewH)];
    [self.container addSubview:self.totalPrice];
    
    //底部支付视图
    LDPayItemView * patView = [[LDPayItemView alloc] init];
    patView.titleArry = [NSMutableArray arrayWithArray:@[@"支付宝",@"微信"]];
    [patView showPayItemViewWithY:placeViewH + goodsViewH + itemViewH * 3 + placeViewY];
    [self.container addSubview:patView];
    patView.delegate = self;
    CGFloat maxY = CGRectGetMaxY(patView.frame);
    
    
    self.orderBottomView = [[OrderDetailBottomView alloc] initOrderDetailBottomViewWithY:maxY leftButtonTitle:@"取消订单" rightButtonTitle:@"付款" bottomNumber:4];
    self.orderBottomView.delegate =self;
    [self.container addSubview:self.orderBottomView];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.orderBottomView).offset(YGNaviBarHeight + YGBottomMargin);
    }];
}

#pragma mark - LDPayItemViewDelegate
- (void)payItemViewDidSelectedWitchItem:(NSInteger)itemNumber{
    switch (itemNumber) {
            
        case 0:
        {
            self.selectPayWay = @"alipay";
        }
            break;
            
        case 1:
        {
            self.selectPayWay = @"wx";
        }
            break;
        case 2:
        {
            self.selectPayWay = @"";
        }
            break;
    }
    
}
#pragma mark - GoodsPlaceViewDelegate 地址点击代理事件
- (void)goodsPlaceViewNewerPlaceButtonClick{
    
//    [YGAppTool showToastWithText:@"新建地址"];
    
}

- (void)orderDetailBottomViewCancelBtnClick:(UIButton *)btn
{
    [YGAlertView showAlertWithTitle:@"确认取消订单？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            NSDictionary * parameters =@{
                                         @"orderID":self.OrderID,
                                         };
            [YGNetService YGPOST:@"ProcurementOrderDelete" parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
                [YGAppTool showToastWithText:@"取消订单成功"];
                [self.delegate waitPaidViewControllerWithCancalRow:self.row];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}
- (void)orderDetailBottomViewPayBtnClick:(UIButton *)btn
{
    if(![self loginOrNot])
        return;
    
    if(self.selectPayWay.length >0)
    {
        NSDictionary * parameters =@{
                                     @"userID":YGSingletonMarco.user.userId,
                                     @"isCheck":@"",
                                     @"addressID":@"",
                                     @"channel":self.selectPayWay,
                                     @"orderID":self.OrderID,
                                     };
        __weak typeof(self)Weakself = self;
        
        [YGNetService YGPOST:@"ProcurementOnlineOrder" parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
            
            NSString *charegeString = [responseObject valueForKey:@"charge"];
            
            if (!charegeString.length)
            {
                ResultViewController *controller = [[ResultViewController alloc] init];
                controller.pageType =  ResultPageTypeSubmitResult;
                controller.earnPoints = [[responseObject valueForKey:@"getPoint"] intValue];
                [self.navigationController pushViewController:controller animated:YES];
            }
            else
            {
                [Pingpp createPayment:responseObject[@"charge"] viewController:Weakself appURLScheme:@"qingyouhui" withCompletion:^(NSString *result, PingppError *error){
                    if ([result isEqualToString:@"success"])
                    {
                        if([self.selectPayWay isEqualToString:@"alipay"])
                        {
                            //支付宝
                            ResultViewController *controller = [[ResultViewController alloc] init];
                            controller.pageType =  ResultPageTypeSubmitResult;
                            [self.navigationController pushViewController:controller animated:YES];
                        }
                        NSLog(@"success");
                    } else {
                        if (error.code == PingppErrWxNotInstalled) {
                            [YGAppTool showToastWithText:@"请安装微信客户端"];
                        }
                        NSLog(@"PingppError: code=%lu msg=%@", error.code, [error getMsg]);
                    }
                }];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }else
    {
        NSDictionary * parameters =@{
                                     @"userID":YGSingletonMarco.user.userId,
                                     };
        [YGNetService YGPOST:@"ProcurementOfflineOrder" parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
            [YGAppTool showToastWithText:@"线下支付成功"];
            ResultViewController *controller = [[ResultViewController alloc] init];
            controller.pageType =  ResultPageTypeOfflinePayResult;
            [self.navigationController pushViewController:controller animated:YES];
        } failure:^(NSError *error) {
            
        }];
    }
    
}
- (void)pushViewController:(NSNotification *)notif
{
    NSString *state = notif.userInfo[@"successOrNot"];
    
    if ([state isEqualToString:@"1"])
    {
        if([self.selectPayWay isEqualToString:@"alipay"])
        {
            //支付宝
            ResultViewController *controller = [[ResultViewController alloc] init];
            controller.pageType =  ResultPageTypeSubmitResult;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if([self.selectPayWay isEqualToString:@"wx"])
        {
            //微信
            ResultViewController *controller = [[ResultViewController alloc] init];
            controller.pageType =  ResultPageTypeSubmitResult;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
        [YGAppTool showToastWithText:@"购买成功"];
    }
    else
    {
        [YGAppTool showToastWithText:@"购买失败"];
    }
}
#pragma mark - IntegralViewDelegate 青币点击代理事件
- (void)integralViewRightButtonDidClick{
    
    [YGAppTool showToastWithText:@"青币点击"];
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

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
