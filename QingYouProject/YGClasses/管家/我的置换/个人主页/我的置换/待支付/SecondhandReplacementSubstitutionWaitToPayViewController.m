//
//  SecondhandReplacementSubstitutionWaitToPayViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplacementSubstitutionWaitToPayViewController.h"
#import "SecondhandReplacementSubstitutionWaitToGoodsTableViewCell.h"
#import "SecondhandReplacementIBoughtModel.h"
#import "SecondHandPayController.h"

@interface SecondhandReplacementSubstitutionWaitToPayViewController ()<UITableViewDelegate,UITableViewDataSource,SecondhandReplacementSubstitutionWaitToGoodsTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray * _dataArray;
}
@end     

@implementation SecondhandReplacementSubstitutionWaitToPayViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_tableView.mj_header beginRefreshing];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectFromString(_controllFrame);
    
    _dataArray= [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    //网络请求
        [self createRefreshWithScrollView:_tableView containFooter:YES];
    
}
#pragma mark - 网络请求
//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    NSDictionary *parameters = @{
                                 @"uid":YGSingletonMarco.user.userId,
                                 @"roleType":@"1",
                                 @"status":@"1",
                                 @"count":self.countString,
                                 @"total":self.totalString
                                 };
    NSString *url = @"myReplacementByRes";
    
    //如果不是加载过缓存
//    if (!self.isAlreadyLoadCache)
//    {
//        //加载缓存数据
//        NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
//        [_dataArray addObjectsFromArray:[SecondhandReplacementIBoughtModel mj_objectArrayWithKeyValuesArray:cacheDic[@"rList"]]];
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
                         [_dataArray removeAllObjects];
                     }
                     //如果是加载
                     else
                     {
                         //判断服务器返回的数组是不是没数据了，如果没数据
                         if ([responseObject[@"rList"] count] == 0)
                         {
                             //调用一下没数据的方法，告诉用户没有更多
                             [self noMoreDataFormatWithScrollView:_tableView];
                             return;
                         }
                     }
                     //将字典数组转化为模型数组，再加入到数据源
                  [_dataArray addObjectsFromArray:[SecondhandReplacementIBoughtModel mj_objectArrayWithKeyValuesArray:responseObject[@"rList"]]];
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
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SecondhandReplacementSubstitutionWaitToGoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SecondhandReplacementSubstitutionWaitToGoodsTableViewCellID];
    cell.row = indexPath.row;
    cell.delegate = self;
    [cell setModel:((SecondhandReplacementIBoughtModel*)_dataArray[indexPath.row])];
    return cell;
    
}

- (void)secondhandReplacementSubstitutionWaitToGoodsTableViewCellPayButton:(UIButton *)paybtn withRow:(NSInteger)row
{
    SecondHandPayController *vc = [[SecondHandPayController alloc]init];
    vc.orderNumberString = ((SecondhandReplacementIBoughtModel*)_dataArray[row]).orderNum;
    vc.payType =@"2";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)secondhandReplacementSubstitutionWaitToGoodsTableViewCellLogisticsButton:(UIButton *)btn withRow:(NSInteger)row
{
    [YGAlertView showAlertWithTitle:@"确认要删除订单吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            dict[@"orderNum"] = ((SecondhandReplacementIBoughtModel*)_dataArray[row]).orderNum;
            [YGNetService YGPOST:@"replacementDelOrder" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
                
                [YGAppTool showToastWithText:@"删除成功"];
                
                [_dataArray removeObjectAtIndex:row];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
                
            } failure:^(NSError *error) {
                [YGAppTool showToastWithText:@"删除失败"];
            }];
        }
    }];

}

static NSString * const SecondhandReplacementSubstitutionWaitToGoodsTableViewCellID = @"SecondhandReplacementSubstitutionWaitToGoodsTableViewCellID";

- (UITableView *)tableView{
    
    if (!_tableView) {
        CGFloat H = kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 190;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[SecondhandReplacementSubstitutionWaitToGoodsTableViewCell class] forCellReuseIdentifier:SecondhandReplacementSubstitutionWaitToGoodsTableViewCellID];
    }
    return _tableView;
}

@end







