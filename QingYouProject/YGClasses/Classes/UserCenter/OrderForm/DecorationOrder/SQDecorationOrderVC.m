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

#import "SQDecorationOrderCell.h"
#import "SQDecorationDetailModel.h"

@interface SQDecorationOrderVC () <UITableViewDataSource, UITableViewDelegate, decorationOrderCellDelegate>

@property (nonatomic, strong) UITableView       *tableview;

@property (nonatomic, strong) NSMutableArray<SQDecorationDetailModel *> *orderList;

@end

@implementation SQDecorationOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self fakeList];
    
    self.naviTitle = @"我的装修订单";
    [self.view addSubview:self.tableview];
    [self createRefreshWithScrollView:self.tableview containFooter:YES];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {
    if (headerAction) {
        NSLog(@"下拉刷新");
        [self.tableview.mj_header endRefreshing];
    } else {
        NSLog(@"上拉加载");
        [self.tableview.mj_footer endRefreshing];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.orderList.count;
}
- (UITableViewCell  *)tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SQDecorationDetailModel *order = [self.orderList objectAtIndex:indexPath.row];
    
    SQDecorationOrderCell *cell;
    if (order.orderState == 3) {//受理中
        cell = [WKDecorationDealingOrderCell cellWithTableView:tableView];
    }
    else if (order.orderState == 4 || order.orderState == 5 ) {//装修中、已完成
        cell = [SQDecorationOrderCellWithThreeStage cellWithTableView:tableView];
    }
    else {
        cell = [SQDecorationOrderCell cellWithTableView:tableView];
    }
    cell.delegate = self;
    [cell configOrderInfo:order];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SQDecorationOrderDetailVC *vc = [[SQDecorationOrderDetailVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SQDecorationDetailModel *order = [self.orderList objectAtIndex:indexPath.row];
    if (order.orderState == 3) {//受理中
        return [WKDecorationDealingOrderCell cellHeight];
    }
    else if (order.orderState == 4 || order.orderState == 5 ) {//装修中、已完成
        return [SQDecorationOrderCellWithThreeStage cellHeight];
    }
    else {
        return [SQDecorationOrderCell cellHeight];
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
    switch (actionType) {
        case WKDecorationOrderActionTypePay://支付
            break;
        case WKDecorationOrderActionTypeCancel://取消订单
            break;
        case WKDecorationOrderActionTypeDelete://删除订单
            break;
        case WKDecorationOrderActionTypeRepair://补登
        {
            WKDecorationRepairViewController *next = [WKDecorationRepairViewController new];
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case WKDecorationOrderActionTypeCallService://联系客服
            break;
    }
}

#pragma mark LazyLoad
- (UITableView  *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KAPP_WIDTH, KAPP_HEIGHT-KNAV_HEIGHT)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

- (void)fakeList {
    self.orderList = [NSMutableArray array];
    
    SQDecorationDetailModel *m1 = [SQDecorationDetailModel new];
    m1.orderState = 1;
    [self.orderList addObject:m1];
    
    SQDecorationDetailModel *m2 = [SQDecorationDetailModel new];
    m2.orderState = 2;
    [self.orderList addObject:m2];
    
    SQDecorationDetailModel *m3 = [SQDecorationDetailModel new];
    m3.orderState = 3;
    [self.orderList addObject:m3];
    
    SQDecorationDetailModel *m4 = [SQDecorationDetailModel new];
    m4.orderState = 4;
    m4.stageOneState = 1;
    m4.stageTwoState = 2;
    m4.stageThreeState = 3;
    [self.orderList addObject:m4];
    
    SQDecorationDetailModel *m5 = [SQDecorationDetailModel new];
    m5.orderState = 5;
    [self.orderList addObject:m5];
}

@end
