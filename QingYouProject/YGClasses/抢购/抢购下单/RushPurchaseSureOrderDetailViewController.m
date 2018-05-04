//
//  RushPurchaseSureOrderDetailViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RushPurchaseSureOrderDetailViewController.h"
#import "GoodsPlaceView.h"//收货人信息:地址 电话 姓名
#import "GoodsDetailView.h"//商品详情
#import "DeliveryWayView.h"//配送方式
#import "IntegralView.h"//青币购
#import "TotalPrice.h"//合计多少钱
#import "LDPayItemView.h"//支付视图
#import <Pingpp.h>
#import "ResultViewController.h"
#import "ManageMailPostViewController.h"

@interface RushPurchaseSureOrderDetailViewController ()<IntegralViewDelegate,LDPayItemViewDelegate,GoodsPlaceViewDelegate,ManageMailPostViewControllerDelegate>
/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** ScrollowView容器View  */
@property (nonatomic,strong) UIView * container;

/** 倒计时View  */
@property (nonatomic,strong) UIView * countDownView;
/** 时间 */
@property (nonatomic,strong) UILabel * timeLabel;

/** 地址View  */
@property (nonatomic,strong) GoodsPlaceView * placeView;
/** 商品View  */
@property (nonatomic,strong) GoodsDetailView * goodsView;
/** 配送方式  */
@property (nonatomic,strong) DeliveryWayView * deliveryView;
/** 青币购  */
@property (nonatomic,strong) IntegralView * integralView;
/** 一共多少钱 */
@property (nonatomic,strong) UILabel * totalPrice;

@property (nonatomic,strong) NSString * selectPayWay;
@property (nonatomic,strong) NSString * isCheck;//是否使用青币

@property (nonatomic,assign) float allPrice;//合计金额
@property (nonatomic,strong) NSString * commodityFreight;//运费
@property (nonatomic,strong) NSString * addressID;


@end

@implementation RushPurchaseSureOrderDetailViewController
{
    NSInteger secondsCountDown;
    NSTimer *_countDownTimer;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;//获取当前的视图控制其
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        //当前视图控制器在栈中，故为push操作
        NSLog(@"push");
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        //当前视图控制器不在栈中，故为pop操作
        NSLog(@"pop");
        [_countDownTimer invalidate];
        _countDownTimer = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviTitle = @"订单详情";
    self.selectPayWay = @"alipay";
    self.allPrice =0.0;
    self.isCheck = @"0";
    _addressID =@"";
    //设置UI
    [self setupUI];
    
    //网络请求
    [self sendRequest];
    //接收支付结果的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushViewController:) name:@"paySuccess" object:nil];

}
#pragma mark - 网络请求
- (void)sendRequest{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:_model.startDate];
    NSDate *endD = [date dateFromString:_model.endDate];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    secondsCountDown = round(value);
    
    [_timeLabel addAttributedWithString:[NSString stringWithFormat:@"剩余支付时间 %@",[YGAppTool dateTimeDifferenceWithStartTime:_model.endDate endTime:_model.startDate]] range:NSMakeRange(6, [YGAppTool dateTimeDifferenceWithStartTime:_model.endDate endTime:_model.startDate].length) color:[UIColor redColor]];
    
    [_countDownTimer setFireDate:[NSDate distantPast]];
    
    if(![self.model.address isEqualToString:@""])
    {
        [self.placeView reloadDataWithName:[NSString stringWithFormat:@"收货人: %@",self.model.name] phone:[NSString stringWithFormat:@"%@",self.model.phone] place:[NSString stringWithFormat:@"收货地址: %@",self.model.address]];
        self.placeView.isShowNewButton = NO;
        self.addressID = self.model.addressId;
    }
    else
        self.placeView.isShowNewButton = YES;
    
    [self.goodsView pushPurchaseReloadDataWithImage:[NSString stringWithFormat:@"%@",_model.img] name:_model.commodityName price:[NSString stringWithFormat:@"¥%@",_model.unitPrice] count:_model.commoditySizeName];
    
    [self.deliveryView reloadDataWithLetfTitle:@"运费:" rightTitle:[NSString stringWithFormat:@"¥%@",_model.freight] lineTopColor:colorWithLine lineBottomColor:colorWithLine];
    
    NSString * detailString = [NSString stringWithFormat:@"(可用%.0f青币抵￥%.2f)",self.model.point,self.model.pointToMony];
    
    [self.integralView reloadDataWithLetfTitle:@"青币购支付" detailTitle:detailString lineTopColor:LDEEPaddingColor lineBottomColor:colorWithLine];
    
    NSString * commodityTotal  =_model.commodityNum;
    self.commodityFreight = _model.freight;
    
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共计%@件商品  合计：￥%@(含运费￥%@)",commodityTotal,_model.totalPrice,_model.freight]];
    
    NSRange redRange = NSMakeRange([[noteStr string]rangeOfString:_model.totalPrice].location, [[noteStr string]rangeOfString:_model.totalPrice].length);
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:redRange];
    
    [noteStr addAttribute:NSForegroundColorAttributeName value:LDFFTextColor range:redRange];
    
    [self.totalPrice setAttributedText:noteStr];
    
    self.allPrice = [commodityTotal floatValue];
}

