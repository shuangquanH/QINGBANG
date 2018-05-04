//
//  SubscribeWaitToPayViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SubscribeWaitToPayViewController.h"
#import "CrowdFundingHallModel.h"
#import "CrowdFundingHallTableViewCell.h"
#import "SubscribeDetailViewController.h"
#import "MyInvestDetailViewController.h"

@interface SubscribeWaitToPayViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_listArray;
}
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation SubscribeWaitToPayViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    
    
}

- (void)configAttribute
{
    if ([self.pageType isEqualToString:@"myFundSupportMyProject"])
    {
        self.naviTitle = @"我的项目";
        _listArray = [[NSMutableArray alloc]init];
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = colorWithTable;

    }else
    {
        self.naviTitle = @"认购待支付";
        _listArray = [[NSMutableArray alloc]init];
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = colorWithTable;

    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)configUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.sectionHeaderHeight = 10;
    _tableView.backgroundColor = colorWithTable;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[CrowdFundingHallTableViewCell class] forCellReuseIdentifier:@"CrowdFundingHallTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CrowdFundingHallModel *model = _listArray[indexPath.section];
    
    CrowdFundingHallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdFundingHallTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CrowdFundingHallModel *model = _listArray[indexPath.section];
    
    return [tableView fd_heightForCellWithIdentifier:@"CrowdFundingHallTableViewCell" cacheByIndexPath:indexPath configuration:^(CrowdFundingHallTableViewCell *cell) {
        cell.fd_enforceFrameLayout = YES;
        cell.model = model;
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CrowdFundingHallModel *model = _listArray[indexPath.section];
    if (![self.pageType isEqualToString:@"myFundSupportMyProject"])
    {
        MyInvestDetailViewController *roadShowHallCrowdFundingViewController = [[MyInvestDetailViewController alloc] init];
        roadShowHallCrowdFundingViewController.projectID = model.id;
        roadShowHallCrowdFundingViewController.statusType = 1;
        [self.navigationController pushViewController:roadShowHallCrowdFundingViewController animated:YES];
    }else
    {
        SubscribeDetailViewController *roadShowHallCrowdFundingViewController = [[SubscribeDetailViewController alloc] init];
        roadShowHallCrowdFundingViewController.projectID = model.id;
        roadShowHallCrowdFundingViewController.statusType = 2;
        [self.navigationController pushViewController:roadShowHallCrowdFundingViewController animated:YES];
    }
 
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    NSString *url = REQUEST_SearchInvest;
    NSDictionary *dict;
    if ([self.pageType isEqualToString:@"myFundSupportMyProject"]) {
        url = REQUEST_SearchInvest;
        NSLog(@"%@",YGSingletonMarco.user);
        dict = @{@"userId":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString};
        [YGNetService YGPOST:url parameters:dict showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
            
            if (headerAction)
            {
                [_listArray removeAllObjects];
            }
            else
            {
                if ([responseObject[@"schemeSubscribe"] count] == 0)
                {
                    [YGAppTool showToastWithText:NOTICE_NOMORE];
                    [self noMoreDataFormatWithScrollView:_tableView];
                    return;
                }
            }
            [_listArray addObjectsFromArray:[CrowdFundingHallModel mj_objectArrayWithKeyValuesArray:responseObject[@"schemeSubscribe"]]];
            [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
            [_tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
    }else
    {
        url = REQUEST_myInvestment;
        dict = @{@"uId":YGSingletonMarco.user.userId,@"subscribeType":@"1",@"total":self.totalString,@"count":self.countString} ;
        [YGNetService YGPOST:url parameters:dict showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
            if (headerAction == YES) {
                [_listArray removeAllObjects];
                
            }
            if ([responseObject[@"myList"] count] == 0) {
                [self noMoreDataFormatWithScrollView:_tableView];
            }
            
            [_listArray addObjectsFromArray:[CrowdFundingHallModel mj_objectArrayWithKeyValuesArray:responseObject[@"myList"]]];
            
            [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
            
            [_tableView reloadData];
            
        } failure:^(NSError *error) {
            
        }] ;
        
    }
  
    
    
 
}

@end
