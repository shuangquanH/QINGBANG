//
//  SQDecorationOrderDetailVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/18.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationOrderDetailVC.h"
#import "SQTicketApplyViewController.h"
#import "SQApplyAfterSaleViewController.h"
#import "WKDecorationRefundDetailViewController.h"
#import "WKDecorationRepairViewController.h"
#import "WKCheckContractViewController.h"

#import "WKDecorationOrderBaseCell.h"
#import "WKDecorationOrderAlertView.h"
#import "WKDecorationOrderPayAlertView.h"

#import "WKDecorationDetailViewModel.h"
#import "WKDecorationOrderServer.h"

#import <Pingpp.h>

@interface SQDecorationOrderDetailVC () <WKDecorationDetailViewModelDelegate>

@property (nonatomic, strong) UIScrollView  *contentScrollView;

@property (nonatomic, strong) UIView        *contentView;

@property (nonatomic, strong) WKDecorationOrderPayAlertView *payView;

@property (nonatomic, strong) WKDecorationDetailViewModel  *orderVM;

@property (nonatomic, strong) WKDecorationOrderDetailModel *orderDetailInfo;

@property (nonatomic, assign) NSInteger payStageIndex;

@end

@implementation SQDecorationOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"订单详情";
    
    self.orderVM = [WKDecorationDetailViewModel new];
    self.orderVM.orderDetailDelegate = self;
    [self sendReqeust];
}

- (void)sendReqeust {
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    @weakify(self)
    
    [self.orderVM sendOrderDetailRequestWithOrderNum:self.orderListInfo.orderNum completed:^(WKDecorationOrderDetailModel *order, NSError *error) {
        @strongify(self)
        if (order) {
            if (self.orderDetailInfo) {//数据已经存在，说明本次请求是属于刷新数据，进行回调刷新
                if (self.orderRefreshBlock) {
                    self.orderRefreshBlock(order.orderInfo);
                }
            }
            self.orderDetailInfo = order;
            [self sqaddSubVies];
            [YGNetService dissmissLoadingView];
        }
        else {
            [YGNetService dissmissLoadingView];
            [YGAppTool showToastWithText:error.domain];
            if (!self.orderDetailInfo) {
                [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:1.0];
            }
        }
    }];
}

- (void)sqaddSubVies {
    
    if (!_contentView) {
        [self.view addSubview:self.contentScrollView];
        [self.contentScrollView addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentScrollView);
        }];
    }
    
    for (UIView<WKDecorationDetailViewProtocol> *v in self.orderVM.subviewArray) {
        [v configOrderDetailInfo:self.orderDetailInfo];
        [self.contentView addSubview:v];
    }
    
    [self makeConstraints];
}

- (void)makeConstraints {
    
    UIView *lastView;
    for (int i = 0; i < self.orderVM.subviewArray.count; i++) {
        UIView<WKDecorationDetailViewProtocol> *v = [self.orderVM.subviewArray objectAtIndex:i];
        if (i == 0) {
            [v mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.mas_equalTo(0);
                make.size.mas_equalTo([v viewSize]);
            }];
        }
        else {
            
            if (i == self.orderVM.subviewArray.count - 1) {
                [v mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.mas_equalTo(0);
                    make.top.equalTo(lastView.mas_bottom);
                    make.height.mas_equalTo([v viewSize].height);
                }];
            }
            else {
                [v mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.equalTo(lastView.mas_bottom);
                    make.height.mas_equalTo([v viewSize].height).priorityHigh();
                }];
            }
        }
        
        lastView = v;
    }
}

//支付回调
- (void)pingPPPayWithResponde:(NSDictionary *)response {
    [Pingpp createPayment:response[@"charge"] viewController:self appURLScheme:@"qingyouhui" withCompletion:^(NSString *result, PingppError *error){
        if ([result isEqualToString:@"success"]) {
            //支付成功后，重新获取订单数据，刷新视图
            [self sendReqeust];
        } else {
            if (error.code == PingppErrWxNotInstalled) {
                [YGAppTool showToastWithText:@"请安装微信客户端"];
            }
        }
    }];
}


