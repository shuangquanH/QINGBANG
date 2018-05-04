//
//  PendingPaymentOfficePurchaseViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PendingPaymentOfficePurchaseViewController.h"
#import "PendingPaymentOfficePurchaseCell.h"//cell
#import "DeliveredAndRefundViewController.h"//售后订单详情
#import "AllOfficePurchaseModel.h"//订单模型
#import "WaitPaidViewController.h"//待付款订单详情

@interface PendingPaymentOfficePurchaseViewController ()<UITableViewDelegate,UITableViewDataSource,PendingPaymentOfficePurchaseCellDelegate,WaitPaidViewControllerDelegate>
/** tableView  */
@property (nonatomic,strong) UITableView * tableView;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation PendingPaymentOfficePurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithTable;
    
    [self.view addSubview:self.tableView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
  
}
#pragma mark - 网络请求
//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    NSDictionary *parameters = @{
                                 @"userID":YGSingletonMarco.user.userId,
                                 @"type":@"1",
                                 @"count":self.countString,
                                 @"total":self.totalString
                                 };
    NSString *url = @"ProcurementAllOrder";
    
//    //如果不是加载过缓存
//    if (!self.isAlreadyLoadCache)
//    {
//        //加载缓存数据
//        NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
//        [self.dataArray addObjectsFromArray:[AllOfficePurchaseModel mj_objectArrayWithKeyValuesArray:cacheDic[@"orderList"]]];
//        [_tableView reloadData];
//        self.isAlreadyLoadCache = YES;
//    }
    
    [YGNetService YGPOST:url
              parameters:parameters
         showLoadingView:NO
              scrollView:_tableView
                 success:^( id responseObject) {
                     
                     //如果是刷新
                     if (headerAction)
                     {
                         //先移除数据源所有数据
                         [self.dataArray removeAllObjects];
                     }
                     //如果是加载
                     else
                     {
                         //判断服务器返回的数组是不是没数据了，如果没数据
                         if ([responseObject[@"orderList"] count] == 0)
                         {
                             //调用一下没数据的方法，告诉用户没有更多
                             [self noMoreDataFormatWithScrollView:_tableView];
                             return;
                         }
                     }
                     //将字典数组转化为模型数组，再加入到数据源
                     [self.dataArray addObjectsFromArray:[AllOfficePurchaseModel mj_objectArrayWithKeyValuesArray:responseObject[@"orderList"]]];
                     //调用加载无数据图的方法
                     [self addNoDataImageViewWithArray:self.dataArray shouldAddToView:_tableView headerAction:headerAction];
                     [_tableView reloadData];
                 } failure:^(NSError *error)
     {
         [self addNoNetRetryButtonWithFrame:_tableView.frame listArray:self.dataArray];
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;

}

static NSString * const PendingPaymentOfficePurchaseCellID = @"PendingPaymentOfficePurchaseCellID";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PendingPaymentOfficePurchaseCell * cell = [tableView dequeueReusableCellWithIdentifier:PendingPaymentOfficePurchaseCellID];
    
    cell.model = self.dataArray[indexPath.row];
    cell.delegate =self;
    cell.row =(int)indexPath.row;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AllOfficePurchaseModel * model = self.dataArray[indexPath.row];
    WaitPaidViewController * vc = [[WaitPaidViewController alloc] init];
    vc.OrderID = model.orderID;
    vc.delegate =self;
    vc.row =(int)indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
   
}
- (void)waitPaidViewControllerWithCancalRow:(int)row
{
    [self.dataArray removeObjectAtIndex:row];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}

- (void)pendingPaymentOfficePurchaseCellCancelBtnClick:(UIButton *)btn WithRow:(int)row
{
    [YGAlertView showAlertWithTitle:@"确认取消订单？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            AllOfficePurchaseModel * model = self.dataArray[row];
            
            NSDictionary * parameters =@{
                                         @"orderID":model.orderID,
                                         };
            [YGNetService YGPOST:@"ProcurementOrderDelete" parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
                [YGAppTool showToastWithText:@"取消订单成功"];
                [self.dataArray removeObjectAtIndex:row];
                
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
                
            } failure:^(NSError *error) {
                
            }];
        }
    }];
    

}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
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
        [_tableView registerClass:[PendingPaymentOfficePurchaseCell class] forCellReuseIdentifier:PendingPaymentOfficePurchaseCellID];
    }
    return _tableView;
}

@end
