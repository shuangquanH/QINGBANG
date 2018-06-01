//
//  SQUserCenterViewController.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/16.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQUserCenterViewController.h"

#import "SQUserCenterTableViewHeader.h"

#import "SQOrderViewController.h"


@interface SQUserCenterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray       *userCenterArr;
@property (nonatomic, strong) SQBaseTableView       *tableview;
@property (nonatomic, strong) SQUserCenterTableViewHeader       *tableHeader;

@end

@implementation SQUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"我的";
    NSString *path = [[NSBundle mainBundle]pathForResource:@"SQUserCenterMenuPlist" ofType:@"plist"];
    self.userCenterArr = [NSArray arrayWithContentsOfFile:path];
    [self.view addSubview:self.tableview];
    self.tableview.tableHeaderView = self.tableHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.userCenterArr.count;
}
- (UIView   *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SQBaseTableViewCell *cell = [SQBaseTableViewCell cellWithTableView:tableView];
    cell.imageView.image = [UIImage imageNamed:@"mine_instashot"];
    cell.textLabel.text = self.userCenterArr[indexPath.section][@"title"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class theclass = NSClassFromString(self.userCenterArr[indexPath.section][@"vc"]);
    RootViewController  *vc = [[theclass alloc] init];
    bool    needlogin = [self.userCenterArr[indexPath.section][@"needLogin"] boolValue];
    if (needlogin) {
        if ([self loginOrNot]) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark LazyLoad
- (SQBaseTableView  *)tableview {
    if (!_tableview) {
        _tableview = [[SQBaseTableView   alloc] initWithFrame:CGRectMake(0, 0, KAPP_WIDTH, KAPP_HEIGHT-KNAV_HEIGHT-KTAB_HEIGHT)];
        _tableview.rowHeight = 60;
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

- (SQUserCenterTableViewHeader *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [[SQUserCenterTableViewHeader alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 220)];
    }
    return _tableHeader;
}

@end
