//
//  MyInvestSubViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyInvestSubViewController.h"
#import "CrowdFundingHallModel.h"
#import "CrowdFundingHallTableViewCell.h"
#import "MyInvestDetailViewController.h"

@interface MyInvestSubViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_listArray;
}
@property (nonatomic, strong) UITableView *tableView;



@end

@implementation MyInvestSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshActionWithIsRefreshHeaderAction:YES];
}
- (void)configAttribute
{
    _listArray = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = colorWithTable;
    self.view.frame = self.controllerFrame;
    
}



- (void)configUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64-45) style:UITableViewStyleGrouped];
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
    MyInvestDetailViewController *roadShowHallCrowdFundingViewController = [[MyInvestDetailViewController alloc] init];
    roadShowHallCrowdFundingViewController.projectID = model.id;
    roadShowHallCrowdFundingViewController.statusType = [self.subscribeType intValue];
    [self.navigationController pushViewController:roadShowHallCrowdFundingViewController animated:YES];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_myInvestment parameters:@{@"uId":YGSingletonMarco.user.userId,@"subscribeType":self.subscribeType,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
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
@end
