//
//  PlayTogetherSignUpPayViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PlayTogetherSignUpPayViewController.h"
#import "RushPurchaseOrderListPayDetailViewController.h"
#import <Pingpp.h>

#import "LDPayItemView.h"//支付视图
#import "OrderDetailHeaderView.h"//订单头部视图
#import "OrderDetailBottomView.h"//订单底部View
#import "GoodsCommentViewController.h"//商品评论

#import "ResultViewController.h"
#import "PlayTogetherDetailModel.h"

@interface PlayTogetherSignUpPayViewController ()<LDPayItemViewDelegate,OrderDetailBottomViewDelegate>
{
    UILabel * _infomation;
    UILabel * _name;
    UIView *_baseView;
}

@property (nonatomic, strong) UIImageView * orderGoodsImageView;
@property (nonatomic, strong) UILabel * orderGoodsNameLabel;
@property (nonatomic, strong) UILabel * orderGoodsDatelabel;
@property (nonatomic, strong) UILabel * orderGoodsAddressLabel;
@property (nonatomic, strong) UILabel * orderGoodsTypeLabel;
@property (nonatomic, strong) UILabel * orderGoodsNumLabel;
@property (nonatomic, strong) UILabel * orderGoodsPriceLabel;

/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** ScrollowView容器View  */
@property (nonatomic,strong) UIView * container;


@property (nonatomic, strong) UILabel *priceLable;
/** 订单顶部信息 */
@property (nonatomic,strong) OrderDetailHeaderView * orderHeaderView;
/** 订单底部视图 */
@property (nonatomic,strong) OrderDetailBottomView * orderBottomView;

@property (nonatomic,strong) NSString * selectPayWay;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation PlayTogetherSignUpPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviTitle = @"订单详情";
    self.selectPayWay = @"alipay";
    
    //设置UI
    [self setupUI];
    [self bottomView];
    //网络请求
    [self loadDataFromServer];
    
    //接收支付结果的消息
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushViewController:) name:@"paySuccess" object:nil];
    
}

