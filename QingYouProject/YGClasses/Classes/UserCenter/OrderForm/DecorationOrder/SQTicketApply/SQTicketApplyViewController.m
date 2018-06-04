//
//  SQTicketApplyViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQTicketApplyViewController.h"
#import "SQTicketApplyListViewController.h"
#import "ManageMailPostViewController.h"

@interface SQTicketApplyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISwitch *sendSwitch;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSArray<NSArray *> *tableData;


@end

@implementation SQTicketApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"开票申请";
    [self setupSubviews];
}

- (void)setupSubviews {
    
    _tableData = @[
                   @[@{@"title": @"发票类型", @"detail": @"纸质发票", @"accessoryType": @(0)},
                     @{@"title": @"发票内容", @"detail": @"明细", @"accessoryType": @(0)},
                     @{@"title": @"发票抬头", @"detail": @"",    @"accessoryType": @(1)}],
                   
                   @[@{@"title": @"是否邮寄", @"detail": @"", @"accessoryType": @(2)},
                     @{@"title": @"邮寄地址", @"detail": @"", @"accessoryType": @(1)}]
                   ];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_tableView];
    
    _confirmButton = [UIButton new];
    [_confirmButton setBackgroundColor:[UIColor redColor]];
    [_confirmButton setTitle:@"提交申请" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_confirmButton];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
        }
        else {
            make.bottom.mas_equalTo(-self.view.layoutMargins.bottom);
        }
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.equalTo(self.confirmButton.mas_top);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData objectAtIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    NSDictionary *dict = [[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = dict[@"title"];
    cell.detailTextLabel.text = dict[@"detail"];
    
    
    NSInteger accessoryType = [dict[@"accessoryType"] integerValue];
    if (accessoryType == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (accessoryType == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryView = self.sendSwitch;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0 && indexPath.row == 2) {//发票抬头列表
        SQTicketApplyListViewController *next = [SQTicketApplyListViewController new];
        [self.navigationController pushViewController:next animated:YES];
        return;
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {//邮寄地址管理
        ManageMailPostViewController *vc = [[ManageMailPostViewController alloc] init];
        vc.pageType = @"personCenter";
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.0;
}

#pragma mark - lazy load
- (UISwitch *)sendSwitch {
    if (!_sendSwitch) {
        _sendSwitch = [[UISwitch alloc] init];
        _sendSwitch.on = YES;
    }
    return _sendSwitch;
}

@end
