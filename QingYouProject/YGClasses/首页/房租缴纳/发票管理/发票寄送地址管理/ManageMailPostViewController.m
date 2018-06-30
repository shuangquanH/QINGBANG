//
//  ManageMailPostViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ManageMailPostViewController.h"
#import "ManageMailPostModel.h"
#import "AddAddressViewController.h"

#import "WKInvoiceFunctionCell.h"
#import "WKInvoiceAddressTextCell.h"

static NSString *addressCellIdentifier  = @"ManageMailPostTableViewCell";
static NSString *functionCellIdentifier = @"WKInvoiceFunctionCell";

@interface ManageMailPostViewController () <UITableViewDelegate, UITableViewDataSource, WKInvoiceFunctionCellDelegate>
@end

@implementation ManageMailPostViewController {
    NSMutableArray *_dataArray;
    NSMutableArray *_listArray;
    UITableView    *_tableView;
    UIButton       *_addButton;
}

#pragma mark - lift circle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView.mj_header beginRefreshing];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49.5);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.equalTo(self->_addButton.mas_top);
    }];
}
#pragma mark - setup
- (void)configAttribute {
    self.naviTitle = @"管理邮寄地址";
    _dataArray = [NSMutableArray array];
    [self configUI];
}

- (void)configUI {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorInset = UIEdgeInsetsMake(0, KSCAL(30), 0, KSCAL(30));
    [_tableView registerClass:[WKInvoiceAddressTextCell class] forCellReuseIdentifier:addressCellIdentifier];
    [_tableView registerClass:[WKInvoiceFunctionCell class] forCellReuseIdentifier:functionCellIdentifier];
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addButton setTitle:@"添加地址" forState:UIControlStateNormal];
    [_addButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 15)];
    [_addButton setImage:[UIImage imageNamed:@"address_add"] forState:UIControlStateNormal];
    [_addButton setBackgroundColor:colorWithMainColor];
    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigThree];
    [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addButton];
}

#pragma mark - action
//添加地址
- (void)addButtonClick {
    AddAddressViewController *VC = [[AddAddressViewController alloc]init];
    VC.navTitle = @"添加地址";
    VC.state = @"添加";
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {
    [YGNetService YGPOST:REQUEST_AddressList parameters:@{@"userId":YGSingletonMarco.user.userId,@"type":@"0",@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray: [ManageMailPostModel mj_objectArrayWithKeyValuesArray:responseObject[@"addressList"]]];
        if (_dataArray.count < [YGPageSize intValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManageMailPostModel *model = [_dataArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        WKInvoiceAddressTextCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellIdentifier];
        [cell configMailAddress:model];
        return cell;
    }
    WKInvoiceFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:functionCellIdentifier];
    cell.functionDelegate = self;
    [cell configIndexPath:indexPath isDefault:[model.defAddress boolValue]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [tableView fd_heightForCellWithIdentifier:@"ManageMailPostTableViewCell" cacheByIndexPath:indexPath configuration:^(WKInvoiceAddressTextCell *cell) {
            ManageMailPostModel *model = [_dataArray objectAtIndex:indexPath.section];
            [cell configMailAddress:model];
        }];
    }
    return KSCAL(88);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [tableView dequeueReusableCellWithIdentifier:@"footer"];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footer"];
    }
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return KSCAL(20);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ManageMailPostModel *model = [_dataArray objectAtIndex:indexPath.section];
        if (![self.pageType isEqualToString:@"personCenter"]) {
            [self.shippingAddressViewControllerdelegate passModel:model];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - WKInvoiceFunctionCellDelegate
- (void)functionCell:(WKInvoiceFunctionCell *)functionCell didClickType:(NSInteger)type withIndexPath:(NSIndexPath *)indexPath {
    ManageMailPostModel *model = [_dataArray objectAtIndex:indexPath.section];
    if (type == 0) {//设置默认
        if ([model.defAddress boolValue]) return;
        for (ManageMailPostModel *m in _dataArray) {
            m.defAddress = @"0";
        }
        model.defAddress = @"1";
        [self startPostWithURLString:REQUEST_SetDefAddress parameters:@{@"id": model.ID, @"type": @"0"} showLoadingView:NO scrollView:_tableView];
        [_tableView reloadData];
    } else if (type == 1) {//编辑
        AddAddressViewController *VC = [[AddAddressViewController alloc]init];
        VC.model = model;
        VC.navTitle = @"修改地址";
        VC.state = @"修改";
        VC.ID = model.ID;
        [self.navigationController pushViewController:VC animated:YES];
    } else {//删除
        [YGNetService YGPOST:REQUEST_DeteleAddress parameters:@{@"id":model.ID} showLoadingView:NO scrollView:nil success:^(id responseObject) {
            [_dataArray removeObjectAtIndex:indexPath.section];
            [YGAppTool showToastWithText:@"选择删除成功"];
            [_tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark - override
- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject {

    if ([URLString isEqualToString:REQUEST_DeteleAddress]) {
        [YGAppTool showToastWithText:@"选择删除成功"];
        return;
    }
    if ([URLString isEqualToString:REQUEST_SetDefAddress]) {
    
    }
}

- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error {
  
}

@end