#pragma mark - SQDecorationDetailViewModelDelegate
- (void)serviceView:(SQDecorationDetailServerView *)serviceView didClickServiceType:(NSInteger)serviceType {
    /** 0：联系客服 1：申请售后 */
    if (serviceType == 0) {
        [YGAlertView showAlertWithTitle:@"是否要拨打客服电话？"
                      buttonTitlesArray:@[@"YES", @"NO"]
                      buttonColorsArray:@[[UIColor blueColor],
                                          [UIColor redColor]]
                                handler:^(NSInteger buttonIndex) {
                                    if (buttonIndex == 0) {
                                        NSString *url = @"tel:057812345";
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                                    }
                                }];
    }
    else {
        SQApplyAfterSaleViewController *next = [SQApplyAfterSaleViewController new];
        next.orderInfo = self.orderDetailInfo;
        [self.navigationController pushViewController:next animated:YES];
    }
}
- (void)functionView:(SQDecorationDetailFunctionView *)functionView didClickFunctionType:(NSInteger)functionType {
    /** 0：下载报价单 1：查看合同 2：开票申请 */
    if (functionType == 0) {
        
    }
    else if (functionType == 1) {
        WKCheckContractViewController *next = [WKCheckContractViewController new];
        next.orderDetailInfo = self.orderDetailInfo;
        [self.navigationController pushViewController:next animated:YES];
    }
    else {
        if (self.orderDetailInfo.orderInfo.invoice) {//已经申请过发票
            [YGAppTool showToastWithText:@"开票申请已提交，请耐心等待！"];
            return;
        }
        SQTicketApplyViewController *next = [SQTicketApplyViewController new];
        next.orderDetailInfo = self.orderDetailInfo;
        [self.navigationController pushViewController:next animated:YES];
    }
}

