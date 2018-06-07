//
//  WKUserInfoMessageViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKUserCenterMessageViewController.h"

#import "WKUserCenterMessageCell.h"

#import "WKUserCenterMessageModel.h"

@interface WKUserCenterMessageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<WKUserCenterMessageModel *> *messageList;

@end

@implementation WKUserCenterMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviTitle = @"我的消息";
    self.messageList = [NSMutableArray array];
    
    [self setupSubviews];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupSubviews {
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 0.0;
    self.tableView.estimatedSectionFooterHeight = 0.0;
    self.tableView.estimatedSectionHeaderHeight = 0.0;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.mas_equalTo(0);
    }];
    
    [self createRefreshWithScrollView:self.tableView containFooter:YES];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {
    if (headerAction) {
        [SQRequest post:KAPI_MESSAGELIST param:nil success:^(id response) {
            [self.tableView.mj_header endRefreshing];
            if ([response[@"state"] isEqualToString:@"success"]) {
                NSArray *tmp = [NSArray yy_modelArrayWithClass:[WKUserCenterMessageModel class] json:response[@"data"][@"result"][@"message_list"]];
                if (tmp.count) {
                    [self.messageList removeAllObjects];
                    [self.messageList addObjectsFromArray:tmp];
                    [self.tableView reloadData];
                }
            }
            else {
               [YGAppTool showToastWithText:response[@"data"][@"msg"]];
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
    return self.messageList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKUserCenterMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WKUserCenterMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell configMessageInfo:self.messageList[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120+KSCAL(20);
}


@end
