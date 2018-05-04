//
//  RushPurchaseOrderListAfterSaleViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RushPurchaseOrderListAfterSaleViewController.h"
#import "RushPurchaseOrderListTableViewCell.h"
#import "RushPurchaseOrderListWaitToGoodsDetailViewController.h"
#import "RushPurchaseOrderListModel.h"
#import "RushPurchaseOrderRefundViewController.h"

@interface RushPurchaseOrderListAfterSaleViewController ()<UITableViewDelegate,UITableViewDataSource,RushPurchaseOrderListTableViewCellDelegate,RushPurchaseOrderRefundViewControllerDelegate>
{
    UITableView *_tableView;
    NSMutableArray * _dataArray;
}

@end

@implementation RushPurchaseOrderListAfterSaleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectFromString(_controllFrame);

    _dataArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    //网络请求
        [self createRefreshWithScrollView:_tableView containFooter:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView.mj_header beginRefreshing];
}
#pragma mark - 网络请求
//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [self endRefreshWithScrollView:_tableView];

    NSDictionary *parameters = @{
                                 @"usmUserId":YGSingletonMarco.user.userId,
                                 @"type":@"4",
                                 @"count":self.countString,
                                 @"total":self.totalString
                                 };
    
    //如果不是加载过缓存
//    if (!self.isAlreadyLoadCache)
//    {
//        //加载缓存数据
//        NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:REQUEST_getFalshsaleOrderList parameter:parameters];
//        [_dataArray addObjectsFromArray:[RushPurchaseOrderListModel mj_objectArrayWithKeyValuesArray:cacheDic[@"list"]]];
//        [_tableView reloadData];
//        self.isAlreadyLoadCache = YES;
//    }
    
    [YGNetService YGPOST:REQUEST_getFalshsaleOrderList
              parameters:parameters
         showLoadingView:NO
              scrollView:_tableView
                 success:^( id responseObject) {
                     //如果是刷新
                     if (headerAction)
                     {
                         //先移除数据源所有数据
                         [_dataArray removeAllObjects];
                     }
                     //如果是加载
                     //判断服务器返回的数组是不是没数据了，如果没数据
                     if ([responseObject[@"list"] count] < [YGPageSize intValue])
                     {
                         //调用一下没数据的方法，告诉用户没有更多
                         [self noMoreDataFormatWithScrollView:_tableView];
                     }
                     
                     //将字典数组转化为模型数组，再加入到数据源
                     [_dataArray addObjectsFromArray:[RushPurchaseOrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
                     //调用加载无数据图的方法
                     [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:headerAction];
                     [_tableView reloadData];
                 } failure:^(NSError *error)
     {
         [self addNoNetRetryButtonWithFrame:_tableView.frame listArray:_dataArray];
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        RushPurchaseOrderListModel * model = _dataArray[indexPath.row];
    int cellType = 0;
    if ([model.refundsType isEqualToString:@"1"]) {
        cellType = 4;
    }
    if ([model.refundsType isEqualToString:@"2"]) {
        cellType = 5;
        
    }
    switch (cellType) {
        case 4://售后退款中
        {
            RushPurchaseOrderListWaitToGoodsDetailViewController * detailView = [[RushPurchaseOrderListWaitToGoodsDetailViewController alloc]init];
            detailView.OrderID =model.falshsaleOrderId;
            detailView.status = 4;
            [self.navigationController pushViewController:detailView animated:YES];
        }
            break;
        case 5://售后退款成功
        {
            RushPurchaseOrderListWaitToGoodsDetailViewController * detailView = [[RushPurchaseOrderListWaitToGoodsDetailViewController alloc]init];
            detailView.OrderID =model.falshsaleOrderId;
            detailView.status = 5;
            [self.navigationController pushViewController:detailView animated:YES];
        }
            break;
        case 6://售后退失败
        {
            RushPurchaseOrderListWaitToGoodsDetailViewController * detailView = [[RushPurchaseOrderListWaitToGoodsDetailViewController alloc]init];
            detailView.OrderID =model.falshsaleOrderId;
            detailView.status = 6;
            [self.navigationController pushViewController:detailView animated:YES];
        }
            break;
         default:
            break;
    }
}

- (void)deliveredAndRefundViewControllerDeleteWithRow:(int)row
{
    [_dataArray removeObjectAtIndex:row];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RushPurchaseOrderListModel * model = _dataArray[indexPath.row];

    RushPurchaseOrderListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:RushPurchaseOrderListTableViewCellID];
    cell.row = indexPath.row;
    cell.delegate = self;
    int cellType = 0;
    if ([model.refundsType isEqualToString:@"0"]) {
        cellType = [model.type intValue];
    }else
    {
        if ([model.refundsType isEqualToString:@"1"]) {
            cellType = 4;
        }
        if ([model.refundsType isEqualToString:@"2"]) {
            cellType = 5;
            
        }
    }
    cell.model = model;
    [cell setModelValeFalseWithType:cellType];
    return cell;
    
}

- (void)rushPurchaseOrderListTableViewCellReturnMoneyWithButton:(UIButton *)btn withRow:(NSInteger)row
{
    RushPurchaseOrderListModel * model = _dataArray[row];
    [YGAlertView showAlertWithTitle:@"是否删除这条订单？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:REQUEST_deleteFalshsaleOrder parameters:@{@"falshsaleOrderId":model.falshsaleOrderId} showLoadingView:YES scrollView:nil success:^(id responseObject) {
                [YGAppTool showToastWithText:@"订单删除成功"];
                [self deliveredAndRefundViewControllerDeleteWithRow:(int)row];
                
            } failure:nil];
        }
    }];

}

- (void)rushPurchaseOrderListTableViewCellReceiveGoodWithButton:(UIButton *)btn withRow:(NSInteger)row
{
    
        RushPurchaseOrderListModel * model = _dataArray[row];
        [YGAlertView showAlertWithTitle:@"是否删除这条订单？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return ;
            }else
            {
                [YGNetService YGPOST:REQUEST_deleteFalshsaleOrder parameters:@{@"falshsaleOrderId":model.falshsaleOrderId} showLoadingView:YES scrollView:nil success:^(id responseObject) {
                    [YGAppTool showToastWithText:@"订单删除成功"];
                    [self deliveredAndRefundViewControllerDeleteWithRow:(int)row];
                    
                } failure:nil];
            }
        }];
        
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RushPurchaseOrderListModel * model = _dataArray[indexPath.row];
    if ([model.refundsType isEqualToString:@"1"]) {//退款中
        return  190;
        
    }else{
        return 230;
    }
    
    
    
    
}
static NSString * const RushPurchaseOrderListTableViewCellID = @"RushPurchaseOrderListTableViewCellID";

- (UITableView *)tableView{
    
    if (!_tableView) {
        CGFloat H = kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 230;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[RushPurchaseOrderListTableViewCell class] forCellReuseIdentifier:RushPurchaseOrderListTableViewCellID];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

- (void)RushPurchaseOrderRefundViewControllerWithCommintRow:(int)row
{
    [self deliveredAndRefundViewControllerDeleteWithRow:row];
}
@end



