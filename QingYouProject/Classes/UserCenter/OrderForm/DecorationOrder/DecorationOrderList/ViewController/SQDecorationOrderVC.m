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
#import "SQDecorationDetailModel.h"

#import "WKAnimationAlert.h"
#import "WKDecorationOrderAlertView.h"

@interface SQDecorationOrderVC () <UITableViewDataSource, UITableViewDelegate, decorationOrderCellDelegate>

@property (nonatomic, strong) UITableView       *tableView;

@property (nonatomic, strong) NSMutableArray<SQDecorationDetailModel *> *orderList;

@property (nonatomic, strong) UIView *bottomPayView;

@end

@implementation SQDecorationOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.naviTitle = @"我的装修订单";
    [self.view addSubview:self.tableView];
    
    self.orderList = [NSMutableArray array];
    [self createRefreshWithScrollView:self.tableView containFooter:YES];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
        }
        else {
            make.bottom.mas_equalTo(-self.view.layoutMargins.bottom);
        }
    }];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {
    if (headerAction) {
        [SQRequest post:KAPI_MYDECORATION_ORDERLIST param:nil success:^(id response) {
            NSArray<SQDecorationDetailModel *> *tmp = [NSArray yy_modelArrayWithClass:[SQDecorationDetailModel class] json:response[@"data"][@"order_list"]];
            [self.orderList removeAllObjects];
            [self.orderList addObjectsFromArray:tmp];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell  *)tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SQDecorationDetailModel *order = [self.orderList objectAtIndex:indexPath.section];
    //订单状态头部
    if (indexPath.row == 0) {
        WKDecorationStateCell *cell = [WKDecorationStateCell cellWithTableView:tableView];
        cell.backgroundColor = [UIColor clearColor];
        [cell configOrderInfo:order];
        return cell;
    }
    //订单详情
    SQDecorationOrderCell *cell;
    if (order.orderState == 3) {//受理中
        cell = [WKDecorationDealingOrderCell cellWithTableView:tableView];
    }
    else {//装修中、已完成
        cell = [WKDecorationOrderMutableStageCell cellWithTableView:tableView];
    }
    cell.delegate = self;
    [cell configOrderInfo:order];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SQDecorationOrderDetailVC *vc = [[SQDecorationOrderDetailVC alloc] init];
    vc.orderListInfo = [self.orderList objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return KSCAL(110);
    }
    SQDecorationDetailModel *order = [self.orderList objectAtIndex:indexPath.section];
    if (order.orderState == 3) {//受理中
        return [WKDecorationDealingOrderCell cellHeightWithOrderInfo:order];
    }
    else {
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
    
    switch (actionType) {
        case WKDecorationOrderActionTypePay://支付
        {
            CGFloat offset;
            if (@available(iOS 11.0, *)) {
                offset = self.view.safeAreaInsets.bottom;
            } else {
                offset = self.view.layoutMargins.bottom;
            }
            [WKAnimationAlert showAlertWithInsideView:self.bottomPayView animation:WKAlertAnimationTypeBottom canTouchDissmiss:YES superView:nil offset:offset];
        }
            break;
        case WKDecorationOrderActionTypeCancel://取消订单
        {
            [WKDecorationOrderAlertView alertWithDetail:@"确认取消订单?" titles:@[@"确定", @"取消"] bgColors:@[KCOLOR_MAIN, KCOLOR(@"98999A")] handler:^(NSInteger index) {
                if (index == 0) {
                    SQDecorationDetailModel *m = [self.orderList objectAtIndex:targetIndex.section];
                    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
                    [SQRequest post:KAPI_CANCELORDER param:@{@"orderNum": m.orderNum} success:^(id response) {
                        [YGNetService dissmissLoadingView];
                        if ([response[@"state"] isEqualToString:@"success"]) {
                            m.orderTitle = nil;
                            m.orderState = 2;
                            m.stage_list.firstObject.stageState = 4;
                            [decorationCell configOrderInfo:m];
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
                SQDecorationDetailModel *m = [self.orderList objectAtIndex:targetIndex.section];
                [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
                [SQRequest post:KAPI_DELETEORDER param:@{@"orderNum": m.orderNum} success:^(id response) {
                    [YGNetService dissmissLoadingView];
                    if ([response[@"state"] isEqualToString:@"success"]) {
                        [self.orderList removeObjectAtIndex:targetIndex.section];
                        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:targetIndex.section] withRowAnimation:UITableViewRowAnimationLeft];
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
            WKDecorationRepairViewController *next = [WKDecorationRepairViewController new];
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case WKDecorationOrderActionTypeCallService://联系客服
            break;
        default:
            break;
    }
}

#pragma mark LazyLoad
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor colorWithRed:239.0/255 green:240.0/255.0 blue:241.0/255 alpha:1.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorInset = UIEdgeInsetsMake(0, KSCAL(30.0), 0, KSCAL(30.0));
    }
    return _tableView;
}

- (UIView *)bottomPayView {
    if (!_bottomPayView) {
        _bottomPayView = [[UIView alloc] initWithFrame:CGRectMake(0, KAPP_HEIGHT-KNAV_HEIGHT-60, KAPP_WIDTH, 200)];
        _bottomPayView.backgroundColor = colorWithMainColor;
    }
    return _bottomPayView;
}


@end
