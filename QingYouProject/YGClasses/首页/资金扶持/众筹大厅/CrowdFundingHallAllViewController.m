//
//  CrowdFundingHallAllViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CrowdFundingHallAllViewController.h"
#import "CrowdFundingHallModel.h"
#import "CrowdFundingHallTableViewCell.h"
#import "RoadShowHallCrowdFundingViewController.h"

@interface CrowdFundingHallAllViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_listArray;
    NSString *_stateString;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CrowdFundingHallAllViewController

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
    _stateString = @"2";
}

- (void)setModel:(CrowdFundingAddProjectChooseTypeModel *)model
{
    _model = model;
 
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
    RoadShowHallCrowdFundingViewController *roadShowHallCrowdFundingViewController = [[RoadShowHallCrowdFundingViewController alloc] init];
    roadShowHallCrowdFundingViewController.projectID = model.id;
    [self.navigationController pushViewController:roadShowHallCrowdFundingViewController animated:YES];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    [YGNetService YGPOST:REQUEST_getProjects parameters:@{@"projectState":_stateString,@"projectType":_model.id,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
            
        }
        if ([responseObject[@"plist"] count] == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        
        [_listArray addObjectsFromArray:[CrowdFundingHallModel mj_objectArrayWithKeyValuesArray:responseObject[@"plist"]]];

        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        for (CrowdFundingHallModel *model in _listArray) {
            model.process = [NSString stringWithFormat:@"%f",[model.hasRaise floatValue]/[model.raiseGoal floatValue]*100];
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)reloadDataWithState:(NSString *)stateString
{
    _stateString = stateString;
    [self refreshActionWithIsRefreshHeaderAction:YES];
}

@end
