//
//  WKInvoiceAddressViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKInvoiceAddressViewController.h"
#import "WKAddInvoiceAddressViewController.h"

#import "WKInvoiceAddressModel.h"
#import "WKInvoiceAddressTextCell.h"
#import "WKInvoiceFunctionCell.h"

@interface WKInvoiceAddressViewController ()<UITableViewDelegate,UITableViewDataSource, WKInvoiceFunctionCellDelegate>

@end

static NSString *addressCellIdentifier  = @"ManageMailPostTableViewCell";
static NSString *functionCellIdentifier = @"WKInvoiceFunctionCell";


@implementation WKInvoiceAddressViewController {
    NSMutableArray *_dataArray;
    NSMutableArray *_listArray;
    UITableView    *_tableView;
    UIButton       *_addButton;
}


#pragma mark - lift circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configAttribute];
//    [SQRequest setApiAddress:KAPI_ADDRESS_TEST_YSH];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_dataArray) {
        [_tableView.mj_header beginRefreshing];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(100));
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.equalTo(_addButton.mas_top);
    }];
}
#pragma mark - setup
- (void)configAttribute {
    self.naviTitle = @"管理邮寄地址";
    [self configUI];
}

- (void)configUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorInset = UIEdgeInsetsMake(0, KSCAL(30), 0, KSCAL(30));
    [_tableView registerClass:[WKInvoiceAddressTextCell class] forCellReuseIdentifier:addressCellIdentifier];
    [_tableView registerClass:[WKInvoiceFunctionCell class] forCellReuseIdentifier:functionCellIdentifier];
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:NO];
    
    _addButton = [UIButton buttonWithTitle:@"添加地址" titleFont:KSCAL(38) titleColor:[UIColor whiteColor] bgColor:KCOLOR_MAIN];
    [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addButton];
}
#pragma mark - action
//添加地址
- (void)addButtonClick {
    [self pushToAddressByAddressModel:nil];
}

- (void)refreshHeaderAction {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    [SQRequest post:KAPI_INVOICEADDRESSLIST param:nil success:^(id response) {
        if ([response[@"code"] longLongValue] == 0) {
            NSArray *tmp = [NSArray yy_modelArrayWithClass:[WKInvoiceAddressModel class] json:response[@"data"][@"addressList"]];
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:tmp];
            [_tableView reloadData];
        } else {
            [YGAppTool showToastWithText:response[@"msg"]];
        }
        [_tableView.mj_header endRefreshing];
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];
    } failure:^(NSError *error) {
        [YGAppTool showToastWithText:@"网络错误"];
        [_tableView.mj_header endRefreshing];
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];
    }];
}

- (void)pushToAddressByAddressModel:(WKInvoiceAddressModel *)addressModel {
    WKAddInvoiceAddressViewController *next = [WKAddInvoiceAddressViewController new];
    next.editAddress = addressModel;
    [self.navigationController pushViewController:next animated:YES];
    NSInteger index = [_dataArray indexOfObject:addressModel];
    
    next.addressHandler = ^(WKInvoiceAddressModel *model) {
        (void)index;
        if (model) {
            [_dataArray replaceObjectAtIndex:index withObject:model];
            [_tableView reloadData];
        } else {
            [_tableView.mj_header beginRefreshing];
        }
    };
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKInvoiceAddressModel *model = [_dataArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        WKInvoiceAddressTextCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellIdentifier];
        [cell configAddress:model];
        return cell;
    }
    WKInvoiceFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:functionCellIdentifier];
    cell.functionDelegate = self;
    [cell configIndexPath:indexPath isDefault:model.isdef];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        @weakify(self)
        return [tableView fd_heightForCellWithIdentifier:addressCellIdentifier cacheByIndexPath:indexPath configuration:^(WKInvoiceAddressTextCell *cell) {
            @strongify(self)
            WKInvoiceAddressModel *model = [self->_dataArray objectAtIndex:indexPath.section];
            [cell configAddress:model];
        }];
    }
    return KSCAL(88);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return KSCAL(25);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    if (!footer) {
        footer = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footer"];
    }
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) return;
    WKInvoiceAddressModel *model = [_dataArray objectAtIndex:indexPath.section];
    if (self.addressSelecter) {
        self.addressSelecter(model);
    }
}
#pragma mark - WKInvoiceFunctionCellDelegate
- (void)functionCell:(WKInvoiceFunctionCell *)functionCell didClickType:(NSInteger)type withIndexPath:(NSIndexPath *)indexPath {
    WKInvoiceAddressModel *model = _dataArray[indexPath.section];
    if (type == 0) {//设置默认
        if (model.isdef) {//已经是默认
            return;
        }
        [SQRequest post:KAPI_INVOICEADDRESSSETDEFAUTL param:@{@"id": model.ID} success:^(id response) {
            if ([response[@"code"] longLongValue] == 0) {
                for (WKInvoiceAddressModel *m in _dataArray) {
                    m.isdef = NO;
                }
                model.isdef = YES;
                [_tableView reloadData];
            } else {
                [YGAppTool showToastWithText:response[@"msg"]];
            }
        } failure:^(NSError *error) {
            [YGAppTool showToastWithText:@"网络错误"];
        }];
    } else if (type == 1) {//编辑
        [self pushToAddressByAddressModel:model];
    } else {//删除
        [SQRequest post:KAPI_INVOICEADDRESSDELETE param:@{@"id": model.ID} success:^(id response) {
            if ([response[@"code"] longLongValue] == 0) {
                [_dataArray removeObjectAtIndex:indexPath.section];
                [_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                [YGAppTool showToastWithText:response[@"msg"]];
            }
            [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];
        } failure:^(NSError *error) {
            [YGAppTool showToastWithText:@"网络错误"];
        }];
    }
}


@end
