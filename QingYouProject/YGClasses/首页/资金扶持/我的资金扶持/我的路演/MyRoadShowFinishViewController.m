//
//  MyRoadShowFinishViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyRoadShowFinishViewController.h"
#import "RoadShowHallAllTableViewCell.h"
#import "RoadShowHallModel.h"

#import "RoadShowHallDetailViewController.h"
#import "RoadShowHallCrowdFundingViewController.h"

@interface MyRoadShowFinishViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_listArray;
    UIButton *_startTimeButton;
    UIButton *_endTimeButton;
    NSString *_startTimeStr;
    NSString *_endTimeStr;
    UIView *_clearBackGroundView;
    int  _selectBtnIndex; //1是开始 2是结束
}


@end

@implementation MyRoadShowFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    
}

- (void)configAttribute
{
    _listArray = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = colorWithTable;
    self.view.frame = self.controllerFrame;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)configUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, self.view.height) style:UITableViewStyleGrouped];
    _tableView.sectionHeaderHeight = 10;
    _tableView.backgroundColor = colorWithTable;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[RoadShowHallAllTableViewCell class] forCellReuseIdentifier:@"FundSupportTableViewCell"];
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
    RoadShowHallModel *model = _listArray[indexPath.section];
    
    RoadShowHallAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundSupportTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (YGScreenWidth-20)*0.56+70;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RoadShowHallModel *model = _listArray[indexPath.section];
        RoadShowHallDetailViewController *controller = [[RoadShowHallDetailViewController alloc]init];
        controller.roadShowProjectModel = model;
        [self.navigationController pushViewController:controller animated:YES];
        
    
}

static NSString * extracted() {
    return REQUEST_SearchProject;
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    [YGNetService YGPOST:extracted() parameters:@{@"userId":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
            
        }
        if ([responseObject[@"list"] count] == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        
        [_listArray addObjectsFromArray:[RoadShowHallModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}



@end
