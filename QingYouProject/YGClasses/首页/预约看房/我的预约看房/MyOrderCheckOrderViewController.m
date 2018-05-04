//
//  MyOrderCheckOrderViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyOrderCheckOrderViewController.h"
#import "MyOrderCheckHouseTableViewCell.h"
#import "OrderCheckHouseDetailViewController.h"

@interface MyOrderCheckOrderViewController ()<UITableViewDelegate,UITableViewDataSource,MyOrderCheckHouseTableViewCellDelegate>

@end

@implementation MyOrderCheckOrderViewController
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView.mj_header beginRefreshing];

}
- (void)configAttribute
{
    self.view.frame = self.controllerFrame;
    _listArray = [[NSMutableArray alloc] init];
//    _listArray = (NSMutableArray *)@[@"",@"",@"",@""];
}
- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_MyReservation parameters:@{@"userid":YGSingletonMarco.user.userId,@"type":_type,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        [self endRefreshWithScrollView:_tableView];
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }
        
        [_listArray addObjectsFromArray:[OrderCheckHouseModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        if ([responseObject[@"list"] count] == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)configUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-41) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = colorWithLine;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[MyOrderCheckHouseTableViewCell class] forCellReuseIdentifier:@"MyOrderCheckHouseTableViewCell"];
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderCheckHouseTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderCheckHouseTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderCheckHouseModel *model = _listArray[indexPath.row];
    cell.delegate = self;
    if ([self.type isEqualToString:@"1"]) {
        [cell setModel:model withHiddenCancleButton:YES];
    }else
    {
        [cell setModel:model withHiddenCancleButton:NO];

    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCheckHouseModel *model = _listArray[indexPath.row];
    OrderCheckHouseDetailViewController *vc = [[OrderCheckHouseDetailViewController alloc] init];
    vc.orderId = model.id;
    vc.sourceId = model.belongId;
    vc.cancle = YES;
    if ([self.type isEqualToString:@"1"]) {
        vc.orderId = nil;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)cancleBackOutBtnWithModel:(OrderCheckHouseModel *)model
{
    
    [YGAlertView showAlertWithTitle:@"确认取消预约吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:REQUEST_CancelReservation parameters:@{@"id":model.id} showLoadingView:YES scrollView:nil success:^(id responseObject) {
                [YGAppTool showToastWithText:@"取消预约成功"];
                [self refreshActionWithIsRefreshHeaderAction:YES];
            } failure:^(NSError *error) {
                
            }];
            
        }
    }];
}
@end
