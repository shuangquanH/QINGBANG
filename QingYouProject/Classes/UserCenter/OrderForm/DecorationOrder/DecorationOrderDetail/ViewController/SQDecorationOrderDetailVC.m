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
#import "WKRefundAlertView.h"

#import "WKDecorationDetailViewModel.h"
#import "WKDecorationOrderServer.h"
#import "WKAnimationAlert.h"
#import "SQCallPhoneFunction.h"

#import <Pingpp.h>
#import <Photos/Photos.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface SQDecorationOrderDetailVC () <WKDecorationDetailViewModelDelegate>

@property (nonatomic, strong) UIScrollView  *contentScrollView;

@property (nonatomic, strong) UIView        *contentView;

@property (nonatomic, strong) WKDecorationOrderPayAlertView *payView;

@property (nonatomic, strong) WKRefundAlertView            *refundAlert;

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
            [self addNoDataImageViewWithArray:@[@""] shouldAddToView:self.view headerAction:YES];
        }
        else {
            [YGNetService dissmissLoadingView];
            [YGAppTool showToastWithText:error.domain];
            if (!self.orderDetailInfo) {
                [self addNoDataImageViewWithArray:@[] shouldAddToView:self.view headerAction:YES];
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
            [YGAppTool showToastWithText:@"付款成功"];
            [self sendReqeust];
        } else {
            if (error.code == PingppErrWxNotInstalled) {
                [YGAppTool showToastWithText:@"请安装微信客户端"];
            } else {
                [YGAppTool showToastWithText:@"付款失败"];
            }
        }
    }];
}

- (void)downLoadContract {
    NSArray *urls = [self.orderDetailInfo.orderInfo.contractImgUrl componentsSeparatedByString:@","];
    if (!urls.count) {
        [YGAppTool showToastWithText:@"暂无供下载的合同文件"];
        return;
    }
    NSMutableDictionary *progressDict = [NSMutableDictionary dictionary];
    NSMutableArray *loadImages = [NSMutableArray arrayWithCapacity:progressDict.allKeys.count];
    [urls enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [progressDict setObject:@(0.0) forKey:obj];
    }];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:YGAppDelegate.window animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = @"正在下载...";
    hud.removeFromSuperViewOnHide = YES;
    
    for (NSString *url in urls) {
        NSURL *loadUrl = [NSURL URLWithString:url];
        if (!loadUrl) {
            [[SDWebImageDownloader sharedDownloader] cancelAllDownloads];
            [hud hideAnimated:YES];
            [YGAppTool showToastWithText:@"合同下载地址不正确，请咨询客服查看原因"];
            return;
        }
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:loadUrl options:SDWebImageDownloaderContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progressDict[targetURL.absoluteString] = @(receivedSize / expectedSize);
                float currentProgress = 0;
                for (NSString *key in progressDict.allKeys) {
                    currentProgress += [progressDict[key] floatValue];
                }
                float progress = currentProgress / progressDict.allKeys.count;
                NSLog(@"下载进度---%f", progress);
                hud.progress = progress;
            });
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (finished && image) {
                [loadImages addObject:image];
                if (loadImages.count == progressDict.allKeys.count) {//下载完毕
                    NSLog(@"下载完成--%@", loadImages);
                    NSArray *tmpLoadImages = [loadImages copy];
                    for (UIImage *saveImage in tmpLoadImages) {
                        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                            [PHAssetChangeRequest creationRequestForAssetFromImage:saveImage];
                        } completionHandler:^(BOOL success, NSError * _Nullable error) {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [loadImages removeObject:saveImage];
                                if (loadImages.count == 0) {//保存完成
                                    hud.progress = 1.0;
                                    [hud hideAnimated:YES];
                                    [YGAppTool showToastWithText:@"合同下载成功，已保存到相册"];
                                }
                            });
                        }];
                    }
                }
            } else {
                [[SDWebImageDownloader sharedDownloader] cancelAllDownloads];
                [hud hideAnimated:YES];
                [YGAppTool showToastWithText:@"合同下载失败，请稍后再试"];
                NSLog(@"下载失败--%@", error);
            }
        }];
    }
}

