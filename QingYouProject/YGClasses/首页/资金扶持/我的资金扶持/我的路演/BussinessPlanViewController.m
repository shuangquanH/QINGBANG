//
//  BussinessPlanViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/15.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "BussinessPlanViewController.h"
#import "BussinessPlanTableViewCell.h"
#import "BussinessPlanModel.h"

@interface BussinessPlanViewController ()<UITableViewDataSource,UITableViewDelegate>
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

@implementation BussinessPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.backgroundColor = colorWithTable;
    _tableView.sectionFooterHeight = 10;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[BussinessPlanTableViewCell class] forCellReuseIdentifier:@"BussinessPlanTableViewCell"];
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
    BussinessPlanModel *model = _listArray[indexPath.section];
    
    BussinessPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BussinessPlanTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.fd_enforceFrameLayout = YES;

    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BussinessPlanModel *model = _listArray[indexPath.section];
    return [tableView fd_heightForCellWithIdentifier:@"BussinessPlanTableViewCell" cacheByIndexPath:indexPath configuration:^(BussinessPlanTableViewCell *cell) {
        cell.fd_enforceFrameLayout = YES;
        cell.model = model;
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    RoadShowHallDetailViewController *controller = [[RoadShowHallDetailViewController alloc]init];
//    [self.navigationController pushViewController:controller animated:YES];
    

    
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    [YGNetService YGPOST:REQUEST_SearchApplication parameters:@{@"userId":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
            
        }
        if ([responseObject[@"list1"] count] == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        
        [_listArray addObjectsFromArray:[BussinessPlanModel mj_objectArrayWithKeyValuesArray:responseObject[@"list1"]]];
        
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

@end
