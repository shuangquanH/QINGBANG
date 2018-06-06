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

#import "SQDecorationDetailViewModel.h"

@interface SQDecorationOrderDetailVC () < SQDecorationDetailViewModelDelegate>

@property (nonatomic, strong) UIScrollView  *contentScrollView;
@property (nonatomic, strong) UIView        *contentView;

@property (nonatomic, strong) SQDecorationDetailViewModel *orderDetailVM;

@property (nonatomic, strong) WKDecorationOrderDetailModel *orderInfo;

@end

@implementation SQDecorationOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"订单详情";
    
    [self sendReqeust];
}

- (void)sendReqeust {
    
    self.orderDetailVM = [SQDecorationDetailViewModel new];
    self.orderDetailVM.orderDetailDelegate = self;
    
    [YGNetService showLoadingViewWithSuperView:nil];
    @weakify(self)
    [self.orderDetailVM sendOrderDetailRequestWithOrderNum:self.orderListInfo.orderNum completed:^(WKDecorationOrderDetailModel *order, NSError *error) {
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

    for (UIView<SQDecorationDetailViewProtocol> *v in self.orderDetailVM.subviewArray) {
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
    for (int i = 0; i < self.orderDetailVM.subviewArray.count; i++) {
        UIView<SQDecorationDetailViewProtocol> *v = [self.orderDetailVM.subviewArray objectAtIndex:i];
        if (i == 0) {
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.mas_equalTo(0);
                make.size.mas_equalTo([v viewSize]);
            }];
        }
        else {
            
            if (i == self.orderDetailVM.subviewArray.count - 1) {
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
        NSString *url = @"tel:057812345";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    else {
        SQApplyAfterSaleViewController *next = [SQApplyAfterSaleViewController new];
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
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认取消订单" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case WKDecorationOrderActionTypeDelete://删除订单
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认删除订单" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
                [SQRequest post:KAPI_DELETEORDER param:@{@"orderNum": self.orderInfo.order_info.orderNum} success:^(id response) {
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
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case WKDecorationOrderActionTypeRepair://补登
        {
//            WKDecorationRepairViewController *next = [WKDecorationRepairViewController new];
//            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case WKDecorationOrderActionTypeCallService://联系客服
            break;
        case WKDecorationOrderActionTypeRefund://申请退款
            break;
        case WKDecorationOrderActionTypeRefundDetail://退款详情
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
        _contentScrollView.delegate = self;
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
