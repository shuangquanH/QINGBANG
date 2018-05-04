//
//  playTogetherJudgeViewController.m
//  QingYouProject
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "playTogetherJudgeViewController.h"
//#import "OfficePurchaseTableViewCell.h"//评论Cell
#import "ServiceEvalutionModel.h"//模型
#import "PlayTogetherSignupDetailViewController.h"
#import "PlayTogetherDetailSignUpTableViewCell.h"

@interface playTogetherJudgeViewController ()<UITableViewDelegate,UITableViewDataSource>

/** tableView  */
@property (nonatomic,strong) UITableView * tableView;
/** 每个展示几个图片  */
@property (nonatomic,assign) NSInteger imageCount;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSString *isManager;
@property (nonatomic, strong) NSString *allianceID;

@end

@implementation playTogetherJudgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self judgeManager];
    self.imageCount = 4;
   
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = kWhiteColor;   
    
    if([self.pageType isEqualToString:@"LeaveMessage"])
    {
        self.naviTitle = [NSString stringWithFormat:@"留言区(%@)",self.commentCount];
    }
    else
    {
        self.naviTitle = [NSString stringWithFormat:@"报名人数(%@)",self.commentCount];
    }
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    
}

//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    if([self.pageType isEqualToString:@"LeaveMessage"])
    {
        NSDictionary *parameters = @{
                                     @"activityID":self.activityID,
                                     @"count":self.countString,
                                     @"total":self.totalString
                                     };
        NSString *url = @"ActivityComment";
        
        //如果不是加载过缓存
        if (!self.isAlreadyLoadCache)
        {
            //加载缓存数据
            NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
            [self.dataArray addObjectsFromArray:[ServiceEvalutionModel mj_objectArrayWithKeyValuesArray:cacheDic[@"commentList"]]];
            [_tableView reloadData];
            self.isAlreadyLoadCache = YES;
        }
        
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
                             if ([responseObject[@"commentList"] count] == 0)
                             {
                                 //调用一下没数据的方法，告诉用户没有更多
                                 [self noMoreDataFormatWithScrollView:_tableView];
                                 return;
                             }
                         }
                         //将字典数组转化为模型数组，再加入到数据源
                         [self.dataArray addObjectsFromArray:[ServiceEvalutionModel mj_objectArrayWithKeyValuesArray:responseObject[@"commentList"]]];
                         //调用加载无数据图的方法
                         [self addNoDataImageViewWithArray:self.dataArray shouldAddToView:_tableView headerAction:headerAction];
                         [_tableView reloadData];
                     } failure:^(NSError *error)
         {
             [self addNoNetRetryButtonWithFrame:_tableView.frame listArray:self.dataArray];
         }];
    }
    else
    {
        NSDictionary *parameters = @{
                                     @"activityID":self.activityID,
                                     @"count":self.countString,
                                     @"total":self.totalString
                                     };
        NSString *url = @"ActivityMember";
        
        //如果不是加载过缓存
        if (!self.isAlreadyLoadCache)
        {
            //加载缓存数据
            NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
            [self.dataArray addObjectsFromArray:[ServiceEvalutionModel mj_objectArrayWithKeyValuesArray:cacheDic[@"memberList"]]];
            [_tableView reloadData];
            self.isAlreadyLoadCache = YES;
        }
        
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
                             if ([responseObject[@"memberList"] count] == 0)
                             {
                                 //调用一下没数据的方法，告诉用户没有更多
                                 [self noMoreDataFormatWithScrollView:_tableView];
                                 return;
                             }
                         }
                         //将字典数组转化为模型数组，再加入到数据源
                         [self.dataArray addObjectsFromArray:[ServiceEvalutionModel mj_objectArrayWithKeyValuesArray:responseObject[@"memberList"]]];
                         //调用加载无数据图的方法
                         [self addNoDataImageViewWithArray:self.dataArray shouldAddToView:_tableView headerAction:headerAction];
                         [_tableView reloadData];
                     } failure:^(NSError *error)
         {
             [self addNoNetRetryButtonWithFrame:_tableView.frame listArray:self.dataArray];
         }];
    }
    
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.pageType isEqualToString:@"LeaveMessage"])
        return;
    
    if ([self.isManager isEqualToString:@"0"] && [self.allianceID isEqualToString:self.activeAllianceID])
    {
        ServiceEvalutionModel * model = self.dataArray[indexPath.row];
        
        PlayTogetherSignupDetailViewController * signupDetailView = [[PlayTogetherSignupDetailViewController alloc]init];
        signupDetailView.userID = model.userID;
        signupDetailView.activityID = self.activityID;
        [self.navigationController pushViewController:signupDetailView animated:YES];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        PlayTogetherDetailSignUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayTogetherDetailSignUpTableViewCellID" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = colorWithYGWhite;
        cell.fd_enforceFrameLayout = YES;
        if([self.pageType isEqualToString:@"LeaveMessage"])
            cell.typeStr =@"LeaveMessage";

        [cell setModel:self.dataArray[indexPath.row]];
        return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

       return [tableView fd_heightForCellWithIdentifier:@"PlayTogetherDetailSignUpTableViewCellID" cacheByIndexPath:indexPath configuration:^(PlayTogetherDetailSignUpTableViewCell *cell) {
           if([self.pageType isEqualToString:@"LeaveMessage"])
               cell.typeStr =@"LeaveMessage";
           
            cell.fd_enforceFrameLayout = YES;
            [cell setModel:self.dataArray[indexPath.row]];
            
        }];
}
-(void)judgeManager
{

    NSDictionary *parameters = @{
                                 @"userID":YGSingletonMarco.user.userId
                                 };
    NSString *url = @"isManager";
    
    
    [YGNetService YGPOST:url parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
        self.allianceID  = responseObject[@"allianceID"];
        self.isManager  = responseObject[@"isManager"];
        
    } failure:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 150;
        _tableView.sectionHeaderHeight = 0.01;
        _tableView.sectionFooterHeight = 0.01;
        [_tableView setSeparatorColor:colorWithLine];
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
        [self createRefreshWithScrollView:_tableView containFooter:NO];
        //注册cell
            
        [self.tableView registerClass:[PlayTogetherDetailSignUpTableViewCell class] forCellReuseIdentifier:@"PlayTogetherDetailSignUpTableViewCellID"];

        
        if (@available(iOS 11.0, *)) {
            
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
            
        } else {
            
            self.automaticallyAdjustsScrollViewInsets = YES;
            
        }
        
        _tableView.backgroundColor = kWhiteColor;
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end

