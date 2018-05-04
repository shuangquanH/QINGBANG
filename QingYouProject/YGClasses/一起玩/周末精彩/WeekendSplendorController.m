//
//  WeekendSplendorController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/11.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "WeekendSplendorController.h"
#import "PlayTogetherCell.h"
#import "PlayTogetherDetailViewController.h"
#import "PlayTogetherDetailViewController.h"

@interface WeekendSplendorController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation WeekendSplendorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"周末精彩";
    self.dataArray = [NSMutableArray array];
    [self configUI];
}

//加载数据
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:@"getActivityByTagId" parameters:@{@"userID":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString,@"tid":@"0"} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        if (((NSArray *)responseObject[@"aList"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[ActivityListModel mj_objectArrayWithKeyValuesArray:responseObject[@"aList"]]];
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = 0.0001;
    _tableView.sectionHeaderHeight = 0.0001;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayTogetherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayTogetherCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PlayTogetherCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YGScreenWidth * 0.84;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayTogetherDetailViewController * detail = [[PlayTogetherDetailViewController alloc]init];
    detail.activityID = [self.dataArray[indexPath.row] valueForKey:@"ID"];
    detail.official = [self.dataArray[indexPath.row] valueForKey:@"official"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