- (void)setupUI{
    
    [self.view addSubview:self.backScrollowView];
    
    CGFloat placeViewH = 90;
    CGFloat goodsViewH = 100;
    CGFloat itemViewH = 40;
    
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];

    
    self.countDownView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 70)];
    [self.container addSubview:self.countDownView];
   
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, YGScreenWidth - 30, 25)];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [_timeLabel addAttributedWithString:@"剩余支付时间 00:00:00" range:NSMakeRange(0, 6) color:[UIColor redColor]];
    _timeLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [self.countDownView addSubview:_timeLabel];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, YGScreenWidth - 30, 20)];
    tipLabel.textColor = [UIColor lightGrayColor];
    [tipLabel addAttributedWithString:@"* 请尽快完成支付，否则系统将自动取消订单" lineSpace:8];
    [tipLabel addAttributedWithString:@"* 请尽快完成支付，否则系统将自动取消订单" range:NSMakeRange(0, 1) color:[UIColor redColor]];
    tipLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [self.countDownView addSubview:tipLabel];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.countDownView.height, kScreenW, 10)];
    lineView.backgroundColor = colorWithTable;
    [self.container addSubview:lineView];
    
    self.placeView = [[GoodsPlaceView alloc] initWithFrame:CGRectMake(0, self.countDownView.height+10, kScreenW, placeViewH)];
    self.placeView.delegate = self;
    [self.placeView lableWithThick];
    [self.container addSubview:self.placeView];
    
    //商品View
    self.goodsView = [[GoodsDetailView alloc] initWithFrame:CGRectMake(0, self.placeView.y+self.placeView.height, kScreenW, goodsViewH)];
    [self.container addSubview:self.goodsView];
    
    //配送方式
    self.deliveryView = [[DeliveryWayView alloc] initWithFrame:CGRectMake(0,self.countDownView.height+placeViewH + goodsViewH , kScreenW, itemViewH)];
    [self.container addSubview:self.deliveryView];
    
    //青币购
    self.integralView = [[IntegralView alloc] initWithFrame:CGRectMake(0, self.countDownView.height+placeViewH + goodsViewH + itemViewH, kScreenW, itemViewH)];
    self.integralView.delegate = self;
    [self.container addSubview:self.integralView];
    
    //合计总价
    self.totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(0,self.countDownView.height+placeViewH + goodsViewH + itemViewH * 2, kScreenW - LDHPadding, itemViewH)];
    self.totalPrice.textAlignment =NSTextAlignmentRight;
    self.totalPrice.font = LDFont(12);
    [self.container addSubview:self.totalPrice];
    
    //底部支付视图
    LDPayItemView * patView = [[LDPayItemView alloc] init];
    patView.titleArry = [NSMutableArray arrayWithArray:@[@"支付宝",@"微信"]];
    [patView showPayItemViewWithY:self.countDownView.height+placeViewH + goodsViewH + itemViewH * 3];
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
    payButton.userInteractionEnabled = NO;
    if(self.selectPayWay.length >0)
    {
        NSDictionary * parameters =@{
//                                     @"userID":YGSingletonMarco.user.userId,
                                     @"useIntegral":self.isCheck,
                                     @"addressId":self.addressID,
                                     @"payType":self.selectPayWay,
                                     @"falshsaleOrderId":_model.id,
                                     };
        __weak typeof(self)Weakself = self;

        [YGNetService YGPOST:REQUEST_payFalshsaleOrder parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
            if ([responseObject[@"charge"] isEqualToString:@""]) {
                //支付宝
                ResultViewController *controller = [[ResultViewController alloc] init];
                controller.pageType =  ResultPageTypeSubmitPurchsePayResult;
                controller.earnPoints = 0;
                [self.navigationController pushViewController:controller animated:YES];
            }else
            {
                
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
            }
        } failure:^(NSError *error) {
            payButton.userInteractionEnabled = YES;

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
            payButton.userInteractionEnabled = YES;

        }];
    }
    
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
- (void)integralViewRightButtonDidClick:(UIButton *)coverButton {
    
    float  price = 0.0;
//    coverButton.selected = !coverButton.selected;

    if (coverButton.selected) {
        //总价 - 青币
        price = [_model.totalPrice floatValue] - self.model.pointToMony;
        self.isCheck = @"1";
    }else{
        self.isCheck = @"0";
        price = [_model.totalPrice floatValue];
    }
    
    
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共计%@件商品  合计：￥%.2f(含运费￥%@)",_model.commodityNum,price,_model.freight]];
    
//    NSRange redRange = NSMakeRange([[noteStr string]rangeOfString:price].location, [[noteStr string]rangeOfString:price].length);
//    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:redRange];
    
//    [noteStr addAttribute:NSForegroundColorAttributeName value:LDFFTextColor range:redRange];
    
    [self.totalPrice setAttributedText:noteStr];

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

-(void) countDownAction{
    //倒计时-1
    secondsCountDown--;
    
    int seconds = (int)secondsCountDown % 60;
    int minutes = (int)(secondsCountDown / 60) % 60;
    int hours = (int)secondsCountDown / 3600;
    //    int d = (int)value/1000/60/60/24;
    int d = hours/24;
    
    hours = hours-24*d;
    if (d == 0) {
        [_timeLabel addAttributedWithString:[NSString stringWithFormat:@"剩余支付时间 %@", [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds]] range:NSMakeRange(6,  [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds].length+1) color:[UIColor redColor]];
 ;
        
    }else
    {
        [_timeLabel addAttributedWithString:[NSString stringWithFormat:@"剩余支付时间 %@", [NSString stringWithFormat:@"%02d天  %02d:%02d:%02d",d,hours, minutes, seconds]] range:NSMakeRange(6,  [NSString stringWithFormat:@"%02d天  %02d:%02d:%02d",d,hours, minutes, seconds].length+1) color:[UIColor redColor]];

         ;
    }

    
    
//    NSString *str_hour = [NSString stringWithFormat:@"%02ld",secondsCountDown/3600];
//    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];
//    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
//    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    NSLog(@"%ld",secondsCountDown);
    //修改倒计时标签现实内容
//    [_timeLabel addAttributedWithString:[NSString stringWithFormat:@"剩余支付时间 %@",format_time] range:NSMakeRange(6, format_time.length) color:[UIColor redColor]];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        [_countDownTimer invalidate];
    }
}

@end

