//
//  SQAfterSaleListViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQAfterSaleListViewController.h"
#import "WKAfterSaleRecordCell.h"
#import "WKAfterSaleModel.h"

@interface SQAfterSaleListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<WKAfterSaleModel *> *afterSaleList;

@end

@implementation SQAfterSaleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviTitle = @"售后记录";
    [self setupSubviews];
}

- (void)setupSubviews {
    
    _afterSaleList = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 80;
    _tableView.estimatedSectionHeaderHeight = 0.0;
    _tableView.estimatedSectionFooterHeight = 0.0;
    [self.view addSubview:_tableView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {
    if (headerAction) {
        [SQRequest post:KAPI_AFTERSALERECORD param:nil success:^(id response) {
            if ([response[@"code"] isEqualToString:@"0"]) {
                NSArray *tmp = [NSArray yy_modelArrayWithClass:[WKAfterSaleModel class] json:response[@"data"][@"record_list"]];
                if (tmp.count) {
                    [self.afterSaleList removeAllObjects];
                    [self.afterSaleList addObjectsFromArray:tmp];
                    [self.tableView reloadData];
                }
            }
            else {
                [YGAppTool showToastWithText:response[@"msg"]];
            }
            [self.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [YGAppTool showToastWithText:@"网络错误"];
        }];
    }
    else {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.afterSaleList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKAfterSaleRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WKAfterSaleRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell configInfo:self.afterSaleList[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}



@end
