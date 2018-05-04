//
//  MeetingBookViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MeetingBookViewController.h"
#import "MeetingBookCell.h"
#import "MeetingDetailsViewController.h"
#import "MeetingOrderViewController.h"
#import "MeetingPayingViewController.h"
#import "ReservationController.h"
#import "MeetingBookingModel.h"

@interface MeetingBookViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation MeetingBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"会议室预定";
    _dataArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.estimatedRowHeight = YGScreenWidth * 0.76;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 10;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
}
//加载数据
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_getRoomByArea parameters:@{@"total":self.totalString,@"count":self.countString,@"areaId":self.idString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if (((NSArray *)responseObject[@"aList"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[MeetingBookingModel mj_objectArrayWithKeyValuesArray:responseObject[@"aList"]]];
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingBookCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MeetingBookCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    cell.model = _dataArray[indexPath.section];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return 3;
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingDetailsViewController *mdVC = [[MeetingDetailsViewController alloc]init];
    mdVC.idString = [_dataArray[indexPath.row] valueForKey:@"ID"];
    [self.navigationController pushViewController:mdVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
