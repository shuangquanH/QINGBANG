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

#import "WKAnimationAlert.h"

@interface SQDecorationOrderVC () <UITableViewDataSource, UITableViewDelegate, decorationOrderCellDelegate>

@property (nonatomic, strong) UITableView       *tableview;

@property (nonatomic, strong) NSMutableArray<SQDecorationDetailModel *> *orderList;

@property (nonatomic, strong) UIView *bottomPayView;

@end

@implementation SQDecorationOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self fakeList];
    
    self.naviTitle = @"我的装修订单";
    [self.view addSubview:self.tableview];
    [self createRefreshWithScrollView:self.tableview containFooter:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
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
    NSIndexPath *targetIndex = [self.tableview indexPathForCell:decorationCell];
    if (!targetIndex) return;
    
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
            [WKAnimationAlert showAlertWithInsideView:self.bottomPayView animation:WKAlertAnimationTypeBottom canTouchDissmiss:YES superView:nil offset:offset];
        }
            break;
        case WKDecorationOrderActionTypeCancel://取消订单
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认取消订单" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SQDecorationDetailModel *m = [self.orderList objectAtIndex:targetIndex.row];
                m.orderTitle = nil;
                m.orderState = 2;
                [decorationCell configOrderInfo:m];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case WKDecorationOrderActionTypeDelete://删除订单
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认删除订单" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.orderList removeObjectAtIndex:targetIndex.row];
                [self.tableview deleteRowsAtIndexPaths:@[targetIndex] withRowAnimation:UITableViewRowAnimationLeft];
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
    }
}

#pragma mark LazyLoad
- (UITableView  *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

- (UIView  *)bottomPayView {
    if (!_bottomPayView) {
        _bottomPayView = [[UIView alloc] initWithFrame:CGRectMake(0, KAPP_HEIGHT-KNAV_HEIGHT-60, KAPP_WIDTH, 200)];
        _bottomPayView.backgroundColor = colorWithMainColor;
    }
    return _bottomPayView;
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
