//
//  AllOfficePurchaseOrderListViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllOfficePurchaseOrderListViewController.h"
#import "AfterSaleCell.h"//售后
#import "DeliveredCell.h"//待发货
#import "PendingPaymentOfficePurchaseCell.h"//待付款
#import "DeliveredCell.h"//待发货
#import "ShippedCell.h"//已发货
#import "TransactionSuccessCell.h"//交易成功
#import "AfterSaleCell.h"//售后cell
#import "WaitPaidViewController.h"//待付款详情
#import "DeliveredAndRefundViewController.h"//待发货详情
#import "ShipAndSuccessViewController.h"//已发货
#import "AllOfficePurchaseModel.h"//订单模型
#import "AllOfficePurchaseDetailModel.h"
#import "OfficePurchaseRefundViewController.h"
#import "GoodsCommentViewController.h"

@interface AllOfficePurchaseOrderListViewController ()<UITableViewDelegate,UITableViewDataSource,PendingPaymentOfficePurchaseCellDelegate,WaitPaidViewControllerDelegate,DeliveredAndRefundViewControllerDelegate,DeliveredCellDelegate,OfficePurchaseRefundViewControllerDelegate,ShippedCellDelegate,TransactionSuccessCellDelegate,AfterSaleCellDelegate>
/** tableView  */
@property (nonatomic,strong) UITableView * tableView;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;
/** 测试数据  */
@property (nonatomic,strong) NSArray * testArray;
@end

