//
//  ShippedViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ShippedViewController.h"
#import "ShippedCell.h"
#import "AllOfficePurchaseModel.h"//订单模型
#import "ShipAndSuccessViewController.h"//已发货订单详情
#import "AllOfficePurchaseDetailModel.h"
#import "OfficePurchaseRefundViewController.h"
#import "GoodsCommentViewController.h"

@interface ShippedViewController ()<UITableViewDelegate,UITableViewDataSource,ShippedCellDelegate,OfficePurchaseRefundViewControllerDelegate>
/** tableView  */
@property (nonatomic,strong) UITableView * tableView;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation ShippedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithTable;
    
    [self.view addSubview:self.tableView];
    //网络请求
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReloadShipView:) name:@"ReloadShipView" object:nil];
    
}
- (void)ReloadShipView:(NSNotification *)notifit {
    NSString * rowStr =[notifit object];
    
    [self.dataArray removeObjectAtIndex:rowStr.intValue];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:rowStr.intValue inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    
}
#pragma mark - 网络请求
//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    NSDictionary *parameters = @{
                                 @"userID":YGSingletonMarco.user.userId,
                                 @"type":@"3",
                                 @"count":self.countString,
                                 @"total":self.totalString
                                 };
    NSString *url = @"ProcurementAllOrder";
    
    //如果不是加载过缓存
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

static NSString * const ShippedCellID = @"ShippedCellID";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShippedCell * cell = [tableView dequeueReusableCellWithIdentifier:ShippedCellID];
    cell.delegate =self;
    cell.row =(int)indexPath.row;
    cell.model = self.dataArray[indexPath.row];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AllOfficePurchaseModel * model = self.dataArray[indexPath.row];
    ShipAndSuccessViewController * vc = [[ShipAndSuccessViewController alloc] init];
    vc.status = [model.type intValue];
    vc.OrderID = model.orderID;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)shippedCellSureWithRow:(int)row
{
        [YGAlertView showAlertWithTitle:@"是否确认收货？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return ;
            }else
            {
                AllOfficePurchaseModel * model = self.dataArray[row];

                [YGNetService YGPOST:@"ProcurementTakeOrder" parameters:@{@"orderID":model.orderID} showLoadingView:YES scrollView:nil success:^(id responseObject) {
                    
                    GoodsCommentViewController * vc = [[GoodsCommentViewController alloc] init];
                    
                    vc.commodityID =model.commodityID;
                    vc.isPush =@"list";
//                    vc.delegate = self;
                    vc.row = row;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    [self.dataArray removeObjectAtIndex:row];
                    
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
                    
                } failure:nil];
            }
        }];
}

- (void)shippedCellReturnWithRow:(int)row
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
- (void)officePurchaseRefundViewControllerWithCommintRow:(int)row
{
    [self.dataArray removeObjectAtIndex:row];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}
- (UITableView *)tableView{
    
    if (!_tableView) {
        CGFloat H = KAPP_HEIGHT - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KAPP_WIDTH, H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 230;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_tableView registerClass:[ShippedCell class] forCellReuseIdentifier:ShippedCellID];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
