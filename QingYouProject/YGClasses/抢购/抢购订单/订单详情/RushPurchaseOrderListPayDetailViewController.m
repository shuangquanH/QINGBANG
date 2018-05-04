//
//  RushPurchaseOrderListPayDetailViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RushPurchaseOrderListPayDetailViewController.h"
#import <Pingpp.h>
#import "GoodsPlaceView.h"//收货人信息:地址 电话 姓名
#import "GoodsDetailView.h"//商品详情
#import "DeliveryWayView.h"//配送方式
#import "IntegralView.h"//青币购

#import "TotalPrice.h"//合计多少钱
#import "LDPayItemView.h"//支付视图
#import "OrderDetailHeaderView.h"//订单头部视图
#import "OrderDetailBottomView.h"//订单底部View
#import "GoodsCommentViewController.h"//商品评论
#import "RushPurchaseOrderListModel.h"
#import "ResultViewController.h"
@interface RushPurchaseOrderListPayDetailViewController ()<IntegralViewDelegate,LDPayItemViewDelegate,GoodsPlaceViewDelegate,OrderDetailBottomViewDelegate>
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
//@property (nonatomic,strong) DeliveryWayView * integralView;
@property (nonatomic,strong) IntegralView * integralPayView;

/** 一共多少钱 */
@property (nonatomic,assign) float  allPrice;
@property (nonatomic, strong) UILabel *priceLable;
/** 订单顶部信息 */
@property (nonatomic,strong) OrderDetailHeaderView * orderHeaderView;
/** 订单底部视图 */
@property (nonatomic,strong) OrderDetailBottomView * orderBottomView;

@property (nonatomic,strong) RushPurchaseOrderListModel * model;

@property (nonatomic,strong) NSString * selectPayWay;
@property (nonatomic,strong) NSString * isCheck;//是否使用青币

@end

@implementation RushPurchaseOrderListPayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviTitle = @"订单详情";
    self.selectPayWay = @"alipay";
    self.isCheck = @"0";
    self.allPrice =0.0;
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
    
    [self contactWithCustomerServerWithType:ContactServerRushPurchase button:rightBarButton];
    
}

- (void)loadDataFromServer
{
    NSDictionary *parameters = @{
                                 @"falshsaleOrderId":self.falshsaleOrderId,
                                 };
    NSString *url = REQUEST_getFalshsaleOrder;

    [YGNetService YGPOST:url parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {


        self.model = [RushPurchaseOrderListModel mj_objectWithKeyValues:responseObject];
    
        
        [self.orderHeaderView reloadDataWithOrderStatus:@"待付款" orderTime:[NSString stringWithFormat:@"创建时间: %@",self.model.createDate]];
        //收货人
        [self.placeView reloadDataWithName:[NSString stringWithFormat:@"收货人: %@",self.model.consignee] phone:self.model.phone place:[NSString stringWithFormat:@"收货地址：%@",self.model.address]];
        
        self.placeView.isShowNewButton = NO;
        //商品信息View
        [self.goodsView pushPurchaseReloadDataWithImage:self.model.commodityImg name:self.model.commodityName price:[NSString stringWithFormat:@"¥%@",self.model.unitPrice] count:[NSString stringWithFormat:@"%@ x%@",_model.commoditySizeName,_model.commodityNum]];
        
        //运费
        [self.deliveryView reloadDataWithLetfTitle:@"配送方式" rightTitle:[NSString stringWithFormat:@"快递 ￥%@",self.model.freight] lineTopColor:LDEEPaddingColor lineBottomColor:kClearColor];
        
        //青币
//        NSString * detailString = [NSString stringWithFormat:@"￥%.2f(%.2f青币)",self.model.pointToMony,self.model.point];
//        [self.integralView reloadDataWithAttributedTextLetfTitle:@"青币购支付" rightTitle:detailString lineTopColor:kClearColor lineBottomColor:LDEEPaddingColor];
//        self.integralView.userInteractionEnabled = NO;
        
        
        NSString * detailString = [NSString stringWithFormat:@"(可用%.0f青币抵￥%.2f)",self.model.point,self.model.pointToMony];
        [self.integralPayView reloadDataWithLetfTitle:@"青币购支付" detailTitle:detailString lineTopColor:LDEEPaddingColor lineBottomColor:kClearColor];
        
        //合计
//        NSString * totalString = [NSString stringWithFormat:@"￥%@(含运费￥%@)",self.model.totalPrice,self.model.freight];
//        [self.totalPrice reloadDataWithLeftText:@"共1件商品 合计:" rightText:totalString lineTopColor:LDEFPaddingColor lineBottomColor:kClearColor];
        
        
//        NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",@"共计10件商品  合计：￥258(含运费￥20)"]];
//
//        NSRange redRange = NSMakeRange([[noteStr string]rangeOfString:@"￥258"].location, [[noteStr string]rangeOfString:@"￥258"].length);
//        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:redRange];
//
//        [noteStr addAttribute:NSForegroundColorAttributeName value:LDFFTextColor range:redRange];
//
//        [_priceLable setAttributedText:noteStr];
        
        NSString * commodityTotal  =_model.commodityNum;

        NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共计%@件商品  合计：￥%@(含运费￥%@)",commodityTotal,_model.totalPrice,_model.freight]];
        
        NSRange redRange = NSMakeRange([[noteStr string]rangeOfString:_model.totalPrice].location, [[noteStr string]rangeOfString:_model.totalPrice].length);
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:redRange];
        
        [noteStr addAttribute:NSForegroundColorAttributeName value:LDFFTextColor range:redRange];
        
        [_priceLable setAttributedText:noteStr];
        
        self.allPrice = [commodityTotal floatValue];

        
        //底部订单
        NSArray * orderNumber = @[self.model.orderNum,self.model.createDate];
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
    [self.container addSubview:self.orderHeaderView];
   
    //订单地址信息
    self.placeView = [[GoodsPlaceView alloc] initWithFrame:CGRectMake(0, placeViewY, kScreenW, placeViewH)];
    self.placeView.delegate = self;
    self.placeView.arrowImageView.hidden = YES;
    self.placeView.bottomImageView.hidden = YES;
    [self.container addSubview:self.placeView];
    
    //商品View
    self.goodsView = [[GoodsDetailView alloc] initWithFrame:CGRectMake(0, placeViewH + placeViewY - LDVPadding, kScreenW, goodsViewH)];
    [self.container addSubview:self.goodsView];
    self.goodsView.backgroundColor = colorWithTable;

    //青币购
    //    self.integralView =[[DeliveryWayView alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + placeViewY, kScreenW, scoreitemViewH)];
    //    [self.container addSubview:self.integralView];
    
    //配送方式
    self.deliveryView = [[DeliveryWayView alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH  + placeViewY- LDVPadding, kScreenW, itemViewH)];
    [self.container addSubview:self.deliveryView];
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.deliveryView.y + self.deliveryView.height, YGScreenWidth, 1)];
    line.backgroundColor = colorWithLine;
    [self.container addSubview:line];
    
