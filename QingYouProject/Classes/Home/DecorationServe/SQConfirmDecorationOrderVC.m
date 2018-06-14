//
//  SQConfirmDecorationOrderVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQConfirmDecorationOrderVC.h"
#import "SQDecorationAddressModel.h"

#import "SQChooseDecorationAddressView.h"
#import "SQConfirmDecorationCell.h"
#import "UIView+SQGesture.h"

#import "ManageMailPostViewController.h"
#import "AddAddressViewController.h"

#import "SQPaySuccessfulVC.h"
#import "YGNavigationController.h"

#import <Pingpp.h>


@interface SQConfirmDecorationOrderVC () <SQConfirmDecorationPayDelegate>

@property (nonatomic, assign) PayType       payType;
@property (nonatomic, strong) UIScrollView                  *backScrollView;
@property (nonatomic, strong) UILabel                        *bottomPayView;

@property (nonatomic, strong) SQChooseDecorationAddressView       *chooseAddressView;
@property (nonatomic, strong) SQConfirmDecorationCell       *confirmDecorationCell;


@end

@implementation SQConfirmDecorationOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
}

- (void)requestData {
    //获取用户地址
    NSDictionary    *param = @{@"userId":YGSingletonMarco.user.userId,@"type":@"0", @"total":@"0",@"count":@"1"};
    [YGNetService YGPOST:REQUEST_AddressList parameters:param showLoadingView:nil scrollView:nil success:^(id responseObject) {
        NSArray *addresslist = [NSArray arrayWithArray:responseObject[@"addressList"]];
        self.chooseAddressView.model = [SQDecorationAddressModel yy_modelWithDictionary:addresslist.firstObject];
    } failure: nil];
    
}


- (void)configAttribute {
    self.naviTitle = @"确认订单";
    [self.view addSubview:self.backScrollView];
    [self.view addSubview:self.bottomPayView];
    
    UIView  *contentView = [[UIView alloc] init];
    [self.backScrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backScrollView);
        make.width.equalTo(self.backScrollView);
    }];
    
    /** 选择地址  */
    self.chooseAddressView = [[SQChooseDecorationAddressView alloc] init];
    [contentView addSubview:self.chooseAddressView];
    [self.chooseAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(contentView);
    }];
    
    
    /** 订单cell  */
    self.confirmDecorationCell = [[SQConfirmDecorationCell alloc] init];
    [contentView addSubview:self.confirmDecorationCell];
    [self.confirmDecorationCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.chooseAddressView);
        make.top.equalTo(self.chooseAddressView.mas_bottom).offset(KSCAL(20));
    }];
    
    
    /** 支付方式  */
    UILabel *payLabel = [[UILabel alloc] init];
    payLabel.font = KFONT(32);
    payLabel.textColor = kCOLOR_333;
    payLabel.text = @"支付方式";
    [contentView addSubview:payLabel];
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(30));
        make.top.equalTo(self.confirmDecorationCell.mas_bottom).offset(KSCAL(20));
        make.height.mas_equalTo(KSCAL(88));
    }];
    
    SQConfirmDecorationPayLabel *payTypeLabel = [[SQConfirmDecorationPayLabel alloc] init];
    payTypeLabel.delegate = self;
    [contentView addSubview:payTypeLabel];
    [payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(payLabel.mas_bottom);
        make.bottom.mas_equalTo(contentView);
    }];
    
    
    
    WeakSelf(weakSelf);
    /** 点击地址栏  */
    self.chooseAddressView.userInteractionEnabled = YES;
    [self.chooseAddressView sq_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        if (weakSelf.chooseAddressView.model) {
            ManageMailPostViewController *managePostVC = [[ManageMailPostViewController alloc] init];
            managePostVC.pageType = @"decorationAddress";
            [weakSelf.navigationController pushViewController:managePostVC animated:YES];
        } else {
            AddAddressViewController *addVC = [[AddAddressViewController alloc]init];
            addVC.navTitle = @"添加地址";
            addVC.state = @"添加";
            [weakSelf.navigationController pushViewController:addVC animated:YES];
        }
    }];
    
    /** 点击提交订单按钮  */
    self.bottomPayView.userInteractionEnabled = YES;
    [self.bottomPayView sq_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weakSelf confirmButtonAction];
    }];
    
}

