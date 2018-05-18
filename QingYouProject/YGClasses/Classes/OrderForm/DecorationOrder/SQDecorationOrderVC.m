//
//  SQDecorationOrderVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/17.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationOrderVC.h"
#import "SQDecorationOrderCell.h"
#import "SQDecorationOrderDetailVC.h"

@interface SQDecorationOrderVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SQBaseTableView       *tableview;

@end

@implementation SQDecorationOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"我的装修订单";
    [self.view addSubview:self.tableview];
    [self createRefreshWithScrollView:self.tableview containFooter:YES];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {
    if (headerAction) {
        NSLog(@"下拉刷新");
        [self.tableview.mj_header endRefreshing];
    } else {
        NSLog(@"上拉加载");
        [self.tableview.mj_footer endRefreshing];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SQDecorationOrderCell *cell;
    if (indexPath.row%2==0) {
        cell = [SQDecorationOrderCell cellWithTableView:tableView];
    } else {
        cell = [SQDecorationOrderCellWithThreeStage cellWithTableView:tableView];
    }
    cell.model = @"dd";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SQDecorationOrderDetailVC   *vc = [[SQDecorationOrderDetailVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark LazyLoad
- (SQBaseTableView  *)tableview {
    if (!_tableview) {
        _tableview = [[SQBaseTableView   alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-KNAVHEIGHT)];
        _tableview.backgroundColor = kLightGrayColor;
        _tableview.estimatedRowHeight = 600;
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
