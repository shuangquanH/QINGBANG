//
//  WKDecorationRefundDetailViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationRefundDetailViewController.h"

#import "SQDecorationDetailModel.h"
#import "WKDecorationRefundModel.h"

@interface WKDecorationRefundDetailViewController ()

@property (nonatomic, strong) UIButton *cancelRefundBtn;

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) WKDecorationRefundModel *refundInfo;

@end

@implementation WKDecorationRefundDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviTitle = @"退款详情";
    [self sendRefundDetailReqeust];
}

- (void)setupSubviews {
    
    _stateLabel = [UILabel labelWithFont:KSCAL(34.0) textColor:[UIColor blackColor]];
    [self.view addSubview:_stateLabel];
    
    _detailLabel = [UILabel labelWithFont:KSCAL(28.0) textColor:[UIColor blackColor]];
    [self.view addSubview:_detailLabel];
    
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(30));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(KSCAL(30));
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(self.stateLabel);
        make.top.equalTo(self.stateLabel.mas_bottom).offset(KSCAL(30));
    }];
    
    if (self.refundInfo.refundState == 1) {//审核中
        _stateLabel.text = [NSString stringWithFormat:@"等待平台退款 ¥ %@", self.refundInfo.refundPrice];
        _detailLabel.text = [NSString stringWithFormat:@"退款申请已提交，等待平台处理。在%@内平台未处理，系统将按您的支付方式原路退还", self.refundInfo.limitTime];
        
        _cancelRefundBtn = [UIButton new];
        [_cancelRefundBtn setBackgroundColor:[UIColor redColor]];
        [_cancelRefundBtn setTitle:@"撤销退款" forState:UIControlStateNormal];
        [_cancelRefundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelRefundBtn addTarget:self action:@selector(click_cancelButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelRefundBtn];
        [_cancelRefundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(55);
            if (@available(iOS 11.0, *)) {
                make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
            }
            else {
                make.bottom.mas_equalTo(-self.view.layoutMargins.bottom);
            }
        }];
    }
    else if (self.refundInfo.refundState == 2) {//退款成功
        _stateLabel.text = [NSString stringWithFormat:@"退款成功 ¥ %@", self.refundInfo.refundPrice];
        _detailLabel.text = @"您的款项已按您的支付方式原路退还。";
    }
    else if (self.refundInfo.refundState == 3) {//退款已撤销
        _stateLabel.text = @"退款已撤销";
        _detailLabel.text = [NSString stringWithFormat:@"您于%@撤销退款，不支持再次发起申请退款。", self.refundInfo.cancelTime];
    }
    else {//退款失败
        _stateLabel.text = @"退款审核不通过";
        _detailLabel.text = [NSString stringWithFormat:@"您于%@发起的退款，因%@不予通过。", self.refundInfo.createTime, self.refundInfo.refundFailReason];
    }
}

#pragma mark - request
- (void)sendRefundDetailReqeust {
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    [SQRequest post:KAPI_REFUNDDETAIL param:@{@"orderNum": self.orderInfo.order_info.orderNum  } success:^(id response) {
        if ([response[@"state"] isEqualToString:@"success"]) {
            self.refundInfo = [WKDecorationRefundModel yy_modelWithJSON:response[@"data"]];
            [self setupSubviews];
            [YGNetService dissmissLoadingView];
        }
        else {
            [YGNetService dissmissLoadingView];
            [YGAppTool showToastWithText:response[@"data"][@"msg"]];
        }
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
    }];
}

- (void)click_cancelButton {
    
}

@end
