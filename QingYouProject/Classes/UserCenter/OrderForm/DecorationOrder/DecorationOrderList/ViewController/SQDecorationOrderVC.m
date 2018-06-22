//
//  SQDecorationOrderVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/17.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationOrderVC.h"
#import "SQDecorationOrderDetailVC.h"
#import "WKDecorationRepairViewController.h"

#import "WKDecorationStateCell.h"
#import "SQDecorationOrderCell.h"
#import "WKDecorationOrderListModel.h"

#import "WKDecorationOrderAlertView.h"
#import "WKDecorationOrderPayAlertView.h"

#import <Pingpp.h>

@interface SQDecorationOrderVC () <UITableViewDataSource, UITableViewDelegate, decorationOrderCellDelegate>

@property (nonatomic, strong) UITableView       *tableView;

@property (nonatomic, assign) NSInteger         page;

@property (nonatomic, assign) NSInteger         pageSize;

@property (nonatomic, strong) NSMutableArray<WKDecorationOrderListModel *> *orderList;

@property (nonatomic, strong) WKDecorationOrderPayAlertView *payView;
//支付信息记录
@property (nonatomic, strong) NSDictionary *payStageDict;

@end

@implementation SQDecorationOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.naviTitle = @"我的装修订单";
    
    self.orderList = [NSMutableArray array];
    self.page = 1;
    self.pageSize = 10;
    
    [self.view addSubview:self.tableView];
    [self createRefreshWithScrollView:self.tableView containFooter:YES];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
//刷新列表
- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {

    NSInteger tmpPage = self.page;
    if (headerAction) {
        tmpPage = 1;
    }
    else {
        tmpPage += 1;
    }
    
    [SQRequest postCustomApi:[NSString stringWithFormat:@"http://192.168.2.27:8089/%@", KAPI_MYDECORATION_ORDERLIST] param:@{@"page": @(tmpPage), @"pageSize": @(self.pageSize)} success:^(id response) {
        if ([response[@"code"] longLongValue] == 0) {
            NSArray<WKDecorationOrderListModel *> *tmp = [NSArray yy_modelArrayWithClass:[WKDecorationOrderListModel class] json:response[@"data"][@"orderList"]];
            if (tmp.count) {
                if (headerAction) {
                    [self.orderList removeAllObjects];
                }
                [self.orderList addObjectsFromArray:tmp];
                self.page = tmpPage;
                [self.tableView reloadData];
            }
        }
        else {
            [YGAppTool showToastWithText:response[@"msg"]];
        }
        
        if (headerAction) {
            [self.tableView.mj_header endRefreshing];
        }
        else {
            [self.tableView.mj_footer endRefreshing];
        }
        NSLog(@"订单列表：%@", response);
    } failure:^(NSError *error) {
        NSError *underlyingError = error.userInfo[NSUnderlyingErrorKey];
        NSHTTPURLResponse *reponse = underlyingError.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        if (!reponse || reponse.statusCode == 408) {
            [YGAppTool showToastWithText:@"网络错误"];
        }
        else {
            [YGAppTool showToastWithText:@"服务器错误"];
        }
    
        if (headerAction) {
            [self.tableView.mj_header endRefreshing];
        }
        else {
            [self.tableView.mj_footer endRefreshing];
        }
    } showLoadingView:NO];
}

- (void)sendGetSigleOrderInfoByOrderNumber:(NSString *)orderNum complete:(void(^)(WKDecorationOrderListModel *order))complete {
    [SQRequest postCustomApi:[NSString stringWithFormat:@"http://192.168.2.27:8089/%@", KAPI_DECORATIONORDERDETAIL] param:@{@"orderNum": orderNum} success:^(id response) {
        if ([response[@"code"] longLongValue] == 0) {
            WKDecorationOrderDetailModel *order = [WKDecorationOrderDetailModel yy_modelWithJSON:response[@"data"]];
            complete(order.orderInfo);
        }
        else {
            complete(nil);
        }
        NSLog(@"订单详情：%@", response);
    } failure:^(NSError *error) {
        complete(nil);
    } showLoadingView:NO];
}

