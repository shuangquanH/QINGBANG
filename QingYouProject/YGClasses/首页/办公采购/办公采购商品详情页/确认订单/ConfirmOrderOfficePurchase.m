//
//  ConfirmOrderOfficePurchase.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ConfirmOrderOfficePurchase.h"
#import "GoodsPlaceView.h"//收货人信息:地址 电话 姓名
#import "GoodsDetailView.h"//商品详情
#import "DeliveryWayView.h"//配送方式
#import "IntegralView.h"//青币购
#import "TotalPrice.h"//合计多少钱
#import "LDPayItemView.h"//支付视图
#import "OfficePurchSureOrderModel.h"
#import <Pingpp.h>
#import "ResultViewController.h"
#import "ManageMailPostViewController.h"


@interface ConfirmOrderOfficePurchase ()<IntegralViewDelegate,LDPayItemViewDelegate,GoodsPlaceViewDelegate,ManageMailPostViewControllerDelegate>
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
@property (nonatomic,strong) IntegralView * integralView;
/** 一共多少钱 */
@property (nonatomic,strong) TotalPrice * totalPrice;

@property (nonatomic,strong) NSString * selectPayWay;
@property (nonatomic,strong) NSString * isCheck;//是否使用青币

@property (nonatomic,assign) float allPrice;//合计金额
@property (nonatomic,strong) NSString * commodityFreight;//运费
@property (nonatomic,strong) NSString * addressID;
@property (nonatomic,strong) NSString * getPoint;


@end

@implementation ConfirmOrderOfficePurchase

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviTitle = @"确认订单";
     self.selectPayWay = @"alipay";
    self.allPrice =0.0;
    self.isCheck = @"0";
    _addressID =@"";
    self.getPoint =@"0";
    //设置UI
    [self setupUI];
    
    //网络请求
    [self sendRequest];
    //接收支付结果的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushViewController:) name:@"paySuccess" object:nil];
    
}
#pragma mark - 网络请求
- (void)sendRequest{
    
    if([self.model.address count])
    {
        [self.placeView reloadDataWithName:[NSString stringWithFormat:@"收货人: %@",self.model.address[@"addressName"]] phone:[NSString stringWithFormat:@"%@",self.model.address[@"addressPhone"]] place:[NSString stringWithFormat:@"收货地址: %@",self.model.address[@"address"]]];
        self.placeView.isShowNewButton = NO;
        self.addressID = self.model.address[@"addressID"];
    }
    else
        self.placeView.isShowNewButton = YES;

            
    NSDictionary * dict = self.model.commodity;
    [self.goodsView reloadDataWithImage:[NSString stringWithFormat:@"%@",dict[@"commodityImg"]] name:dict[@"commodityName"] rule:dict[@"commodityValueName"] price:dict[@"commodityPrice"] count:[NSString stringWithFormat:@"x%@",dict[@"commodityCount"]]];
    
    [self.deliveryView reloadDataWithLetfTitle:@"运费:" rightTitle:[NSString stringWithFormat:@"¥%@",dict[@"commodityFreight"]] lineTopColor:LDEEPaddingColor lineBottomColor:kClearColor];
    
    NSString * detailString = [NSString stringWithFormat:@"可用%@青币抵￥%@",self.model.point,self.model.pointPrice];
    
    [self.integralView reloadDataWithLetfTitle:@"青币购支付" detailTitle:detailString lineTopColor:LDEEPaddingColor lineBottomColor:kClearColor];
    
    NSString * commodityTotal  = dict[@"commodityTotal"];
    self.commodityFreight = dict[@"commodityFreight"];
    
    NSString * totalString = [NSString stringWithFormat:@"￥%@(含运费￥%@)",[NSString stringWithFormat:@"%.2f",[commodityTotal floatValue]],self.commodityFreight];
    
    [self.totalPrice reloadDataWithLeftText:@"合计:" rightText:totalString lineTopColor:LDEFPaddingColor lineBottomColor:kClearColor];
    
    self.allPrice = [commodityTotal floatValue];
}

