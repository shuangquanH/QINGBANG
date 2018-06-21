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

#import "SQDecorationOrderCell.h"
#import "WKDecorationOrderAlertView.h"
#import "WKAnimationAlert.h"

#import "WKDecorationDetailViewModel.h"

@interface SQDecorationOrderDetailVC () <WKDecorationDetailViewModelDelegate>

@property (nonatomic, strong) UIScrollView  *contentScrollView;

@property (nonatomic, strong) UIView        *contentView;

@property (nonatomic, strong) UIView        *bottomPayView;

@property (nonatomic, strong) WKDecorationDetailViewModel  *orderVM;

@property (nonatomic, strong) WKDecorationOrderDetailModel *orderInfo;

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
        if (order) {
            @strongify(self)
            self.orderInfo = order;
            [self sqaddSubVies];
        }
        [YGNetService dissmissLoadingView];
    }];
}

- (void)sqaddSubVies {
    
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentScrollView);
    }];

    for (UIView<WKDecorationDetailViewProtocol> *v in self.orderVM.subviewArray) {
        [v configOrderInfo:self.orderInfo];
        if ([v respondsToSelector:@selector(configAddressInfo:)]) {
            [v configAddressInfo:self.orderInfo.addressInfo];
        }
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
        next.orderInfo = self.orderInfo;
        [self.navigationController pushViewController:next animated:YES];
    }
}
- (void)functionView:(SQDecorationDetailFunctionView *)functionView didClickFunctionType:(NSInteger)functionType {
    /** 0：下载报价单 1：查看合同 2：开票申请 */
    if (functionType == 0) {
        
    }
    else if (functionType == 1) {
        WKCheckContractViewController *next = [WKCheckContractViewController new];
        next.orderInfo = self.orderInfo;
        [self.navigationController pushViewController:next animated:YES];
    }
    else {
        if (self.orderInfo.isInRepairApply) {//已经申请过发票
            [YGAppTool showToastWithText:@"开票申请已提交，请耐心等待！"];
            return;
        }
        SQTicketApplyViewController *next = [SQTicketApplyViewController new];
        next.orderDetailInfo = self.orderInfo;
        [self.navigationController pushViewController:next animated:YES];
    }
}

- (void)orderCell:(SQDecorationOrderCell *)orderCell didClickAction:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage {
    
    WKDecorationStageModel *stageInfo = self.orderInfo.paymentList[stage];
    if (stageInfo.status == 0) {//当前状态还没有被激活
        if (stage >= 1) {
            [YGAppTool showToastWithText:[NSString stringWithFormat:@"需要完成%@，才可以操作此阶段", self.orderInfo.paymentList[stage-1].name]];
        }
        else {
            [YGAppTool showToastWithText:@"暂时还不能进行此操作，请稍后再试"];
        }
        return;
    }
    
    switch (actionType) {
        case WKDecorationOrderActionTypePay://支付
        {
            [WKAnimationAlert showAlertWithInsideView:self.bottomPayView animation:WKAlertAnimationTypeBottom canTouchDissmiss:YES];
        }
            break;
        case WKDecorationOrderActionTypeDelete://删除订单
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认删除订单" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
                [SQRequest post:KAPI_DELETEORDER param:@{@"orderNum": self.orderInfo.orderNum} success:^(id response) {
                    [YGNetService dissmissLoadingView];
                    if ([response[@"code"] longLongValue] == 0) {
                        if (self.orderRefreshBlock) {//通知列表，更新视图
                            self.orderRefreshBlock(nil);
                        }
                        [YGAppTool showToastWithText:@"删除订单成功"];
                        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.5];
                    }
                    else {
                        [YGAppTool showToastWithText:response[@"msg"]];
                    }
                } failure:^(NSError *error) {
                    [YGNetService dissmissLoadingView];
                    [YGAppTool showToastWithText:@"网络错误"];
                }];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case WKDecorationOrderActionTypeRepair://补登
        {
            WKDecorationRepairViewController *next = [WKDecorationRepairViewController new];
            next.orderInfo = self.orderInfo;
            next.stageIndex = stage;
            next.repairSuccess = ^(WKDecorationOrderDetailModel *orderInfo) {
                [self.orderVM.orderCell configOrderInfo:orderInfo];
                //通知前一个视图，更新数据
                self.orderListInfo.paymentList[stage].status = 2;
                if (self.orderRefreshBlock) {
                    self.orderRefreshBlock(self.orderListInfo);
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
            [SQRequest post:KAPI_APPLYREFUND param:@{@"orderNum": self.orderInfo.orderNum} success:^(id response) {
                [YGNetService dissmissLoadingView];
                if ([response[@"code"] longLongValue] == 0) {
                    //修改当前状态为申请退款中状态
                    self.orderInfo.isInRefund = YES;
                    self.orderInfo.canRefund = NO;
                    [self.orderVM.orderCell configOrderInfo:self.orderInfo];
                    
                    self.orderListInfo.isInRefund = YES;
                    self.orderListInfo.canRefund = NO;
                    if (self.orderRefreshBlock) {
                        self.orderRefreshBlock(self.orderListInfo);
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
            next.orderInfo = self.orderInfo;
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

- (UIView *)bottomPayView {
    if (!_bottomPayView) {
        _bottomPayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KAPP_WIDTH, 200)];
        _bottomPayView.backgroundColor = KCOLOR_MAIN;
    }
    return _bottomPayView;
}



@end
