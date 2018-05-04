//
//  SecondhandReplacementMyFollowViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplacementMyFollowViewController.h"
#import "SecondhandReplacementMyFollowTableViewCell.h"
#import "SecondhandReplacementMyFollowModel.h"
#import "SecondhandReplaceOtherHomePageViewController.h"

@interface SecondhandReplacementMyFollowViewController ()<UITableViewDelegate,UITableViewDataSource,SecondhandReplacementMyFollowTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray * _dataArray;
}

@end


@implementation SecondhandReplacementMyFollowViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = [NSString stringWithFormat:@"我的关注(%@)",self.followCount];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataArray =[[NSMutableArray alloc]init];
    
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
                                 @"type":@"1",
                                 @"count":self.countString,
                                 @"total":self.totalString
                                 };
    NSString *url = @"myPersonlAttention";
    
    //如果不是加载过缓存
//    if (!self.isAlreadyLoadCache)
//    {
//        //加载缓存数据
//        NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
//        [_dataArray addObjectsFromArray:[SecondhandReplacementMyFollowModel mj_objectArrayWithKeyValuesArray:cacheDic[@"uList"]]];
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
                         if ([responseObject[@"uList"] count] == 0)
                         {
                             //调用一下没数据的方法，告诉用户没有更多
                             [self noMoreDataFormatWithScrollView:_tableView];
                             return;
                         }
                     }
                     //将字典数组转化为模型数组，再加入到数据源
                     [_dataArray addObjectsFromArray:[SecondhandReplacementMyFollowModel mj_objectArrayWithKeyValuesArray:responseObject[@"uList"]]];
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
    SecondhandReplaceOtherHomePageViewController * otherHomepage = [[SecondhandReplaceOtherHomePageViewController alloc]init];
    otherHomepage.otherId = ((SecondhandReplacementMyFollowModel *)_dataArray[indexPath.row]).ID;
    [self.navigationController pushViewController:otherHomepage animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SecondhandReplacementMyFollowModel *model = _dataArray[indexPath.row];
    
    SecondhandReplacementMyFollowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SecondhandReplacementMyFollowTableViewCellID];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.row = indexPath.row;
    cell.delegate = self;
    [cell setModel:model];
  
    return cell;
}
- (void)secondhandReplacementMyFollowTableViewCellCannelButton:(UIButton *)btn withRow:(NSInteger)row
{
    [YGAlertView showAlertWithTitle:@"确认要取消关注吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            NSDictionary * parameter = @{
                                         @"uid":YGSingletonMarco.user.userId,
                                         @"oid":((SecondhandReplacementMyFollowModel *)_dataArray[row]).ID,
                                         };
            [YGNetService YGPOST:@"replacementAttention" parameters:parameter showLoadingView:YES scrollView:nil success:^(id responseObject) {
                
                [YGAppTool showToastWithText:@"取消成功"];
                
                [_dataArray removeObjectAtIndex:row];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
                
            } failure:^(NSError *error) {
            
            }];
        }
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return [tableView fd_heightForCellWithIdentifier:SecondhandReplacementMyFollowTableViewCellID cacheByIndexPath:indexPath configuration:^(SecondhandReplacementMyFollowTableViewCell *cell) {

            cell.fd_enforceFrameLayout = YES;
            [cell setModel:_dataArray[indexPath.row]];

        }];
}
static NSString * const SecondhandReplacementMyFollowTableViewCellID = @"SecondhandReplacementMyFollowTableViewCellID";

- (UITableView *)tableView{
    
    if (!_tableView) {
        CGFloat H = kScreenH - YGNaviBarHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.rowHeight = 90;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        [_tableView setSeparatorColor:colorWithLine];
        [_tableView registerClass:[SecondhandReplacementMyFollowTableViewCell class] forCellReuseIdentifier:SecondhandReplacementMyFollowTableViewCellID];
    }
    return _tableView;
}

@end










