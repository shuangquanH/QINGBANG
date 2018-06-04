//
//  SQAddTicketApplyViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQAddTicketApplyViewController.h"

#import "SQAddTicketApplyInputCell.h"

@interface SQAddTicketApplyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *selectView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIButton *selectDefaultButton;

@end

@implementation SQAddTicketApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.naviTitle = @"添加抬头";
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
    _selectView = [UIView new];
    _selectView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_selectView];
    
    _selectDefaultButton = [UIButton new];
    [_selectDefaultButton setTitle:@"设置为默认抬头" forState:UIControlStateNormal];
    [_selectDefaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_selectDefaultButton sizeToFit];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    _confirmButton = [UIButton new];
    [_confirmButton setBackgroundColor:[UIColor redColor]];
    [_confirmButton setTitle:@"提交" forState:UIControlStateNormal];
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
    [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.confirmButton.mas_top);
        make.top.equalTo(self.selectView.mas_bottom);
    }];
}

#pragma mark - action

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row <= 5) {
        SQAddTicketApplyInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[SQAddTicketApplyInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell configTitle:@"名称：" placeHodler:@"请输入抬头名称" content:@""];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectCell"];
        [cell.contentView addSubview:self.selectDefaultButton];
        [self.selectDefaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        cell.separatorInset = UIEdgeInsetsMake(0, kScreenW, 0, 0);
    }
    else {
        cell.separatorInset = UIEdgeInsetsZero;
    }
}

@end