- (void)orderCell:(WKDecorationOrderBaseCell *)orderCell didClickAction:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage {
    
    
    if (self.orderDetailInfo.orderInfo.paymentList.count <= stage) {
        NSLog(@"不存在阶段款--%zd", stage);
        return;
    }
    
    WKDecorationStageModel *stageInfo = self.orderDetailInfo.orderInfo.paymentList[stage];
    if (stageInfo.status == 0) {//当前状态还没有被激活
        if (stage >= 1) {
            [YGAppTool showToastWithText:[NSString stringWithFormat:@"需要完成%@，才可以操作此阶段", self.orderDetailInfo.orderInfo.paymentList[stage-1].name]];
        }
        else {
            [YGAppTool showToastWithText:@"暂时还不能进行此操作，请稍后再试"];
        }
        return;
    }
    
    switch (actionType) {
        case WKDecorationOrderActionTypePay://支付
        {
            self.payStageIndex = stage;
            [self.payView showPaymentViewInSuperView:nil];
        }
            break;
        case WKDecorationOrderActionTypeDelete://删除订单
        {
            [YGAlertView showAlertWithTitle:@"确认删除订单？"
                          buttonTitlesArray:@[@"确认", @"取消"]
                          buttonColorsArray:@[[UIColor blueColor],
                                              [UIColor redColor]]
                                    handler:^(NSInteger buttonIndex) {
                                        if (buttonIndex == 0) {
                                            [WKDecorationOrderServer sendDeleteOrderWithOrderNumber:self.orderDetailInfo.orderInfo.orderNum completed:^(BOOL success, NSString *errMsg) {
                                                if (success) {
                                                    //回调订单列表，删除订单
                                                    if (self.orderRefreshBlock) {
                                                        self.orderRefreshBlock(nil);
                                                    }
                                                    [YGAppTool showToastWithText:@"删除订单成功"];
                                                    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.5];
                                                } else {
                                                    [YGAppTool showToastWithText:errMsg];
                                                }
                                            }];
                                        }
                                    }];
        }
            break;
        case WKDecorationOrderActionTypeRepair://补登
        {
            WKDecorationRepairViewController *next = [WKDecorationRepairViewController new];
            next.orderInfo = self.orderDetailInfo.orderInfo;
            next.stageIndex = stage;
            next.repairSuccess = ^(WKDecorationOrderListModel *orderInfo) {
                [self.orderVM.orderCell configOrderDetailInfo:self.orderDetailInfo];
                //回调订单列表，刷新数据
                if (self.orderRefreshBlock) {
                    self.orderRefreshBlock(self.orderDetailInfo.orderInfo);
                }
            };
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case WKDecorationOrderActionTypeCallService://联系客服
        {
            [YGAlertView showAlertWithTitle:@"是否要拨打客服电话？"
                          buttonTitlesArray:@[@"YES", @"NO"]
                          buttonColorsArray:@[[UIColor blueColor],
                                              [UIColor redColor]]
                                    handler:^(NSInteger buttonIndex) {
                                        if (buttonIndex == 0) {
                                            NSString *url = @"tel:057812345";
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                                        }
                                    }];
        }
            break;
        case WKDecorationOrderActionTypeRefund://申请退款
        {
            [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
            [SQRequest post:KAPI_APPLYREFUND param:@{@"orderNum": self.orderDetailInfo.orderInfo.orderNum} success:^(id response) {
                [YGNetService dissmissLoadingView];
                if ([response[@"code"] longLongValue] == 0) {
                    //回调订单列表，修改当前状态为申请退款中状态
                    self.orderDetailInfo.orderInfo.refund = YES;
                    [self.orderVM.orderCell configOrderDetailInfo:self.orderDetailInfo];
                    if (self.orderRefreshBlock) {
                        self.orderRefreshBlock(self.orderDetailInfo.orderInfo);
                    }
                    [YGAppTool showToastWithText:@"申请成功，等待审核"];
                }
                else {
                    [YGAppTool showToastWithText:response[@"msg"]];
                }
            } failure:^(NSError *error) {
                [YGNetService dissmissLoadingView];
                [YGAppTool showToastWithText:@"网络错误"];
            }];
        }
            break;
        case WKDecorationOrderActionTypeRefundDetail://退款详情
        {
            WKDecorationRefundDetailViewController *next = [WKDecorationRefundDetailViewController new];
            next.orderDetailInfo = self.orderDetailInfo;
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark LazyLoad
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        CGRect frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-KNAV_HEIGHT);
        _contentScrollView = [[UIScrollView alloc] initWithFrame:frame];
    }
    return _contentScrollView;
}
- (UIView *)contentView {
    if (!_contentView) {
        CGRect frame = CGRectMake(0, 0, YGScreenWidth, (YGScreenHeight-KNAV_HEIGHT)*2);
        _contentView = [[UIView alloc] initWithFrame:frame];
    }
    return _contentView;
}

- (WKDecorationOrderPayAlertView *)payView {
    if (!_payView) {
        _payView = [[WKDecorationOrderPayAlertView alloc] initWithFrame:CGRectZero];
        @weakify(self)
        _payView.paymentAction = ^(WKDecorationPayType payType) {
            
            @strongify(self)
            
            NSDictionary *param = @{@"paymentId": self.orderDetailInfo.orderInfo.paymentList[self.payStageIndex].ID,
                                    @"payType": (payType == WKDecorationPayTypeAliPay ? @"alipay" : @"wxpay")};
            [WKDecorationOrderServer sendPayWithParam:param completed:^(id response, NSString *errMsg) {
                if (response) {
                    [self pingPPPayWithResponde:response];
                } else {
                    [YGAppTool showToastWithText:errMsg];
                }
            }];
        };
    }
    return _payView;
}

@end