@implementation AllOfficePurchaseOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    //网络请求
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];

}    
#pragma mark - 网络请求
//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    NSDictionary *parameters = @{
                                 @"userID":YGSingletonMarco.user.userId,
                                 @"type":@"0",
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AllOfficePurchaseModel * model = self.dataArray[indexPath.row];
    int cellType = [model.type intValue];
    switch (cellType) {
        case 1://待付款
            {
                WaitPaidViewController * vc = [[WaitPaidViewController alloc] init];
                vc.OrderID = model.orderID;
                vc.delegate =self;
                vc.row =(int)indexPath.row;
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 2://待发货
        {
            DeliveredAndRefundViewController * vc = [[DeliveredAndRefundViewController alloc] init]; 
            vc.status = cellType;
            vc.OrderID = model.orderID;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 3://已发货
        {
            ShipAndSuccessViewController * vc = [[ShipAndSuccessViewController alloc] init];
            vc.status = cellType;
            vc.OrderID = model.orderID;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 4://交易成功
        {
            ShipAndSuccessViewController * vc = [[ShipAndSuccessViewController alloc] init];
            vc.status = cellType;
            vc.OrderID = model.orderID;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 5://售后退款中
        {
            DeliveredAndRefundViewController * vc = [[DeliveredAndRefundViewController alloc] init];
            vc.status = cellType;
            vc.OrderID = model.orderID;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6://售后退款成功
        {
            DeliveredAndRefundViewController * vc = [[DeliveredAndRefundViewController alloc] init];
            vc.status = cellType;
            vc.OrderID = model.orderID;
            vc.delegate = self;
            vc.row = (int)indexPath.row;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7://售后退失败
        {
            DeliveredAndRefundViewController * vc = [[DeliveredAndRefundViewController alloc] init];
            vc.status = cellType;
            vc.OrderID = model.orderID;
            vc.delegate = self;
            vc.row = (int)indexPath.row;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}

- (void)deliveredAndRefundViewControllerDeleteWithRow:(int)row
{
    [self.dataArray removeObjectAtIndex:row];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AllOfficePurchaseModel * model = self.dataArray[indexPath.row];
    int cellType = [model.type intValue];
    switch (cellType) {
        case 1://待付款
            {
                PendingPaymentOfficePurchaseCell * cell = [tableView dequeueReusableCellWithIdentifier:PendingPaymentOfficePurchaseCellID];
                cell.delegate =self;
                cell.model = model;
                cell.row =(int)indexPath.row;
                return cell;
            }
            break;
        case 2://待发货
        {
            DeliveredCell * cell = [tableView dequeueReusableCellWithIdentifier:DeliveredCellID];
            cell.model = model;
            cell.delegate =self;
            cell.row = (int)indexPath.row;
            return cell;
        }
            break;
        case 3://已发货
        {
            ShippedCell * cell = [tableView dequeueReusableCellWithIdentifier:ShippedCellID];
            cell.delegate =self;
            cell.row =(int)indexPath.row;
            cell.model = model;

            return cell;
        }
            break;
        case 4://交易成功
        {
            TransactionSuccessCell * cell = [tableView dequeueReusableCellWithIdentifier:TransactionSuccessCellID];
            cell.delegate =self;
            cell.row =(int)indexPath.row;
            cell.model = model;

            return cell;
        }
            break;
        case 5://售后退款中
        {
            AfterSaleCell * cell = [tableView dequeueReusableCellWithIdentifier:AfterSaleCellID];
            
            cell.model = model;

            return cell;
        }
            break;
        case 6://售后退款成功
        {
            AfterSaleCell * cell = [tableView dequeueReusableCellWithIdentifier:AfterSaleCellID];
            cell.delegate =self;
            cell.row =(int)indexPath.row;
            cell.model = model;

            return cell;
        }
            break;
            
            
            default://售后退款失败
        {
            AfterSaleCell * cell = [tableView dequeueReusableCellWithIdentifier:AfterSaleCellID];
            cell.delegate =self;
            cell.row =(int)indexPath.row;
            cell.model = model;

            return cell;
        }
            break;
            
    
        
}
}
- (void)shippedCellSureWithRow:(int)row
{
    [YGAlertView showAlertWithTitle:@"是否确认收货？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            AllOfficePurchaseModel * model = ((AllOfficePurchaseModel *)self.dataArray[row]);
            
            GoodsCommentViewController * vc = [[GoodsCommentViewController alloc] init];
            
            vc.commodityID =model.commodityID;
            vc.isPush =@"list";
            vc.row = row;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }];
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
- (void)goodsCommentViewControllerJudgeBtnWithRow:(int) row
{
    [self.dataArray removeObjectAtIndex:row];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}

- (void)deliveredCellReturnWithRow:(int)row
{
    [self cellReturnWithRow:row];
}
- (void)shippedCellReturnWithRow:(int)row
{
    [self cellReturnWithRow:row];
}
//申请退款
-(void)cellReturnWithRow:(int) row
{
    AllOfficePurchaseModel * model = ((AllOfficePurchaseModel *)self.dataArray[row]);
    AllOfficePurchaseDetailModel * detailModel = [[AllOfficePurchaseDetailModel alloc]init];
    detailModel.orderID =model.orderID;
    detailModel.commodityImg =model.commodityImg;
    detailModel.freight =model.freight;
    detailModel.commodityValue =model.commodityValueName;
    detailModel.commodityCount =model.commodityCount;
    detailModel.commodityPrice =model.commodityPrice;
    detailModel.commodityName =model.commodityName;
    detailModel.totalPrice =model.totalPrice;
    
    OfficePurchaseRefundViewController * officeRefund =[[OfficePurchaseRefundViewController alloc]init];
    officeRefund.model = detailModel;
    officeRefund.delegate = self;
    officeRefund.row =row;
    officeRefund.isPush= @"list";
    [self.navigationController pushViewController:officeRefund animated:YES];
}
//退款
- (void)officePurchaseRefundViewControllerWithCommintRow:(int)row
{
    [self.dataArray removeObjectAtIndex:row];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}
- (void)transactionSuccessCellDeleteWithRow:(int)row
{
    [self.dataArray removeObjectAtIndex:row];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}
- (void)afterSaleCellDelegateDeleteWithRow:(int)row
{
    AllOfficePurchaseModel * model = self.dataArray[row];
    int cellType = [model.type intValue];
    if(cellType ==6)
        [self cellDeleteWitRow:row];
    else
       [self cellReturnWithRow:row];
}
-(void)cellDeleteWitRow:(int)row
{
    [YGAlertView showAlertWithTitle:@"确认删除订单？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
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
//交易成功
static NSString * const TransactionSuccessCellID = @"TransactionSuccessCellID";
//售后
static NSString * const AfterSaleCellID = @"AfterSaleCellID";
//已发货
static NSString * const ShippedCellID = @"ShippedCellID";
//待发货
static NSString * const DeliveredCellID = @"DeliveredCellID";
//待付款
static NSString * const PendingPaymentOfficePurchaseCellID = @"PendingPaymentOfficePurchaseCellID";


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
        [_tableView registerClass:[AfterSaleCell class] forCellReuseIdentifier:AfterSaleCellID];
        [_tableView registerClass:[ShippedCell class] forCellReuseIdentifier:ShippedCellID];
        [_tableView registerClass:[DeliveredCell class] forCellReuseIdentifier:DeliveredCellID];
        [_tableView registerClass:[PendingPaymentOfficePurchaseCell class] forCellReuseIdentifier:PendingPaymentOfficePurchaseCellID];

        [_tableView registerClass:[TransactionSuccessCell class] forCellReuseIdentifier:TransactionSuccessCellID];

    }
    return _tableView;
}

- (NSArray *)testArray{
    
    if (!_testArray) {
        _testArray = @[AfterSaleCellID,ShippedCellID,DeliveredCellID,PendingPaymentOfficePurchaseCellID];
    }
    return _testArray;
}
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
@end