//支付回调
- (void)pingPPPayWithResponde:(NSDictionary *)response {
    [Pingpp createPayment:response[@"charge"] viewController:self appURLScheme:@"qingyouhui" withCompletion:^(NSString *result, PingppError *error){
        if ([result isEqualToString:@"success"]) {
            
            //支付成功，重新获取当前订单的状态数据，替换原始订单
            WKDecorationOrderListModel *order = self.payStageDict[@"orderInfo"];
            @weakify(self)
            [self sendGetSigleOrderInfoByOrderNumber:order.orderNum complete:^(WKDecorationOrderListModel *order) {
                @strongify(self)
                if (order) {
                    NSIndexPath *indexPath = self.payStageDict[@"indexPath"];
                    [self.orderList replaceObjectAtIndex:indexPath.section withObject:order];
                    [self.tableView reloadData];
                }
                else {
                    [self.tableView.mj_header beginRefreshing];
                }
                [YGNetService dissmissLoadingView];
                [YGAppTool showToastWithText:@"支付成功"];
            }];
        } else {
            [YGNetService dissmissLoadingView];
            if (error.code == PingppErrWxNotInstalled) {
                [YGAppTool showToastWithText:@"请安装微信客户端"];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKDecorationOrderListModel *order = [self.orderList objectAtIndex:indexPath.section];
    //订单状态头部
    if (indexPath.row == 0) {
        WKDecorationStateCell *cell = [WKDecorationStateCell cellWithTableView:tableView];
        cell.backgroundColor = self.tableView.backgroundColor;
        [cell configOrderInfo:order];
        return cell;
    }
    //订单详情
    SQDecorationOrderCell *cell;
    if (order.status == 1 || order.status == 2) {//待付款、已关闭状态，只有一个订金阶段需要展示
        cell = [SQDecorationOrderCell cellWithTableView:tableView];
    }
    else if (order.status == 3) {//受理中状态
        cell = [WKDecorationDealingOrderCell cellWithTableView:tableView];
    }
    else {//其余所有状态
        cell = [WKDecorationOrderMutableStageCell cellWithTableView:tableView];
    }
    cell.delegate = self;
    [cell configOrderInfo:order];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) return;
    
    SQDecorationOrderDetailVC *vc = [[SQDecorationOrderDetailVC alloc] init];
    vc.orderListInfo = [self.orderList objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
    
    vc.orderRefreshBlock = ^(WKDecorationOrderListModel *orderInfo) {
        if (!orderInfo) {//删除订单
            [self.orderList removeObjectAtIndex:indexPath.section];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            [self.tableView reloadData];
        }
    };
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return KSCAL(110);
    }
    WKDecorationOrderListModel *order = [self.orderList objectAtIndex:indexPath.section];
    if (order.status == 1 || order.status == 2) {//待付款、已关闭状态，只有一个订金阶段需要展示
        return [SQDecorationOrderCell cellHeightWithOrderInfo:order];
    }
    else if (order.status == 3) {//受理中状态
        return [WKDecorationDealingOrderCell cellHeightWithOrderInfo:order];
    }
    else {//其余所有状态
        return [WKDecorationOrderMutableStageCell cellHeightWithOrderInfo:order];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - decorationOrderCellDelegate
- (void)decorationCell:(SQDecorationOrderCell *)decorationCell tapedOrderActionType:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage {
    
    NSIndexPath *targetIndex = [self.tableView indexPathForCell:decorationCell];
    if (!targetIndex) return;
    
    WKDecorationOrderListModel *orderInfo = [self.orderList objectAtIndex:targetIndex.section];
    WKDecorationStageModel *stageInfo = orderInfo.paymentList[stage];
    if (stageInfo.status == 0 && stage >= 1) {//当前状态还没有被激活
        [YGAppTool showToastWithText:[NSString stringWithFormat:@"需要完成%@，才可以操作此阶段", orderInfo.paymentList[stage-1].name]];
        return;
    }
    
    switch (actionType) {
        case WKDecorationOrderActionTypePay: {//支付
            self.payStageDict = @{@"indexPath": targetIndex,
                                  @"orderInfo": orderInfo,
                                  @"stageIndex": @(stage)
                                  };
            [self.payView showPaymentViewInSuperView:nil];
        }
            break;
        case WKDecorationOrderActionTypeCancel: {//取消订单
            [WKDecorationOrderAlertView alertWithDetail:@"确认取消订单?" titles:@[@"确定", @"取消"] bgColors:@[KCOLOR_MAIN, KCOLOR(@"98999A")] handler:^(NSInteger index) {
                if (index == 0) {
                    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
                    [SQRequest postCustomApi:[NSString stringWithFormat:@"http://192.168.2.27:8089/%@", KAPI_CANCELORDER] param:@{@"orderNum": orderInfo.orderNum} success:^(id response) {
                        [YGNetService dissmissLoadingView];
                        if ([response[@"code"] longLongValue] == 0) {
                            //直接修改本地模型->已关闭订单，阶段已关闭状态
                            orderInfo.orderTitle = nil;
                            orderInfo.status = 2;
                            orderInfo.paymentList.firstObject.status = 4;
                            WKDecorationStateCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:targetIndex.section]];
                            if (cell) {
                                [cell configOrderInfo:orderInfo];
                                [decorationCell configOrderInfo:orderInfo];
                            }
                            else {
                                [self.tableView reloadData];
                            }
                        }
                        else {
                            [YGAppTool showToastWithText:response[@"data"][@"msg"]];
                        }
                    } failure:^(NSError *error) {
                        [YGNetService dissmissLoadingView];
                        [YGAppTool showToastWithText:@"网络错误"];
                    } showLoadingView:NO];
                }
            }];
        }
            break;
        case WKDecorationOrderActionTypeDelete: {//删除订单
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认删除订单" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
                [SQRequest postCustomApi:[NSString stringWithFormat:@"http://192.168.2.27:8089/%@", KAPI_DELETEORDER] param:@{@"orderNum": orderInfo.orderNum} success:^(id response) {
                    [YGNetService dissmissLoadingView];
                    if ([response[@"code"] longLongValue] == 0) {
                        [self.orderList removeObjectAtIndex:targetIndex.section];
                        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:targetIndex.section] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    else {
                        [YGAppTool showToastWithText:response[@"msg"]];
                    }
                    
                } failure:^(NSError *error) {
                    [YGNetService dissmissLoadingView];
                    [YGAppTool showToastWithText:@"网络错误"];
                } showLoadingView:NO];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case WKDecorationOrderActionTypeRepair: {//补登
            WKDecorationRepairViewController *next = [WKDecorationRepairViewController new];
            next.orderInfo = self.orderList[targetIndex.section];
            next.stageIndex = stage;
            next.repairSuccess = ^(WKDecorationOrderListModel *orderInfo) {
                [decorationCell configOrderInfo:orderInfo];
            };
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case WKDecorationOrderActionTypeCallService: {//联系客服
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
        default:
            break;
    }
}

#pragma mark LazyLoad
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = colorWithTable;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorInset = UIEdgeInsetsMake(0, KSCAL(30.0), 0, KSCAL(30.0));
    }
    return _tableView;
}

- (WKDecorationOrderPayAlertView *)payView {
    if (!_payView) {
        _payView = [[WKDecorationOrderPayAlertView alloc] initWithFrame:CGRectZero];
        @weakify(self)
        _payView.paymentAction = ^(WKDecorationPayType payType) {
            @strongify(self)
            WKDecorationOrderListModel *order = self.payStageDict[@"orderInfo"];
            NSInteger stageIndex = [self.payStageDict[@"stageIndex"] integerValue];
            NSDictionary *param = @{@"paymentId": order.paymentList[stageIndex].ID,
                                    @"payType" : (payType == WKDecorationPayTypeAliPay ? @"alipay" : @"wxpay")
                                    };
            [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
            [SQRequest postCustomApi:@"http://192.168.2.27:8089/pingpp/pay" param:param success:^(id response) {
                NSLog(@"%@", response);
                [self pingPPPayWithResponde:response[@"data"]];
            } failure:^(NSError *error) {
                [YGNetService dissmissLoadingView];
            } showLoadingView:NO];
        };
    }
    return _payView;
}

@end
