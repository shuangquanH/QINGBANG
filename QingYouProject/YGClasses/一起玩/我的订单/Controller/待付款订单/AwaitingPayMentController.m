//
//  AwaitingPayMentController.m
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AwaitingPayMentController.h"
#import "OrderModel.h"
#import "OrderCell.h"
#import "OrderHeaderView.h"
#import "OrderFooterView.h"
#import "OrderDetailController.h"
#import "PlayTogetherSignUpPayViewController.h"

@interface AwaitingPayMentController ()<UITableViewDelegate,UITableViewDataSource,OrderFooterViewDelegate>

@end

@implementation AwaitingPayMentController
{
    UITableView * _tableView;
    NSMutableArray<OrderModel *> * _listArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView.mj_header beginRefreshing];
    
}
- (void)configAttribute
{
    _listArray = [NSMutableArray array];
    self.view.frame = self.controllerFrame;
   
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_ActivityOrderList parameters:@{@"userID":YGSingletonMarco.user.userId,@"type":@"1",@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }
        if ([(NSArray *)responseObject[@"activityOrderList"] count] < [YGPageSize intValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        [_listArray addObjectsFromArray:[OrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"activityOrderList"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
- (void)configUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, self.view.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 115.0f;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 73.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderHeaderView * headerView = [[OrderHeaderView alloc] init];
    headerView.model = _listArray[section];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderFooterView * footerView = [[OrderFooterView alloc] init];
    footerView.model = _listArray[section];
    footerView.tag = section+1000;
    footerView.delegate = self;
    return footerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
    if(!cell)
    {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderCell"];
    }
    OrderModel * model = _listArray[indexPath.section];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel * model = _listArray[indexPath.section];
    OrderDetailController * controller = [[OrderDetailController alloc] init];
    controller.orderID = model.orderID;
    [self.navigationController pushViewController:controller animated:YES];

}

#pragma mark - OrderFooterViewDelegate

/*  根据 orderFooterView 的tag值进行订单状态的转换  */

//去付款
- (void)payOrderButtonClickedWithOrderFooterView:(OrderFooterView *)orderFooterView
{
    OrderModel * model = _listArray[0];
    PlayTogetherSignUpPayViewController * singUpPay =[[PlayTogetherSignUpPayViewController alloc]init];
    singUpPay.orderID = model.orderID;
    [self.navigationController pushViewController:singUpPay animated:YES];
    
}
//取消订单
- (void)cancelOrderButtonClickedWithOrderFooterView:(OrderFooterView *)orderFooterView
{
    OrderModel * model = _listArray[orderFooterView.tag-1000];
    [YGAlertView showAlertWithTitle:@"确认要取消订单吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:REQUEST_AllianceOrderDelete parameters:@{@"orderID":model.orderID} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                [YGAppTool showToastWithText:@"取消订单成功"];
                [self refreshActionWithIsRefreshHeaderAction:YES];
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}
@end
