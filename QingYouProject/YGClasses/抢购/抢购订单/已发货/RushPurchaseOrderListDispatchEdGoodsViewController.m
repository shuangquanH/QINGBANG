//
//  RushPurchaseOrderListDispatchEdGoodsViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RushPurchaseOrderListDispatchEdGoodsViewController.h"
#import "RushPurchaseOrderListTableViewCell.h"
#import "RushPurchaseOrderListDispatchEdGoodsDetailViewController.h"
#import "RushPurchaseOrderListModel.h"
#import "RushPurchaseOrderRefundViewController.h"

@interface RushPurchaseOrderListDispatchEdGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,RushPurchaseOrderListTableViewCellDelegate,RushPurchaseOrderRefundViewControllerDelegate>
{
    UITableView *_tableView;
    NSMutableArray * _dataArray;
}


@end

@implementation RushPurchaseOrderListDispatchEdGoodsViewController


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
                                 @"type":@"3",
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
    RushPurchaseOrderListDispatchEdGoodsDetailViewController * detailView =[[RushPurchaseOrderListDispatchEdGoodsDetailViewController alloc]init];
    detailView.OrderID =model.falshsaleOrderId;
    detailView.status = 2;
    [self.navigationController pushViewController:detailView animated:YES];
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
    cell.model = model;
    cell.delegate = self;
    [cell setModelValeFalseWithType:[model.type intValue]];
    return cell;
    
}
//退款
- (void)rushPurchaseOrderListTableViewCellReturnMoneyWithButton:(UIButton *)btn withRow:(NSInteger)row
{
    RushPurchaseOrderListModel * model = _dataArray[row];
    RushPurchaseOrderRefundViewController *vc = [[RushPurchaseOrderRefundViewController alloc] init];
    vc.isPush = @"list";
    vc.model = model;
    vc.row = (int)row;
    [self.navigationController pushViewController:vc animated:YES];
}
//确认收货
- (void)rushPurchaseOrderListTableViewCellReceiveGoodWithButton:(UIButton *)btn withRow:(NSInteger)row
{
    RushPurchaseOrderListModel * model = _dataArray[row];
    [YGAlertView showAlertWithTitle:@"是否确认收货？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:REQUEST_checkedFalshsaleOrder parameters:@{@"falshsaleOrderId":model.id} showLoadingView:YES scrollView:nil success:^(id responseObject) {
                [YGAppTool showToastWithText:@"确认收货成功"];
                [self refreshActionWithIsRefreshHeaderAction:YES];
            } failure:nil];
        }
    }];
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