//    self.integralView = [[DeliveryWayView alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + placeViewY + itemViewH- LDVPadding, kScreenW, itemViewH)];
//    [self.container addSubview:self.integralView];
    //青币购
    self.integralPayView = [[IntegralView alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + placeViewY + itemViewH- LDVPadding, kScreenW, itemViewH)];
    self.integralPayView.delegate = self;
    [self.container addSubview:self.integralPayView];
    
    UILabel * lineTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, self.integralPayView.y + self.integralPayView.height, YGScreenWidth, 1)];
    lineTwo.backgroundColor = colorWithLine;
    [self.container addSubview:lineTwo];
    
    //合计总价
//    self.totalPrice = [[TotalPrice alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + itemViewH * 2 + placeViewY, kScreenW, itemViewH)];
//    [self.container addSubview:self.totalPrice];
    
    _priceLable = [[UILabel alloc] initWithFrame:CGRectMake(LDVPadding, placeViewH + goodsViewH + itemViewH * 2 + placeViewY, YGScreenWidth - 2 * LDVPadding - LDVPadding, itemViewH)];
    _priceLable.font = LDFont(12);
    _priceLable.textAlignment =NSTextAlignmentRight;
    [self.container addSubview:_priceLable];
    
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
            NSDictionary * parameters =@{@"falshsaleOrderId":self.falshsaleOrderId};
            [YGNetService YGPOST:REQUEST_cancelFalshsaleOrder parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
                [YGAppTool showToastWithText:@"取消订单成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}
- (void)orderDetailBottomViewPayBtnClick:(UIButton *)btn
{
    
    if(self.selectPayWay.length >0)
    {
        NSDictionary * parameters =@{
//                                     @"userID":YGSingletonMarco.user.userId,
                                     @"useIntegral":self.isCheck,
                                     @"payType":self.selectPayWay,
                                     @"falshsaleOrderId":self.falshsaleOrderId,
                                     };
        __weak typeof(self)Weakself = self;
        
        [YGNetService YGPOST:REQUEST_continueFalshsaleOrder parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
            
            [Pingpp createPayment:responseObject[@"charge"] viewController:Weakself appURLScheme:@"qingyouhui" withCompletion:^(NSString *result, PingppError *error){
                if ([result isEqualToString:@"success"])
                {
                    if([self.selectPayWay isEqualToString:@"alipay"])
                    {
                        //支付宝
                        ResultViewController *controller = [[ResultViewController alloc] init];
                        controller.pageType =  ResultPageTypeSubmitPurchsePayResult;
                        controller.earnPoints = _model.getPoint;
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
            controller.pageType =  ResultPageTypeSubmitPurchsePayResult;
            controller.earnPoints = _model.getPoint;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if([self.selectPayWay isEqualToString:@"wx"])
        {
            //微信
            ResultViewController *controller = [[ResultViewController alloc] init];
            controller.pageType =  ResultPageTypeSubmitPurchsePayResult;
            controller.earnPoints = _model.getPoint;
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

#pragma mark - IntegralViewDelegate 青币点击代理事件
- (void)integralViewRightButtonDidClick:(UIButton *)coverButton {
    
    float  price = 0.0;
    //    coverButton.selected = !coverButton.selected;
    
    if (coverButton.selected) {
        //总价 - 青币
        price = [self.model.totalPrice floatValue] - self.model.pointToMony;
        self.isCheck = @"1";
    }else{
        self.isCheck = @"0";
        price = [self.model.totalPrice floatValue];
    }
    
    
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共计%@件商品  合计：￥%.2f(含运费￥%@)",_model.commodityNum,price,_model.freight]];
    
//    NSRange redRange = NSMakeRange([[noteStr string]rangeOfString:price].location, [[noteStr string]rangeOfString:_model.commodityNum].length);
//    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:redRange];
    
//    [noteStr addAttribute:NSForegroundColorAttributeName value:LDFFTextColor range:redRange];
//
    [_priceLable setAttributedText:noteStr];
    
}

@end

