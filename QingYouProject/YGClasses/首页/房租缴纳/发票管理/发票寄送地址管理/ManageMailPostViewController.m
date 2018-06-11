//
//  ManageMailPostViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ManageMailPostViewController.h"
#import "ManageMailPostModel.h"
#import "ManageMailPostTableViewCell.h"
#import "AddAddressViewController.h"

@interface ManageMailPostViewController ()
<UITableViewDelegate,UITableViewDataSource,ManageMailPostTableViewCellDelegate>
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
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, CGFLOAT_MIN)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[ManageMailPostTableViewCell class] forCellReuseIdentifier:[NSString      stringWithFormat:@"ManageMailPostTableViewCell"]];
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

- (void)configFooterForFooter:(UIView *)footerView withSection:(NSInteger)section {
    
    UIView *contentView = [footerView subviews].firstObject;
    if (!contentView.subviews.count) {
        
        footerView.backgroundColor = colorWithYGWhite;
        
        UIButton *defultButton = [[UIButton alloc]initWithFrame:CGRectMake(10,7,80,25)];
        [defultButton setImage:[UIImage imageNamed:@"nochoice_btn_gray"] forState:UIControlStateNormal];
        [defultButton setImage:[UIImage imageNamed:@"choice_btn_green"] forState:UIControlStateSelected];
        [defultButton setTitle:@"默认地址" forState:UIControlStateNormal];
        [defultButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [defultButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [defultButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        [defultButton addTarget:self action:@selector(defultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        defultButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        [defultButton sizeToFit];
        [contentView addSubview:defultButton];
        defultButton.frame = CGRectMake(10,5,defultButton.width+40,30);
        
        UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(10,0,40,40)];
        [editButton setImage:[UIImage imageNamed:@"steward_edit_black"] forState:UIControlStateNormal];
        editButton.contentMode = UIViewContentModeCenter;
        [editButton addTarget:self action:@selector(editButtonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:editButton];
        
        UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(10,0,40,40)];
        [deleteButton setImage:[UIImage imageNamed:@"steward_delete_black"] forState:UIControlStateNormal];
        deleteButton.contentMode = UIViewContentModeCenter;
        [deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:deleteButton];
        deleteButton.frame = CGRectMake(YGScreenWidth-deleteButton.width-10,deleteButton.y,deleteButton.width,deleteButton.height);;
        editButton.frame = CGRectMake(deleteButton.x-editButton.width-15,editButton.y,editButton.width,editButton.height);;
    }
    
    ManageMailPostModel *model = [_dataArray objectAtIndex:section];
    UIButton *defaultButton = contentView.subviews.firstObject;
    defaultButton.tag = 10000+section;
    UIButton *editButton = contentView.subviews[1];
    editButton.tag = 1000+section;;
    UIButton *deleteButton = contentView.subviews[2];
    deleteButton.tag = 555+section;
    if ([model.defAddress isEqualToString:@"1"]) {
        defaultButton.selected = YES;
    }
    else {
        defaultButton.selected = NO;
    }
}

#pragma mark - action
- (void)defultButtonAction:(UIButton *)btn {
    
    for (ManageMailPostModel *model in _dataArray) {
        model.defAddress = @"0";
    }
    
    ManageMailPostModel *model = [_dataArray objectAtIndex:btn.tag-10000];
    if (btn.selected == YES) {
        btn.selected = NO;
        model.defAddress = @"0";
        
    }else
    {
        btn.selected = YES;
        model.defAddress = @"1";
    }
    [self startPostWithURLString:REQUEST_SetDefAddress parameters:@{@"id":model.ID,@"type":@"0"} showLoadingView:NO scrollView:_tableView];
    [_tableView reloadData];
    
}
- (void)deleteButtonAction:(UIButton *)btn {
    //1.更新数据
    ManageMailPostModel *model = [_dataArray objectAtIndex:btn.tag-555];
    [YGNetService YGPOST:REQUEST_DeteleAddress parameters:@{@"id":model.ID} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        [_dataArray removeObjectAtIndex:btn.tag-555];
        [YGAppTool showToastWithText:@"选择删除成功"];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)editButtonButtonAction:(UIButton *)btn {
    ManageMailPostModel *model = _dataArray[btn.tag -1000];
    AddAddressViewController *VC = [[AddAddressViewController alloc]init];
    VC.model = model;
    VC.navTitle = @"修改地址";
    VC.state = @"修改";
    VC.ID = model.ID;
    [self.navigationController pushViewController:VC animated:YES];
}
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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ManageMailPostTableViewCell";
    ManageMailPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    ManageMailPostModel *model = [_dataArray objectAtIndex:indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"ManageMailPostTableViewCell" cacheByIndexPath:indexPath configuration:^(ManageMailPostTableViewCell *cell) {
        ManageMailPostModel *model = [_dataArray objectAtIndex:indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.indexPath = indexPath;
        cell.delegate = self;
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [tableView dequeueReusableCellWithIdentifier:@"footer"];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
    }
    [self configFooterForFooter:footerView withSection:section];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    footerView.backgroundColor = colorWithTable;
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //当离开某行时，让某行的选中状态消失
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    ManageMailPostModel *model = [_dataArray objectAtIndex:indexPath.section];
    if (![self.pageType isEqualToString:@"personCenter"]) {
        [self.shippingAddressViewControllerdelegate passModel:model];
        [self back];
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
