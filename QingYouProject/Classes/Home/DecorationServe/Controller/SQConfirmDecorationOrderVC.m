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


#import "WKInvoiceAddressViewController.h"
#import "WKInvoiceAddressModel.h"

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
    [SQRequest post:KAPI_INVOICEADDRESSLIST param:nil success:^(id response) {
        if ([response[@"code"] longLongValue] == 0) {
            NSArray *addresslist = [NSArray yy_modelArrayWithClass:[WKInvoiceAddressModel class] json:response[@"data"][@"addressList"]];
            for (WKInvoiceAddressModel *tmodel in addresslist) {
                if (tmodel.isdef) {
                    self.chooseAddressView.model = tmodel;
                } else {
                    self.chooseAddressView.model = addresslist.firstObject;
                }
            }
            if (addresslist.count == 0) {
                self.chooseAddressView.model = [WKInvoiceAddressModel new];
            }
        } else {
            [YGAppTool showToastWithText:response[@"msg"]];
        }
    } failure:^(NSError *error) {
        [YGAppTool showToastWithText:@"网络错误"];
    }];
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
    self.confirmDecorationCell.detailModel = self.detailModel;
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
    payTypeLabel.detailModel = self.detailModel;
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
        WKInvoiceAddressViewController *vc = [[WKInvoiceAddressViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        vc.addressSelecter = ^(WKInvoiceAddressModel *model){
            weakSelf.chooseAddressView.model = model;
        };
        vc.addressClear = ^(WKInvoiceAddressModel *addressInfo) {
            if (weakSelf.chooseAddressView.model && [weakSelf.chooseAddressView.model.ID isEqualToString:addressInfo.ID]) {//地址列表清除的地址和当前选择的地址相同时，清除当前地址
                weakSelf.chooseAddressView.model = nil;
            }
        };
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
    if (!self.payType) {
        [YGAlertView showAlertWithTitle:@"请选择支付方式" buttonTitlesArray:@[@"OK"] buttonColorsArray:@[KCOLOR_MAIN] handler:nil];
        return;
    }
    if (!self.chooseAddressView.model.ID) {
        [YGAlertView showAlertWithTitle:@"请添加收货地址" buttonTitlesArray:@[@"OK"] buttonColorsArray:@[KCOLOR_MAIN] handler:nil];
        return;
    }
    NSString    *paytype = (self.payType==SQPayByAirPay)?@"alipay":@"wx";
    NSString    *beizhu = self.confirmDecorationCell.leaveMessageStr;
    NSDictionary    *param = @{@"addressId":self.chooseAddressView.model.ID, @"payType":paytype, @"remarks":beizhu, @"skuId":self.detailModel.productSkuId};
    [SQRequest post:KAPI_CREATORDER param:param success:^(id response) {
        if ([response[@"code"] integerValue]==0) {
            [self pingPPPayWithResponde:response[@"data"]];            
        }
    } failure:nil showLoadingView:YES];
}


- (void)pingPPPayWithResponde:(NSDictionary *)response {
    [Pingpp createPayment:response[@"charge"] viewController:self appURLScheme:@"qingyouhui" withCompletion:^(NSString *result, PingppError *error){
        if ([result isEqualToString:@"success"]) {
            SQPaySuccessfulVC   *payvc = [[SQPaySuccessfulVC alloc] init];
            payvc.lastNav = self.navigationController;
            YGNavigationController  *nav = [[YGNavigationController alloc] initWithRootViewController:payvc];
            [self presentViewController:nav animated:YES completion:nil];
        } else {
            [YGAppTool showToastWithText:@"支付失败"];
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
        _bottomPayView.textColor = KCOLOR_WHITE;
        _bottomPayView.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomPayView;
}




@end
