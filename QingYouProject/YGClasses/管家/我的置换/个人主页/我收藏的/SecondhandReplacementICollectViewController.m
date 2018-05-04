//
//  SecondhandReplacementICollectViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplacementICollectViewController.h"
#import "SecondhandReplacementICollectTableViewCell.h"
#import "BabyDetailsController.h"
#import "SecondhandPeplaceCollectModel.h"

@interface SecondhandReplacementICollectViewController ()<UITableViewDelegate,UITableViewDataSource,SecondhandReplacementICollectTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray * _dataArray;
}
@end

@implementation SecondhandReplacementICollectViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_tableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle =@"我收藏的";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight) style:UITableViewStyleGrouped];
    [_tableView registerClass:[SecondhandReplacementICollectTableViewCell class] forCellReuseIdentifier:@"SecondhandReplacementICollectTableViewCell"];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 10;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    if (@available(iOS 11.0, *))
    {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _dataArray = [[NSMutableArray alloc]init];
    //网络请求
     [self createRefreshWithScrollView:_tableView containFooter:YES];
}

#pragma mark - 网络请求
//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    NSDictionary *parameters = @{
                                 @"uid":YGSingletonMarco.user.userId,
                                 @"count":self.countString,
                                 @"total":self.totalString
                                 };
    NSString *url = @"myReplacementCollection";
    
    //如果不是加载过缓存
//    if (!self.isAlreadyLoadCache)
//    {
//        //加载缓存数据
//        NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
//                [_dataArray addObjectsFromArray:[SecondhandPeplaceCollectModel mj_objectArrayWithKeyValuesArray:cacheDic[@"cList"]]];
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
                         if ([responseObject[@"cList"] count] == 0)
                         {
                             //调用一下没数据的方法，告诉用户没有更多
                             [self noMoreDataFormatWithScrollView:_tableView];
                             return;
                         }
                     }
                     //将字典数组转化为模型数组，再加入到数据源
                       [_dataArray addObjectsFromArray:[SecondhandPeplaceCollectModel mj_objectArrayWithKeyValuesArray:responseObject[@"cList"]]];
                     //调用加载无数据图的方法
                     [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:headerAction];
                     [_tableView reloadData];
                 } failure:^(NSError *error)
     {
         [self addNoNetRetryButtonWithFrame:_tableView.frame listArray:_dataArray];
     }];
}

- (void)secondhandReplacementICollectTableViewCellCancelButton:(UIButton *)btn withRow:(NSInteger)row
{
    [YGAlertView showAlertWithTitle:@"确认取消收藏吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            dict[@"mid"] = ((SecondhandPeplaceCollectModel *)_dataArray[row]).mid;
            dict[@"uid"] = YGSingletonMarco.user.userId;
            
            [YGNetService YGPOST:@"replacementCollection" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
                
                [YGAppTool showToastWithText:@"取消成功"];
                
                [_dataArray removeObjectAtIndex:row];
                 [_tableView deleteSections:[NSIndexSet indexSetWithIndex:row] withRowAnimation:UITableViewRowAnimationNone];
                
            } failure:^(NSError *error) {
                [YGAppTool showToastWithText:@"取消失败"];
            }];
        }
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondhandReplacementICollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondhandReplacementICollectTableViewCell" forIndexPath:indexPath];
    cell.delegate =self;
    cell.row =indexPath.section;
    
    if(_dataArray.count)
    {
        cell.model = _dataArray[indexPath.section];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (YGScreenWidth - 30) / 3 + 130;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * delFlag = ((SecondhandPeplaceCollectModel *)_dataArray[indexPath.section]).delFlag;
    if([delFlag isEqualToString:@"1"])
    {
        [YGAppTool showToastWithText:@"该商品已被删除"];
        return;
    }
    BabyDetailsController *vc = [[BabyDetailsController alloc]init];
    vc.idString = ((SecondhandPeplaceCollectModel *)_dataArray[indexPath.section]).mid;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