- (void)setupUI{
    
    [self.view addSubview:self.backScrollowView];
    CGFloat placeViewH = 90;
    CGFloat goodsViewH = 100;
    CGFloat itemViewH = 40;
    
    self.placeView = [[GoodsPlaceView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, placeViewH)];
    self.placeView.delegate = self;
    [self.placeView lableWithThick];
    [self.container addSubview:self.placeView];
    
    //商品View
    self.goodsView = [[GoodsDetailView alloc] initWithFrame:CGRectMake(0, placeViewH, kScreenW, goodsViewH)];
    [self.container addSubview:self.goodsView];
    //青币购
    self.integralView = [[IntegralView alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH , kScreenW, itemViewH)];
    self.integralView.delegate = self;
    [self.container addSubview:self.integralView];
    
    //配送方式
    self.deliveryView = [[DeliveryWayView alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + itemViewH, kScreenW, itemViewH)];
    [self.container addSubview:self.deliveryView];
 
    //合计总价
    self.totalPrice = [[TotalPrice alloc] initWithFrame:CGRectMake(0, placeViewH + goodsViewH + itemViewH * 2, kScreenW, itemViewH)];
    [self.container addSubview:self.totalPrice];
    
    //底部支付视图
    LDPayItemView * patView = [[LDPayItemView alloc] init];
    [patView showPayItemViewWithY:placeViewH + goodsViewH + itemViewH * 3];
    [self.container addSubview:patView];
    patView.delegate = self;
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(patView).offset(YGNaviBarHeight + YGBottomMargin);
    }];
    
    //底部确认支付按钮
    UIButton * payButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:@"确认支付" selectedTitle:@"确认支付" normalTitleColor:kWhiteColor selectedTitleColor:kWhiteColor backGroundColor:LDMainColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:15];
    [payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    payButton.frame = CGRectMake(0, kScreenH - (YGNaviBarHeight + YGBottomMargin) - YGNaviBarHeight - YGStatusBarHeight, kScreenW, YGNaviBarHeight + YGBottomMargin);
    [payButton setTitleEdgeInsets:UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0 )];
    [self.view addSubview:payButton];
    
    
}
#pragma mark - 确认支付点击事件
- (void)payButtonClick:(UIButton *)payButton{
    if(![self loginOrNot])
        return;
   if (!_addressID.length) {
       [YGAppTool showToastWithText:@"请输入收货地址"];
       return;
   }
        
    if(self.selectPayWay.length >0)
    {
        NSDictionary * parameters =@{
                                     @"userID":YGSingletonMarco.user.userId,
                                     @"isCheck":self.isCheck,
                                     @"addressID":self.addressID,
                                     @"channel":self.selectPayWay,
                                     @"orderID":@"",
                                     };
        __weak typeof(self)Weakself = self;
        
        [YGNetService YGPOST:@"ProcurementOnlineOrder" parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
            
            NSString *charegeString = [responseObject valueForKey:@"charge"];
            
            if (!charegeString.length)
            {
                ResultViewController *controller = [[ResultViewController alloc] init];
                controller.pageType =  ResultPageTypeSubmitOfficeResult;
                controller.earnPoints = [[responseObject valueForKey:@"getPoint"] intValue];
                [self.navigationController pushViewController:controller animated:YES];
            }
            else
            {
                self.getPoint =  responseObject[@"getPoint"];
                [Pingpp createPayment:responseObject[@"charge"] viewController:Weakself appURLScheme:@"qingyouhui" withCompletion:^(NSString *result, PingppError *error){
                    if ([result isEqualToString:@"success"])
                    {
                        if([self.selectPayWay isEqualToString:@"alipay"])
                        {
                            //支付宝
                            ResultViewController *controller = [[ResultViewController alloc] init];
                            controller.pageType =  ResultPageTypeSubmitOfficeResult;
                            controller.earnPoints = [self.getPoint intValue];
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
                                     @"addressID":self.addressID,
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
#pragma mark - LDPayItemViewDelegate
- (void)payItemViewDidSelectedWitchItem:(NSInteger)itemNumber{
    self.integralView.userInteractionEnabled = YES;

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
     
            self.isCheck = @"0";
        
            NSString * totalString = [NSString stringWithFormat:@"￥%@(含运费￥%@)",[NSString stringWithFormat:@"%.2f",self.allPrice],self.commodityFreight];
            
            [self.totalPrice reloadDataWithLeftText:@"合计:" rightText:totalString lineTopColor:LDEFPaddingColor lineBottomColor:kClearColor];
            self.integralView.rightButton.selected = NO;
            self.integralView.userInteractionEnabled = NO;
            [YGAlertView showAlertWithTitle:@"线下支付不支持青币购支付" buttonTitlesArray:@[@"确定"] buttonColorsArray:@[colorWithBlack] handler:^(NSInteger buttonIndex) {
                
            }];
        }
            break;
    }
    
}
#pragma mark - GoodsPlaceViewDelegate 地址点击代理事件
- (void)goodsPlaceViewNewerPlaceButtonClick{
    
    ManageMailPostViewController * mailPost =[[ManageMailPostViewController alloc]init];
    mailPost.shippingAddressViewControllerdelegate =self;
    [self.navigationController pushViewController:mailPost animated:YES];

}
-(void)passModel:(ManageMailPostModel *)model
{
    [self.placeView reloadDataWithName:[NSString stringWithFormat:@"收货人: %@",model.name] phone:[NSString stringWithFormat:@"%@",model.phone] place:[NSString stringWithFormat:@"收货地址: %@%@%@%@",model.prov,model.city,model.dist,model.address]];
    self.addressID = model.ID;
    self.placeView.isShowNewButton = NO;
   
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
            controller.pageType =  ResultPageTypeSubmitOfficeResult;
            controller.earnPoints = [self.getPoint intValue];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if([self.selectPayWay isEqualToString:@"wx"])
        {
            //微信
            ResultViewController *controller = [[ResultViewController alloc] init];
            controller.pageType =  ResultPageTypeSubmitOfficeResult;
            controller.earnPoints = [self.getPoint intValue];
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
- (void)integralViewRightButtonDidClick:(UIButton *)coverButton {
    
    float  price = 0.0;
    
    if (coverButton.selected) {
        //总价 - 青币
        price = self.allPrice - [self.model.pointPrice floatValue];
        self.isCheck = @"1";
    }else{
        self.isCheck = @"0";
        price = self.allPrice;
    }
    
    NSString * totalString = [NSString stringWithFormat:@"￥%@(含运费￥%@)",[NSString stringWithFormat:@"%.2f",price],self.commodityFreight];
 
    [self.totalPrice reloadDataWithLeftText:@"合计:" rightText:totalString lineTopColor:LDEFPaddingColor lineBottomColor:kClearColor];
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
    LDLogFunc
}
@end
