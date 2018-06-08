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

#import "SQDecorationDetailViewModel.h"
#import "SQDecorationOrderCell.h"
#import "WKDecorationOrderAlertView.h"

@interface SQDecorationOrderDetailVC () <SQDecorationDetailViewModelDelegate>

@property (nonatomic, strong) UIScrollView  *contentScrollView;

@property (nonatomic, strong) UIView        *contentView;

@property (nonatomic, strong) SQDecorationDetailViewModel  *orderVM;

@property (nonatomic, strong) WKDecorationOrderDetailModel *orderInfo;

@end

@implementation SQDecorationOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"订单详情";
    
    [self sendReqeust];
}

- (void)sendReqeust {
    
    self.orderVM = [SQDecorationDetailViewModel new];
    self.orderVM.orderDetailDelegate = self;
    
    [YGNetService showLoadingViewWithSuperView:nil];
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

    for (UIView<SQDecorationDetailViewProtocol> *v in self.orderVM.subviewArray) {
        [v configOrderInfo:self.orderInfo.order_info];
        if ([v respondsToSelector:@selector(configAddressInfo:)]) {
            [v configAddressInfo:self.orderInfo.address_info];
        }
        [self.contentView addSubview:v];
    }
    
    [self makeConstraints];
}

- (void)makeConstraints {
    
    UIView *lastView;
    for (int i = 0; i < self.orderVM.subviewArray.count; i++) {
        UIView<SQDecorationDetailViewProtocol> *v = [self.orderVM.subviewArray objectAtIndex:i];
        if (i == 0) {
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.mas_equalTo(0);
                make.size.mas_equalTo([v viewSize]);
            }];
        }
        else {
            
            if (i == self.orderVM.subviewArray.count - 1) {
                [v mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.mas_equalTo(0);
                    make.top.equalTo(lastView.mas_bottom);
                    make.height.mas_equalTo([v viewSize].height);
                }];
            }
            else {
                [v mas_makeConstraints:^(MASConstraintMaker *make) {
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
        
    }
    else {
        SQTicketApplyViewController *next = [SQTicketApplyViewController new];
        next.orderDetailInfo = self.orderInfo.order_info;
        [self.navigationController pushViewController:next animated:YES];
    }
}

- (void)orderCell:(SQDecorationOrderCell *)orderCell didClickAction:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage {
    switch (actionType) {
        case WKDecorationOrderActionTypePay://支付
        {
            CGFloat offset;
            if (@available(iOS 11.0, *)) {
                offset = self.view.safeAreaInsets.bottom;
            }
            else {
                offset = self.view.layoutMargins.bottom;
            }
            
        }
            break;
        case WKDecorationOrderActionTypeCancel://取消订单
        {
            [WKDecorationOrderAlertView alertWithDetail:@"确认取消订单?" titles:@[@"确定", @"取消"] bgColors:@[KCOLOR_MAIN, KCOLOR(@"98999A")] handler:^(NSInteger index) {
                if (index == 0) {
                    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
                    [SQRequest post:KAPI_CANCELORDER param:@{@"orderNum": self.orderInfo.order_info.orderNum} success:^(id response) {
                        [YGNetService dissmissLoadingView];
                        if ([response[@"state"] isEqualToString:@"success"]) {
                            
                        }
                        else {
                            [YGAppTool showToastWithText:response[@"data"][@"msg"]];
                        }
                        
                    } failure:^(NSError *error) {
                        [YGNetService dissmissLoadingView];
                        [YGAppTool showToastWithText:@"网络错误"];
                    }];
                }
            }];
        }
            break;
        case WKDecorationOrderActionTypeDelete://删除订单
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认删除订单" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
                [SQRequest post:KAPI_DELETEORDER param:@{@"orderNum": self.orderInfo.order_info.orderNum} success:^(id response) {
                    [YGNetService dissmissLoadingView];
                    if ([response[@"code"] isEqualToString:@"0"]) {
                        
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
            next.orderInfo = self.orderInfo.order_info;
            next.stageIndex = stage;
            next.repairSuccess = ^(SQDecorationDetailModel *orderInfo) {
                [self.orderVM.orderCell configOrderInfo:orderInfo];
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
            [SQRequest post:KAPI_APPLYREFUND param:@{@"orderNum": self.orderInfo.order_info.orderNum} success:^(id response) {
                [YGNetService dissmissLoadingView];
                if ([response[@"code"] isEqualToString:@"0"]) {
                    //修改当前状态为申请退款中状态
                    self.orderInfo.order_info.isInRefund = YES;
                    self.orderInfo.order_info.canRefund = NO;
                    [self.orderVM.orderCell configOrderInfo:self.orderInfo.order_info];
                    [YGAppTool showToastWithText:@"申请成功"];
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


@end