- (void)loadDataFromServer
{
    NSDictionary * parameters =@{
                                 @"orderID":self.orderID,
                                 };
    
    [YGNetService YGPOST:@"ActivityConfirmView" parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {

        NSDictionary * activity = [responseObject valueForKey:@"activity"];
        
        _name.text = [NSString stringWithFormat:@"%@(%@)",responseObject[@"userName"],responseObject[@"userPhone"]];
        [_orderGoodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",activity[@"activityImg"]]] placeholderImage:[UIImage imageNamed:@"YGDefaultImgTwo_One"]];
        _orderGoodsNameLabel.text = activity[@"activityName"];
        NSString * activityBeginTime = activity[@"activityBeginTime"];
        
        _orderGoodsDatelabel.text = [NSString stringWithFormat:@"%@开始",[activityBeginTime substringToIndex:(activityBeginTime.length -3)]];
        _orderGoodsAddressLabel.text = activity[@"activityAddress"];
        _orderGoodsPriceLabel.text = [NSString stringWithFormat:@"¥%@",activity[@"activityCost"]];

    } failure:^(NSError *error) {
        
    }];

}

#pragma mark - 设置UI界面
- (void)setupUI{
    
    [self.view addSubview:self.backScrollowView];
    
    CGFloat infomationLabelW = [UILabel calculateWidthWithString:@"报名人信息" textFont:leftFont numerOfLines:1].width;
    
    //订单顶部信息
    _infomation = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding, 0, infomationLabelW, 44)];
    _infomation.font = leftFont;
    _infomation.text =@"报名人信息";
    [self.container addSubview:_infomation];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(infomationLabelW, 0, YGScreenWidth -infomationLabelW - 2*LDHPadding, 44)];
    _name.font = leftFont;
    _name.textAlignment = NSTextAlignmentRight;
    [self.container addSubview:_name];
    
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, _name.height + _name.y, YGScreenWidth , LDHPadding)];
    line.backgroundColor = colorWithLine;
    [self.container addSubview:line];
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, line.height + line.y, YGScreenWidth, YGScreenWidth*0.32*0.5+20)];
    _baseView.backgroundColor = colorWithTable;
    [self.container addSubview:_baseView];
    
    _orderGoodsImageView = [[UIImageView alloc] init];
    _orderGoodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    _orderGoodsImageView.clipsToBounds = YES;
    [_baseView addSubview:_orderGoodsImageView];
    [_orderGoodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseView.mas_left).offset(12.5);
        make.top.equalTo(_baseView.mas_top).offset(10);
        make.bottom.equalTo(_baseView.mas_bottom).offset(-10);
        make.width.offset(YGScreenWidth*0.32);
        //        make.height.offset(YGScreenWidth*0.32*0.5);
    }];
    
    _orderGoodsNameLabel = [[UILabel alloc] init];
    _orderGoodsNameLabel.textColor = colorWithBlack;
    _orderGoodsNameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [_baseView addSubview:_orderGoodsNameLabel];
    [_orderGoodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderGoodsImageView.mas_right).offset(10);
        make.top.equalTo(_orderGoodsImageView.mas_top).offset(4);
    }];
    
    _orderGoodsDatelabel = [[UILabel alloc] init];
    _orderGoodsDatelabel.textColor = colorWithDeepGray;
    _orderGoodsDatelabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_baseView addSubview:_orderGoodsDatelabel];
    [_orderGoodsDatelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderGoodsNameLabel.mas_left);
        make.top.equalTo(_orderGoodsNameLabel.mas_bottom).offset(7);
    }];
    
    _orderGoodsAddressLabel = [[UILabel alloc] init];
    _orderGoodsAddressLabel.textColor = colorWithDeepGray;
    _orderGoodsAddressLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_baseView addSubview:_orderGoodsAddressLabel];
    [_orderGoodsAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderGoodsNameLabel.mas_left);
        make.top.equalTo(_orderGoodsDatelabel.mas_bottom).offset(6);
    }];
    
    _orderGoodsTypeLabel = [[UILabel alloc] init];
    _orderGoodsTypeLabel.textColor = colorWithBlack;
    _orderGoodsTypeLabel.text = @"报名费";
    _orderGoodsTypeLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [self.container addSubview:_orderGoodsTypeLabel];
    [_orderGoodsTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.container.mas_left).offset(12.5);
        make.top.equalTo(_baseView.mas_bottom).offset(10);
    }];
    
    _orderGoodsPriceLabel = [[UILabel alloc] init];
    _orderGoodsPriceLabel.textColor = LDFFTextColor;
    _orderGoodsPriceLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [self.container addSubview:_orderGoodsPriceLabel];
    [_orderGoodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.container.mas_right).offset(-12.5);
        make.centerY.equalTo(_orderGoodsTypeLabel.mas_centerY);
    }];
    
    _orderGoodsNumLabel = [[UILabel alloc] init];
    _orderGoodsNumLabel.textColor = colorWithBlack;
    _orderGoodsNumLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [self.container addSubview:_orderGoodsNumLabel];
    [_orderGoodsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_orderGoodsPriceLabel.mas_left).offset(-15);
        make.centerY.equalTo(_orderGoodsTypeLabel.mas_centerY);
    }];
    
    //底部支付视图
    LDPayItemView * patView = [[LDPayItemView alloc] init];
    patView.titleArry = [NSMutableArray arrayWithArray:@[@"支付宝支付",@"微信支付"]];
    [patView showPayItemViewWithY:_baseView.y + _baseView.height + 40];
    [self.container addSubview:patView];
    patView.delegate = self;
    
    [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(patView.height + patView.y);
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

- (void)orderDetailBottomViewPayBtnClick:(UIButton *)btn
{
        NSDictionary * parameters =@{
                                     @"orderID":self.orderID,
                                     @"channel":self.selectPayWay,
                                     };
        __weak typeof(self)Weakself = self;
        
        [YGNetService YGPOST:@"ActivityPayOrder" parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
            
            NSString *charegeString = [responseObject valueForKey:@"charge"];

            if (!charegeString.length)
            {
                [YGAppTool showToastWithText:@"您已报名成功"];
                NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
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
                            controller.pageType =  ResultPageTypeSubmitPlayTogether;
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
            controller.pageType =  ResultPageTypeSubmitPlayTogether;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if([self.selectPayWay isEqualToString:@"wx"])
        {
            //微信
            ResultViewController *controller = [[ResultViewController alloc] init];
            controller.pageType =  ResultPageTypeSubmitPlayTogether;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
        [YGAppTool showToastWithText:@"支付成功"];
    }
    else
    {
        [YGAppTool showToastWithText:@"支付失败"];
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
        _backScrollowView.backgroundColor = colorWithLine;
        _backScrollowView.alwaysBounceVertical = YES;
        //容器视图
        self.container = [[UIView alloc] init];
        self.container.backgroundColor = colorWithYGWhite;
        [self.backScrollowView addSubview:self.container];
        [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.offset(0);
            make.width.equalTo(_backScrollowView);
        }];
        
    }
    return _backScrollowView;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        
        //悬浮视图
        CGFloat H = YGNaviBarHeight + YGBottomMargin ;
        CGFloat Y = kScreenH - H  - YGNaviBarHeight - YGStatusBarHeight;
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Y, kScreenW, H)];
        [self.view addSubview:_bottomView];
        
        UIButton * buyButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:@"确认支付" selectedTitle:@"确认支付" normalTitleColor:kWhiteColor selectedTitleColor:kWhiteColor backGroundColor:LDMainColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:14];
        [buyButton addTarget:self action:@selector(orderDetailBottomViewPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        buyButton.frame = CGRectMake(0, 0, kScreenW, H);
        [_bottomView addSubview:buyButton];
        
    }
    return _bottomView;
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


