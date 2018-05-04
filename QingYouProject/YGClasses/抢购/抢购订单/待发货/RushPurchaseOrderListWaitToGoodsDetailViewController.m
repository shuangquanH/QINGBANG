//
//  RushPurchaseOrderListWaitToGoodsDetailViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RushPurchaseOrderListWaitToGoodsDetailViewController.h"
#import "GoodsPlaceView.h"//收货人信息:地址 电话 姓名
#import "GoodsDetailView.h"//商品详情
#import "DeliveryWayView.h"//配送方式
#import "IntegralView.h"//青币购
#import "TotalPrice.h"//合计多少钱
#import "OrderDetailHeaderView.h"//订单头部视图
#import "OrderDetailBottomView.h"//订单底部View
#import "RushPurchaseOrderListModel.h"
#import "RushPurchaseOrderRefundViewController.h"


@interface RushPurchaseOrderListWaitToGoodsDetailViewController ()<IntegralViewDelegate,GoodsPlaceViewDelegate,OrderDetailBottomViewDelegate,RushPurchaseOrderRefundViewControllerDelegate>
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
//@property (nonatomic,strong) TotalPrice * totalPrice;
@property (nonatomic, strong) UILabel *priceLable;
/** 订单顶部信息 */
@property (nonatomic,strong) OrderDetailHeaderView * orderHeaderView;
/** 订单底部视图 */
@property (nonatomic,strong) OrderDetailBottomView * orderBottomView;
@property (nonatomic, strong) RushPurchaseOrderListModel *model;
@end

@implementation RushPurchaseOrderListWaitToGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviTitle = @"订单详情";
    
    //设置导航栏
    [self setupNav];
    //设置UI
    [self setupUI];
    //网络请求
    [self loadDataFromServer];

}
#pragma mark - 设置导航栏
- (void)setupNav{
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"service_green"] highImage:[UIImage imageNamed:@"service_green"] target:self action:@selector(rightBarButtonClick:)];
}
#pragma mark - 导航栏右侧按钮点击
- (void)rightBarButtonClick:(UIButton *)rightBarButton
{
    [self contactWithCustomerServerWithType:ContactServerRushPurchase button:rightBarButton];
}

