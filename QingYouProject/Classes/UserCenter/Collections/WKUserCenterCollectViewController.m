//
//  WKUserCenterCollectViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKUserCenterCollectViewController.h"

#import "WKUserCenterCollectCell.h"
#import "WKUserCenterCollectModel.h"

@interface WKUserCenterCollectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<WKUserCenterCollectModel *> *collectList;

@end

@implementation WKUserCenterCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviTitle = @"我的收藏";
    
    self.collectList = [NSMutableArray array];
    [self setupSubviews];
}

- (void)setupSubviews {
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 0.0;
    self.tableView.estimatedSectionFooterHeight = 0.0;
    self.tableView.estimatedSectionHeaderHeight = 0.0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, KSCAL(30), 0, KSCAL(30));
    self.tableView.rowHeight = KSCAL(210);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.mas_equalTo(0);
    }];
    
    [self createRefreshWithScrollView:self.tableView containFooter:YES];
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {
    if (headerAction) {
        [SQRequest post:KAPI_COLLECTLIST param:nil success:^(id response) {
            [self.tableView.mj_header endRefreshing];
            if ([response[@"code"] isEqualToString:@"0"]) {
                NSArray *tmp = [NSArray yy_modelArrayWithClass:[WKUserCenterCollectModel class] json:response[@"data"][@"collect_list"]];
                if (tmp.count) {
                    [self.collectList removeAllObjects];
                    [self.collectList addObjectsFromArray:tmp];
                    [self.tableView reloadData];
                }
            }
            else {
                [YGAppTool showToastWithText:response[@"msg"]];
            }
        } failure:^(NSError *error) {
            [YGAppTool showToastWithText:@"网络错误"];
            [self.tableView.mj_header endRefreshing];
        }];
    }
    else {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.collectList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKUserCenterCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WKUserCenterCollectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell configCollectInfo:self.collectList[indexPath.row]];
    return cell;
}


@end