#pragma mark - SQDecorationDetailViewModelDelegate
- (void)serviceView:(SQDecorationDetailServerView *)serviceView didClickServiceType:(NSInteger)serviceType {
    /** 0：联系客服 1：申请售后 */
    if (serviceType == 0) {
        [YGAlertView showAlertWithTitle:@"是否要拨打客服电话？"
                      buttonTitlesArray:@[@"确认", @"取消"]
                      buttonColorsArray:@[KCOLOR_MAIN,kCOLOR_666]
                                handler:^(NSInteger buttonIndex) {
                                    if (buttonIndex == 0) {
                                        [SQCallPhoneFunction callServicePhone];
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
        [self downLoadContract];
    }
    else if (functionType == 1) {
        WKCheckContractViewController *next = [WKCheckContractViewController new];
        next.orderDetailInfo = self.orderDetailInfo;
        [self.navigationController pushViewController:next animated:YES];
    }
    else {
        if (!self.orderDetailInfo.orderInfo.invoice) {//不可以开票
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
    if (stageInfo.status == 0 && self.orderDetailInfo.orderInfo.activityStageInfo) {//当前状态还没有被激活
        NSString *alertString = self.orderDetailInfo.orderInfo.activityStageInfo.status == 2 ? [NSString stringWithFormat:@"需要等待%@补登审核通过后，才可以进行后续操作", self.orderDetailInfo.orderInfo.activityStageInfo.name] : [NSString stringWithFormat:@"需要完成%@，才可以进行后续操作", self.orderDetailInfo.orderInfo.activityStageInfo.name];
        [YGAppTool showToastWithText:alertString];
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
                          buttonColorsArray:@[KCOLOR_MAIN,kCOLOR_666]
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
                          buttonTitlesArray:@[@"确认", @"取消"]
                          buttonColorsArray:@[KCOLOR_MAIN,kCOLOR_666]
                                    handler:^(NSInteger buttonIndex) {
                                        if (buttonIndex == 0) {
                                            [SQCallPhoneFunction callServicePhone];
                                        }
                                    }];
        }
            break;
        case WKDecorationOrderActionTypeRefund://申请退款
        {
            self.refundAlert.stageInfo = stageInfo;
            [WKAnimationAlert showAlertWithInsideView:self.refundAlert animation:WKAlertAnimationTypeBottom canTouchDissmiss:NO];
        }
            break;
        case WKDecorationOrderActionTypeRefundDetail://退款详情
        {
            WKDecorationRefundDetailViewController *next = [WKDecorationRefundDetailViewController new];
            next.orderDetailInfo = self.orderDetailInfo;
            [self.navigationController pushViewController:next animated:YES];
            next.refundReback = ^{
                //撤销退款，重新请求最新订单数据
                [self sendReqeust];
            };
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
                                    @"payType": (payType == WKDecorationPayTypeAliPay ? @"alipay" : @"wx")};
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

- (WKRefundAlertView *)refundAlert {
    if (!_refundAlert) {
        _refundAlert = [WKRefundAlertView refundAlert];
        @weakify(self)
        _refundAlert.refundHandler = ^(NSString *reason) {
            @strongify(self)
            [WKDecorationOrderServer sendRefundWithOrderNumber:self.orderDetailInfo.orderInfo.ID paymentId:self.refundAlert.stageInfo.ID amount:self.refundAlert.stageInfo.amount comment:reason completed:^(BOOL success, NSString *errMsg) {
                if (success) {//退款申请成功，修改本地数据，刷新列表
                    [YGAppTool showToastWithText:@"申请成功，等待审核"];
                    self.orderDetailInfo.orderInfo.refund = YES;//有过退款记录
                    self.orderDetailInfo.orderInfo.inRefund = YES;//申请中
                    for (UIView<WKDecorationDetailViewProtocol> *v in self.orderVM.subviewArray) {
                        [v configOrderDetailInfo:self.orderDetailInfo];
                        [self.contentView addSubview:v];
                    }
                    if (self.orderRefreshBlock) {
                        self.orderRefreshBlock(self.orderDetailInfo.orderInfo);
                    }
                } else {
                    [YGAppTool showToastWithText:errMsg];
                }
            }];
        };
    }
    return _refundAlert;
}

@end