- (void)loadDataFromServer
{
    NSDictionary *parameters = @{
                                 @"falshsaleOrderId":self.OrderID,
                                 };
 
    
    
    [YGNetService YGPOST:REQUEST_getFalshsaleOrder parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        self.model = [RushPurchaseOrderListModel mj_objectWithKeyValues:responseObject];
        
        switch (self.status) {
            case 1:
            {
                [self.orderHeaderView reloadDataWithOrderStatus:@"待发货" orderTime:[NSString stringWithFormat:@"创建时间: %@",self.model.createDate]];
//                [self.orderHeaderView reloadDataWithOrderStatus:@"待发货" orderTime:@""];

                //青币
                NSString * detailString = [NSString stringWithFormat:@"￥%@(%@青币)",self.model.integralPrice,self.model.useIntegral];
                [self.integralView reloadDataWithAttributedTextLetfTitle:@"青币抵扣" rightTitle:detailString lineTopColor:kClearColor lineBottomColor:LDEEPaddingColor];
                self.integralView.userInteractionEnabled = NO;
                //底部订单
                NSArray * orderNumber = @[self.model.orderNum,self.model.createDate,self.model.payDate];
                NSArray * titleArry = @[@"订单单号：",@"下单时间：",@"支付时间："];
                
                [self.orderBottomView reloadDataWithTitleArry:titleArry WithOrderNumber:orderNumber];
                
            }
                break;
            case 4:
            {
                [self.orderHeaderView reloadDataWithOrderStatus:@"退款中" orderTime:[NSString stringWithFormat:@"创建时间: %@",self.model.createDate]];
                //底部订单
                NSArray * orderNumber = @[self.model.orderNum,self.model.createDate,self.model.refundDate];
                NSArray * titleArry = @[@"订单单号：",@"下单时间：",@"退款时间："];
                
                [self.orderBottomView reloadDataWithTitleArry:titleArry WithOrderNumber:orderNumber];
            }
                break;
            case 5:
            {
                [self.orderHeaderView reloadDataWithOrderStatus:@"退款成功" orderTime:[NSString stringWithFormat:@"创建时间: %@",self.model.createDate]];
                //底部订单
                NSArray * orderNumber = @[self.model.orderNum,self.model.createDate,self.model.refundDate,@"退款成功"];
                NSArray * titleArry = @[@"订单单号：",@"下单时间：",@"退款时间：",@"退款成功："];
                
                [self.orderBottomView reloadDataWithTitleArry:titleArry WithOrderNumber:orderNumber];
                
            }
                break;
            case 6:
            {
                [self.orderHeaderView reloadDataWithOrderStatus:@"退款失败" orderTime:[NSString stringWithFormat:@"创建时间: %@",self.model.createDate]];
                //底部订单
                NSArray * orderNumber = @[self.model.orderNum,self.model.createDate];
                NSArray * titleArry = @[@"订单单号：",@"下单时间："];
                [self.orderBottomView reloadDataWithTitleArry:titleArry WithOrderNumber:orderNumber];
            }
                break;
        }
        
        //收货人
        [self.placeView reloadDataWithName:[NSString stringWithFormat:@"收货人: %@",self.model.consignee] phone:self.model.phone place:[NSString stringWithFormat:@"收货地址：%@",self.model.address]];
        
        self.placeView.isShowNewButton = NO;
        //商品信息View
//        [self.goodsView reloadDataWithImage:self.model.commodityImg name:self.model.commodityName rule:self.model.commoditySizeName price:self.model.totalPrice count:[NSString stringWithFormat:@"x%@",self.model.commodityNum]];
        //商品信息
        [self.goodsView pushPurchaseReloadDataWithImage:_model.commodityImg name:_model.commodityName price:[NSString stringWithFormat:@"¥%@",_model.unitPrice] count:_model.commoditySizeName];
        //运费
        [self.deliveryView reloadDataWithLetfTitle:@"配送方式" rightTitle:[NSString stringWithFormat:@"快递￥%@",self.model.freight] lineTopColor:LDEEPaddingColor lineBottomColor:kClearColor];
        
        //合计
//        NSString * totalString = [NSString stringWithFormat:@"￥%@(含运费￥%@)",self.model.totalPrice,self.model.freight];
//        [self.totalPrice reloadDataWithLeftText:@"合计:" rightText:totalString lineTopColor:LDEFPaddingColor lineBottomColor:kClearColor];
        
        NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共计%@件商品  合计：￥%@(含运费￥%@)",_model.commodityNum,_model.totalPrice,_model.freight]];
        
        NSRange redRange = NSMakeRange([[noteStr string]rangeOfString:_model.totalPrice].location, [[noteStr string]rangeOfString:_model.totalPrice].length);
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:redRange];
        
        [noteStr addAttribute:NSForegroundColorAttributeName value:LDFFTextColor range:redRange];
        
        [_priceLable setAttributedText:noteStr];
        
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
    self.goodsView.backgroundColor = colorWithTable;
    
    
//    if (self.status == 2) {//待发货
//        //青币购
//        self.integralView =[[DeliveryWayView alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + placeViewY - LDVPadding, kScreenW, scoreitemViewH)];
//        [self.container addSubview:self.integralView];
//    }else{//退款
//
//        scoreitemViewH = 0;
//    }
    
    //配送方式
    self.deliveryView = [[DeliveryWayView alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + placeViewY - LDVPadding , kScreenW, itemViewH)];
    [self.container addSubview:self.deliveryView];
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.deliveryView.y + self.deliveryView.height, YGScreenWidth, 1)];
    line.backgroundColor = colorWithLine;
    [self.container addSubview:line];
    //合计总价
//    self.totalPrice = [[TotalPrice alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + itemViewH + scoreitemViewH + placeViewY - LDVPadding, kScreenW, itemViewH)];
//    [self.container addSubview:self.totalPrice];
    
    _priceLable = [[UILabel alloc] initWithFrame:CGRectMake(LDVPadding, placeViewH + goodsViewH + itemViewH + placeViewY -LDVPadding, YGScreenWidth - 2 * LDVPadding - LDVPadding, itemViewH)];
    _priceLable.font = LDFont(12);
    _priceLable.textAlignment =NSTextAlignmentRight;
    [self.container addSubview:_priceLable];
    
    //订单状态
    NSString * leftButtonTitle = @"";
    NSString * rightButtonTitle = @"";
    if (self.status == 1) {//待发货
        leftButtonTitle = @"申请退单";
        //rightButtonTitle = @"确认收货";
    }else  if (self.status == 4) {
        leftButtonTitle = @"";
    }else{//退款
        leftButtonTitle = @"删除订单";
        //rightButtonTitle = @"";
        
    }
    CGFloat maxY = CGRectGetMaxY(_priceLable.frame);
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
        case 1://待发货  - 申请退单
        {
            RushPurchaseOrderRefundViewController *vc = [[RushPurchaseOrderRefundViewController alloc] init];
            vc.model = _model;
            vc.row = 0;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5://退款成功
        {
            [self deleteOrder];
        }
            break;
        case 6://退款失败
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
                                         @"falshsaleOrderId":self.OrderID,
                                         };
            [YGNetService YGPOST:REQUEST_deleteFalshsaleOrder parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
                [YGAppTool showToastWithText:@"删除订单成功"];
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