- (void)payType:(PayType)type {
    self.payType = type;
}
- (void)confirmButtonAction {
    NSDictionary    *dic = @{
                             @"id": @"ch_a5OinLGyzzjLXPSOy9rPKKiL",
                             @"object": @"charge",
                             @"created": @1458186221,
                             @"livemode": @1,
                             @"paid": @0,
                             @"refunded": @0,
                             @"app": @"app_1Gqj58ynP0mHeX1q",
                             @"channel": @"alipay",
                             @"order_no": @"123456789",
                             @"client_ip": @"127.0.0.1",
                             @"amount": @100,
                             @"amount_settle": @100,
                             @"currency": @"cny",
                             @"subject": @"Your Subject",
                             @"body": @"Your Body",
                             @"extra": @{},
                             @"time_paid": @"",
                             @"time_expire": @1458272621,
                             @"time_settle": @"",
                             @"transaction_no": @"",
                             @"refunds": @{
                                 @"object": @"list",
                                 @"url": @"/v1/charges/ch_a5OinLGyzzjLXPSOy9rPKKiL/refunds",
                                 @"has_more": @0,
                                 @"data": @[]
                             },
                             @"amount_refunded": @0,
                             @"failure_code": @"",
                             @"failure_msg": @"",
                             @"metadata": @{},
                             @"credential": @{
                                 @"object": @"credential",
                                 @"alipay": @{
                                     @"orderInfo":
                                     @"service=\"mobile.securitypay.pay\"&_input_charset=\"utf-8\"&notify_url=\"https%3A%2F%2Fapi.pingxx.com%2Fnotify%2Fcharges%2Fch_a5OinLGyzzjLXPSOy9rPKKiL\"&partner=\"2008010319263982\"&out_trade_no=\"123456789\"&subject=\"YourSubject\"&body=\"YourBody\"&total_fee=\"0.10\"&payment_type=\"1\"&seller_id=\"2088020116983982\"&it_b_pay=\"2016-03-1811:43:41\"&sign=\"ODRJPReSwsH8om5fGTqvhia9453k4eUaaGMJTLMTnEYbBuceMyTathvKtdnUpsP6Q5%2F5jcEV887EdtBWi4tuMFHPQmm4dz1nG6b4Blafi6v2tvKaf8b0RiQTOycU4SxigugKoyfeR6E4AGA6uIzWUBRpkq%2BZf65eqT0qe712BJ0%3D\"&sign_type=\"RSA\""
                                 }
                             },
                             @"description": @"Your Description"
                             };
    
    [Pingpp createPayment:dic viewController:self appURLScheme:@"qingyouhui" withCompletion:^(NSString *result, PingppError *error){
        if ([result isEqualToString:@"success"])
        {
            NSLog(@"dd");
        } else {
            NSLog(@"aa");
        }
    }];
    
    
//    if (self.payType) {
//        SQPaySuccessfulVC   *payvc = [[SQPaySuccessfulVC alloc] init];
//        payvc.lastNav = self.navigationController;
//        YGNavigationController  *nav = [[YGNavigationController alloc] initWithRootViewController:payvc];
//        [self presentViewController:nav animated:YES completion:nil];
//    } else {
//        [YGAlertView showAlertWithTitle:@"请选择支付方式" buttonTitlesArray:@[@"OK"] buttonColorsArray:@[KCOLOR_MAIN] handler:nil];
//    }
}



#pragma mark LazyLoad
- (UIScrollView *)backScrollView {
    if (!_backScrollView) {
        CGRect frame =CGRectMake(0, 0, KAPP_WIDTH, KAPP_HEIGHT-KNAV_HEIGHT-60);
        _backScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _backScrollView.backgroundColor = self.view.backgroundColor;
    }
    return _backScrollView;
}

- (UILabel   *)bottomPayView {
    if (!_bottomPayView) {
        _bottomPayView = [[UILabel alloc] initWithFrame:CGRectMake(0, KAPP_HEIGHT-KNAV_HEIGHT-60, KAPP_WIDTH, 60)];
        _bottomPayView.backgroundColor = colorWithMainColor;
        _bottomPayView.font = KFONT(38);
        _bottomPayView.text = @"提交订单";
        _bottomPayView.textColor = kWhiteColor;
        _bottomPayView.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomPayView;
}




@end
