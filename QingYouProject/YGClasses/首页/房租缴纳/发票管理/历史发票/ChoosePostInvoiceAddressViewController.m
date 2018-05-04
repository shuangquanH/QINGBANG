//
//  ChoosePostInvoiceAddressViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/31.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ChoosePostInvoiceAddressViewController.h"
#import "ManageMailPostModel.h"
#import "ManageMailPostTableViewCell.h"
#import "AddAddressViewController.h"
#import "ManageMailPostViewController.h"

@interface ChoosePostInvoiceAddressViewController ()<UITableViewDelegate,UITableViewDataSource,ManageMailPostTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    
}

@end

@implementation ChoosePostInvoiceAddressViewController
{
    NSMutableArray *_dataArray;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self refreshActionWithIsRefreshHeaderAction:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configAttribute];
}
-(void)configAttribute
{
    self.naviTitle = @"管理邮寄地址";
    
    _dataArray = [NSMutableArray array];
    
    [self createBarbuttonWithNormalTitleString:@"管理" selectedTitleString:@"管理" selector:@selector(managerAddressAction:)];
    [self configUI];
    
}
-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[ManageMailPostTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"ManageMailPostTableViewCell"]];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:NO];
    
    //添加地址
    [self addAddress];
}
-(void)addAddress
{
    UIView *bottomBaseView = [[UIView alloc]init];
    bottomBaseView.backgroundColor = colorWithMainColor;
    [self.view addSubview:bottomBaseView];
    [bottomBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.width.mas_equalTo(YGScreenWidth);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    
    //线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = colorWithLine;
    [bottomBaseView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.mas_equalTo(bottomBaseView);
        make.width.mas_equalTo(YGScreenWidth);
        make.height.mas_equalTo(0.5);
    }];
    
    //添加地址按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"添加地址" forState:UIControlStateNormal];
    [addButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 15)];
    [addButton setImage:[UIImage imageNamed:@"address_add"] forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigThree];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomBaseView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.height.mas_equalTo(49.5);
        make.width.mas_equalTo(bottomBaseView);
        make.top.mas_equalTo(lineView.mas_bottom);
    }];
    
}
//添加地址
-(void)addButtonClick
{
    AddAddressViewController *VC = [[AddAddressViewController alloc]init];
    VC.navTitle = @"添加地址";
    VC.state = @"添加";
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_AddressList parameters:@{@"userId":YGSingletonMarco.user.userId,@"type":@"0"} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        
        [_dataArray addObjectsFromArray: [ManageMailPostModel mj_objectArrayWithKeyValuesArray:responseObject[@"addressList"]]];
        if (_dataArray.count == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ManageMailPostTableViewCell";
    ManageMailPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    ManageMailPostModel *model = [_dataArray objectAtIndex:indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"ManageMailPostTableViewCell" cacheByIndexPath:indexPath configuration:^(ManageMailPostTableViewCell *cell) {
        ManageMailPostModel *model = [_dataArray objectAtIndex:indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.indexPath = indexPath;
        cell.delegate = self;
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ManageMailPostModel *model = [_dataArray objectAtIndex:section];
    if ([model.defAddress isEqualToString:@"1"]) {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
    footerView.backgroundColor = colorWithYGWhite;
    UIButton *defultButton = [[UIButton alloc]initWithFrame:CGRectMake(10,7,70,25)];
    [defultButton setImage:[UIImage imageNamed:@"nochoice_btn_gray"] forState:UIControlStateNormal];
    [defultButton setImage:[UIImage imageNamed:@"choice_btn_green"] forState:UIControlStateSelected];
    [defultButton setTitle:@"默认地址" forState:UIControlStateNormal];
    [defultButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [defultButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [defultButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [defultButton addTarget:self action:@selector(defultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    defultButton.tag = 10000+section;
    defultButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [defultButton sizeToFit];
    [footerView addSubview:defultButton];
    defultButton.frame = CGRectMake(10,5,defultButton.width+20,30);;
    
    return footerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    ManageMailPostModel *model = [_dataArray objectAtIndex:section];
    if ([model.defAddress isEqualToString:@"1"]) {
        return 45;
    }
    return 0;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当离开某行时，让某行的选中状态消失
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ManageMailPostModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    [self startPostWithURLString:REQUEST_InvoiceMailingAddress parameters:@{@"id":_invoiceId,@"addressId":model.ID} showLoadingView:YES scrollView:nil];
}

- (void)defultButtonAction:(UIButton *)btn
{
    ManageMailPostModel *model = [_dataArray objectAtIndex:btn.tag-10000];
    
    if (btn.selected == YES) {
        btn.selected = NO;
        
    }else
    {
        btn.selected = YES;
        [self startPostWithURLString:REQUEST_SetDefAddress parameters:@{@"id":model.ID} showLoadingView:NO scrollView:_tableView];
    }
    
}

-(void)managerAddressAction:(UIButton *)btn
{
    
    ManageMailPostViewController *vc = [[ManageMailPostViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    if ([URLString isEqualToString:REQUEST_InvoiceMailingAddress])
    {
        [YGAppTool showToastWithText:@"选择地址成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
    
}



@end
