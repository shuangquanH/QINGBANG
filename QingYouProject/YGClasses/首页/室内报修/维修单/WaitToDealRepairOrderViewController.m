//
//  WaitToDealRepairOrderViewController.m
//  QingYouProject
//
//  Created by apple on 2017/11/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "WaitToDealRepairOrderViewController.h"
#import "DealedCell.h"//已处理cell
#import "OrderDetailListViewController.h"//工单详情
#import "WaitToDealModel.h"
@interface WaitToDealRepairOrderViewController ()<UITableViewDelegate,UITableViewDataSource,DealedCellDelegate>
@property (nonatomic,strong) UITableView * tableView;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation WaitToDealRepairOrderViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectFromString(_controllFrame);
    
    [self.view addSubview:self.tableView];
    //网络请求
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
}
//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    NSDictionary *parameters = @{
                                 @"commenId":YGSingletonMarco.user.userId,
                                 @"workState":@"1",
                                 @"count":self.countString,
                                 @"total":self.totalString
                                 };
    NSString *url = @"SearchIndoor";
    
    //如果不是加载过缓存
//    if (!self.isAlreadyLoadCache)
//    {
//        //加载缓存数据
//        NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
//        [self.dataArray addObjectsFromArray:[WaitToDealModel mj_objectArrayWithKeyValuesArray:cacheDic[@"list1"]]];
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
                         if ([responseObject[@"list1"] count] == 0)
                         {
                             //调用一下没数据的方法，告诉用户没有更多
                             [self noMoreDataFormatWithScrollView:_tableView];
                             return;
                         }
                     }
                     //将字典数组转化为模型数组，再加入到数据源
                     [self.dataArray addObjectsFromArray:[WaitToDealModel mj_objectArrayWithKeyValuesArray:responseObject[@"list1"]]];
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return [tableView fd_heightForCellWithIdentifier:WaitToDealCellID cacheByIndexPath:indexPath configuration:^(WaitToDealCell * cell) {
//
//
//
//    }];
//
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DealedCell * cell = [tableView dequeueReusableCellWithIdentifier:DealedCellID forIndexPath:indexPath];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.tagStr = @"WaitToDealRepairOrder";

    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    cell.row = (int)indexPath.row;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        OrderDetailListViewController * VC = [[OrderDetailListViewController alloc] init];
        VC.IndoorId = ((WaitToDealModel *)self.dataArray[indexPath.row]).ID;
        VC.state = 0;
        VC.isPush =@"My";
        [self.navigationController pushViewController:VC animated:YES];
    
}
static NSString * const DealedCellID = @"DealedCellID";

- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat H = kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, self.view.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.estimatedRowHeight = 120;
        _tableView.rowHeight = 220;

        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.estimatedRowHeight =0 ;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DealedCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:DealedCellID];
        
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
- (void)DealedCellDelegateDeleteBtnClick:(UIButton *)btn withrow:(int)row
{
    [YGAlertView showAlertWithTitle:@"确认取消报修工单吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            dict[@"id"] = ((WaitToDealModel *)self.dataArray[row]).ID;

            [YGNetService YGPOST:@"RevocationIndoor" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {

                [YGAppTool showToastWithText:@"取消成功"];

                [self.dataArray removeObjectAtIndex:row];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
                
            } failure:^(NSError *error) {
                [YGAppTool showToastWithText:@"取消失败"];

            }];
        }
    }];
    
    
}

@end

