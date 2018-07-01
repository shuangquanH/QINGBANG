//
//  WKDecorationRefundDetailViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationRefundDetailViewController.h"

#import "WKDecorationOrderDetailModel.h"
#import "WKDecorationRefundModel.h"

#import "NSString+SQStringSize.h"
#import "UIButton+SQImagePosition.h"
#import "UILabel+SQAttribut.h"
#import "SQCallPhoneFunction.h"

@interface WKDecorationRefundDetailViewController ()
//联系客服
@property (nonatomic, strong) UIButton *serviceBtn;
//撤销退款
@property (nonatomic, strong) UIButton *cancelRefundBtn;
//标签背景
@property (nonatomic, strong) UIView *labelBgView;
//状态价格标签
@property (nonatomic, strong) UILabel *stateLabel;
//描述
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) WKDecorationRefundModel *refundInfo;

@end

@implementation WKDecorationRefundDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviTitle = @"退款详情";
    [self sendRefundDetailReqeust];
}

- (void)setupSubviews {
    
    _labelBgView = [UIView new];
    _labelBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_labelBgView];
    
    _stateLabel = [UILabel labelWithFont:KSCAL(38) textColor:kCOLOR_333];
    [_labelBgView addSubview:_stateLabel];
    
    _detailLabel = [UILabel labelWithFont:KSCAL(28.0) textColor:kCOLOR_666];
    [_labelBgView addSubview:_detailLabel];
    
    if (self.refundInfo.status == 0) {//审核中
        _stateLabel.text = [NSString stringWithFormat:@"等待平台退款 ¥%@", self.refundInfo.amount];
        [_stateLabel setTextColor:kCOLOR_PRICE_RED andRange:NSMakeRange(7, self.refundInfo.amount.length+1)];
        
        NSString *detailStr = [NSString stringWithFormat:@"退款申请已提交，等待平台处理。在%@天%@小时%@分内平台未处理，系统将按您的支付方式原路退还", self.refundInfo.day, self.refundInfo.hours, self.refundInfo.minutes];
        NSMutableAttributedString *detail = [[NSMutableAttributedString alloc] initWithString:detailStr];
        NSUInteger loc = 16;
        [detail setAttributes:@{NSForegroundColorAttributeName: kCOLOR_PRICE_RED} range:NSMakeRange(loc, self.refundInfo.day.length?:1)];
        loc += 1;
        loc += self.refundInfo.day.length?:1;
        [detail setAttributes:@{NSForegroundColorAttributeName: kCOLOR_PRICE_RED} range:NSMakeRange(loc, self.refundInfo.hours.length?:1)];
        loc += 2;
        loc += self.refundInfo.hours.length?:1;
        [detail setAttributes:@{NSForegroundColorAttributeName: kCOLOR_PRICE_RED} range:NSMakeRange(loc, self.refundInfo.minutes.length?:1)];
        
        _detailLabel.attributedText = detail;
        
        
        _cancelRefundBtn = [UIButton buttonWithTitle:@"撤销退款" titleFont:KSCAL(38) titleColor:[UIColor whiteColor] bgColor:KCOLOR_MAIN];
        _cancelRefundBtn.layer.cornerRadius = 8.0;
        [_cancelRefundBtn addTarget:self action:@selector(click_cancelButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelRefundBtn];
    }
    else if (self.refundInfo.status == 5) {//退款成功
        _stateLabel.text = [NSString stringWithFormat:@"退款成功 ¥%@", self.refundInfo.amount];
        [_stateLabel setTextColor:kCOLOR_PRICE_RED andRange:NSMakeRange(5, self.refundInfo.amount.length+1)];
        _detailLabel.text = @"您的款项已按您的支付方式原路退还。";
    }
    else if (self.refundInfo.status == 2) {//退款已撤销
        _stateLabel.text = @"退款已撤销";
        _detailLabel.text = [NSString stringWithFormat:@"您于%@撤销退款，不支持再次发起申请退款。", self.refundInfo.updateDate];
    }
    else {//退款失败
        _stateLabel.text = @"退款审核不通过";
        _detailLabel.text = [NSString stringWithFormat:@"您于%@发起的退款，因%@不予通过。", self.refundInfo.createDate, self.refundInfo.comment];
        [_detailLabel setTextColor:kCOLOR_PRICE_RED andRange:NSMakeRange(9+self.refundInfo.createDate.length, self.refundInfo.comment.length)];
        
        _line = [UIView new];
        _line.backgroundColor = KCOLOR_LINE;
        [_labelBgView addSubview:_line];
        
        _serviceBtn = [UIButton buttonWithTitle:@"联系客服" titleFont:KSCAL(28) titleColor:KCOLOR(@"328cea") bgColor:[UIColor whiteColor]];
        [_serviceBtn setImage:[UIImage imageNamed:@"service_tel_icon"] forState:UIControlStateNormal];
        [_serviceBtn sq_setImagePosition:SQImagePositionLeft spacing:3];
        [_serviceBtn addTarget:self action:@selector(click_connectServiceBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_serviceBtn];
    }
    
    [_labelBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(KSCAL(20));
    }];
    
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(30));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(KSCAL(50));
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(self.stateLabel);
        make.top.equalTo(self.stateLabel.mas_bottom).offset(KSCAL(25));
        make.bottom.mas_equalTo(-KSCAL(50));
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.stateLabel);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [_cancelRefundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(KSCAL(500), KSCAL(100)));
        make.top.equalTo(_labelBgView.mas_bottom).offset(KSCAL(88));
    }];
    
    [_serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(_labelBgView.mas_bottom);
        make.height.mas_equalTo(KSCAL(88));
    }];
}

