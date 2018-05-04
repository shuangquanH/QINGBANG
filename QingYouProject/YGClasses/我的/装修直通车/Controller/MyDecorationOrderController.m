//
//  MyDecorationOrderController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyDecorationOrderController.h"
#import "DecorationOrderCell.h"
#import "MyDecorationMoneyOrderController.h"
#import "MyDecorationOrderModel.h"

@interface MyDecorationOrderController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation MyDecorationOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"我的装修订单";
    _dataArray = [NSMutableArray array];
    [self configUI];
}
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:@"MyOrderDecoration" parameters:@{@"uid":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if (((NSArray *)responseObject[@"flist"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[MyDecorationOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"flist"]]];
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DecorationOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DecorationOrderCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DecorationOrderCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.orderNumLabel.text = [NSString stringWithFormat:@"订单编号:%@",[self.dataArray[indexPath.row] valueForKey:@"orderNum"]];
    cell.createTimeLabel.text = [NSString stringWithFormat:@"创建时间:%@",[self.dataArray[indexPath.row] valueForKey:@"createDate"]];
    NSString *orderState = [self.dataArray[indexPath.row] valueForKey:@"status"];
    if ([orderState isEqualToString:@"0"]) {
        cell.orderStateLabel.text = @"待付款";
    }
    if ([orderState isEqualToString:@"1"]) {
        cell.orderStateLabel.text = @"已完成";
    }
    if ([orderState isEqualToString:@"2"]) {
        cell.orderStateLabel.text = @"未到期";
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YGScreenWidth * 0.17;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyDecorationMoneyOrderController *vc = [[MyDecorationMoneyOrderController alloc]init];
    vc.orderIdString = [self.dataArray[indexPath.row] valueForKey:@"ID"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
