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
    NSDictionary    *param = @{@"addressId":@"20", @"payType":@"alipay", @"remarks":@"beizhu", @"skuId":self.skuId};
    [SQRequest setApiAddress:KAPI_ADDRESS_TEST_MH];
    [SQRequest post:KAPI_CREATORDER param:param success:^(id response) {
        
    } failure:^(NSError *error) {
        
    }];
    [SQRequest setApiAddress:nil];
    
    
//    if (self.payType) {
//        SQPaySuccessfulVC   *payvc = [[SQPaySuccessfulVC alloc] init];
//        payvc.lastNav = self.navigationController;
//        YGNavigationController  *nav = [[YGNavigationController alloc] initWithRootViewController:payvc];
//        [self presentViewController:nav animated:YES completion:nil];
//    } else {
//        [YGAlertView showAlertWithTitle:@"请选择支付方式" buttonTitlesArray:@[@"OK"] buttonColorsArray:@[KCOLOR_MAIN] handler:nil];
//    }
}


- (void)pingPPPayWithResponde:(NSDictionary *)response {
    [Pingpp createPayment:response[@"charge"] viewController:self appURLScheme:@"qingyouhui" withCompletion:^(NSString *result, PingppError *error){
        if ([result isEqualToString:@"success"]) {
            NSLog(@"支付成功!");
        } else {
            NSLog(@"支付失败!");
            if (error.code == PingppErrWxNotInstalled) {
                [YGAppTool showToastWithText:@"请安装微信客户端"];
            }
        }
    }];
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
