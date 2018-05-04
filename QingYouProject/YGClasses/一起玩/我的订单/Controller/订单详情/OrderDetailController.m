//
//  OrderDetailController.m
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderDetailController.h"
#import "OrderModel.h"
#import "OrderDetailCell.h"
#import "OrderHeaderView.h"
#import "OrderFooterView.h"
#import "AllianceOrderDetailHeaderView.h"
#import "OrderDetailFooterView.h"
#import "OrderDetailToolBarView.h"
#import "PlayTogetherSignUpPayViewController.h"

@interface OrderDetailController ()<UITableViewDelegate,UITableViewDataSource,OrderDetailToolBarViewDelegate>

@end

@implementation OrderDetailController
{
    UITableView * _tableView;
    NSMutableArray<OrderModel *> * _listArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];  
}

- (void)configAttribute
{
    self.naviTitle = @"订单详情";
    _listArray = [NSMutableArray array];
}

- (void)loadData
{
    [YGNetService YGPOST:REQUEST_ActivityOrderDetail parameters:@{@"orderID":self.orderID} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        _listArray = [OrderModel mj_objectArrayWithKeyValuesArray:@[responseObject]];
   
        [self configUI];

    } failure:^(NSError *error) {
        
    }];
    
    
}
- (void)configUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - YGTabBarHeight - 1) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 144.0f;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];

    OrderModel *model = _listArray[0];
    AllianceOrderDetailHeaderView * headerView = [[AllianceOrderDetailHeaderView alloc] init];
    _tableView.tableHeaderView = headerView;
    headerView.model = model;
    
    OrderDetailFooterView * footerView = [[OrderDetailFooterView alloc] init];
    _tableView.tableFooterView = footerView;
    footerView.person = [NSString stringWithFormat:@"%@(%@)",model.userName,model.userPhone];
    
    /* 根据订单的状态创建toolBarView 这里是  假数据    "待付款"  */
    if (![model.type isEqualToString:@"3"]) {
        OrderDetailToolBarView * toolBarView = [[OrderDetailToolBarView alloc] initWithOrderType:[model.type integerValue]];
        toolBarView.delegate = self;
        [self.view addSubview:toolBarView];
    }

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
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderHeaderView * headerView = [[OrderHeaderView alloc] init];
    headerView.detailType = @"1";
    headerView.model = _listArray[section];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
    if(!cell)
    {
        cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderCell"];
    }
    OrderModel * model = _listArray[indexPath.section];
    cell.model = model;
    return cell;
}


#pragma mark - OrderDetailToolBarViewDelegate
//付款
- (void)payOrderButtonClickedWithOrderDetailToolBarView:(OrderDetailToolBarView *)toolBarView
{
    OrderModel * model = _listArray[0];
    PlayTogetherSignUpPayViewController * singUpPay =[[PlayTogetherSignUpPayViewController alloc]init];
    singUpPay.orderID = model.orderID;
    [self.navigationController pushViewController:singUpPay animated:YES];
    
}
//取消订单
- (void)cancelOrderButtonClickedWithOrderDetailToolBarView:(OrderDetailToolBarView *)toolBarView
{
    [YGAlertView showAlertWithTitle:@"确认要取消订单吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:REQUEST_AllianceOrderDelete parameters:@{@"orderID":_orderID} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                [YGAppTool showToastWithText:@"取消订单成功"];
                [self back];
            } failure:^(NSError *error) {
                
            }];
        }
    }];

}

//联系主办方
- (void)callSponsorButtonClickedWithOrderDetailToolBarView:(OrderDetailToolBarView *)toolBarView
{
    OrderModel * model = _listArray[0];

    if ([model.alliancePhone isEqualToString:@""]) {
        UIButton *btn = [toolBarView viewWithTag:10000];
        [self contactWithCustomerServerWithType:ContactServerPlayTogether button:btn];

    }else
    {
        [YGAlertView showAlertWithTitle:@"是否拨打客服电话？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return ;
            }else
            {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[NSString stringWithFormat:@"%@",model.alliancePhone]];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }
        }];
    }
}

//取消活动
- (void)cancelActiveButtonClickedWithOrderDetailToolBarView:(OrderDetailToolBarView *)toolBarView
{
    [YGAlertView showAlertWithTitle:@"确认要取消活动吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:REQUEST_AllianceOrderCancel parameters:@{@"orderID":_orderID} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                [YGAppTool showToastWithText:@"取消活动成功"];
                [self back];
            } failure:^(NSError *error) {
                
            }];
        }
    }];

}

//删除订单
- (void)delOrderButtonClickedWithOrderDetailToolBarView:(OrderDetailToolBarView *)toolBarView
{
    [YGAlertView showAlertWithTitle:@"确认要删除订单吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:REQUEST_AllianceOrderDelete parameters:@{@"orderID":_orderID} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                [YGAppTool showToastWithText:@"删除订单成功"];
                [self back];
            } failure:^(NSError *error) {
                
            }];
        }
    }];

}
@end