#pragma mark - request
//退款详情
- (void)sendRefundDetailReqeust {
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    [SQRequest post:KAPI_REFUNDDETAIL param:@{@"orderId": @([self.orderDetailInfo.orderInfo.ID longLongValue])} success:^(id response) {
        if ([response[@"code"] longLongValue] == 0) {
            self.refundInfo = [WKDecorationRefundModel yy_modelWithJSON:response[@"data"][@"refundInfo"]];
            [self setupSubviews];
            [YGNetService dissmissLoadingView];
        }
        else {
            [YGNetService dissmissLoadingView];
            [YGAppTool showToastWithText:response[@"msg"]];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:1.0];
        }
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:1.0];
    }];
}
//撤销退款
- (void)click_cancelButton {
    
    [YGAlertView showAlertWithTitle:@"撤销退款后，不支持再次发起退款，确定撤销？"
                  buttonTitlesArray:@[@"确认", @"取消"]
                  buttonColorsArray:@[KCOLOR_MAIN,kCOLOR_666]
                            handler:^(NSInteger buttonIndex) {
                                if (buttonIndex == 0) {
                                    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
                                    [SQRequest post:KAPI_CANCELREFUND param:@{@"orderId": @([self.orderDetailInfo.orderInfo.ID longLongValue]), @"id": @([self.refundInfo.ID longLongValue])} success:^(id response) {
                                        [YGNetService dissmissLoadingView];
                                        if ([response[@"code"] longLongValue] == 0) {
                                            [YGAppTool showToastWithText:@"撤销退款成功"];
                                            
                                            //处理回调
                                            self.orderDetailInfo.orderInfo.refund = YES;
                                            self.orderDetailInfo.orderInfo.inRefund = NO;
                                            if (self.refundReback) {
                                                self.refundReback();
                                            }
                                            
                                            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.0];
                                        }
                                        else {
                                            [YGAppTool showToastWithText:response[@"msg"]];
                                        }
                                    } failure:^(NSError *error) {
                                        [YGNetService dissmissLoadingView];
                                    }];
                                }
                            }];
}

- (void)click_connectServiceBtn {
    [YGAlertView showAlertWithTitle:@"是否要拨打客服电话？"
                  buttonTitlesArray:@[@"确认", @"取消"]
                  buttonColorsArray:@[KCOLOR_MAIN,kCOLOR_666]
                            handler:^(NSInteger buttonIndex) {
                                if (buttonIndex == 0) {
                                    [SQCallPhoneFunction callServicePhone];
                                }
                            }];
}

@end
