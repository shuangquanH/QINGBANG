//
//  JobOutsourceTradeRecoredDealingViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "JobOutsourceTradeRecoredDealingViewController.h"
#import "JobOutsourceTradeRecoredTableViewCell.h"
#import "JobOutSourceRecoredModel.h"

@interface JobOutsourceTradeRecoredDealingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    
}


@end

@implementation JobOutsourceTradeRecoredDealingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_MyOutsourcingApply parameters:@{@"userid":YGSingletonMarco.user.userId,@"type":@"2",@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }

        [_listArray addObjectsFromArray:[JobOutSourceRecoredModel mj_objectArrayWithKeyValuesArray:responseObject[@"OutsourcingApplyAuditList"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        if ([responseObject[@"OutsourcingApplyAuditList"] count] == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
- (void)configAttribute
{
    _listArray = [[NSMutableArray alloc] init];
    
}

- (void)configUI
{
    self.view.frame = self.controllerFrame;

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-40) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[JobOutsourceTradeRecoredTableViewCell class] forCellReuseIdentifier:@"JobOutsourceTradeRecoredTableViewCell"];
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobOutsourceTradeRecoredTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"JobOutsourceTradeRecoredTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _listArray[indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JobOutSourceRecoredModel *model = _listArray[section];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    footerView.backgroundColor = colorWithYGWhite;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    lineView.backgroundColor = colorWithTable;
    [footerView addSubview:lineView];
    UILabel  *money = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 35)];
    money.text = [NSString stringWithFormat:@"订单号 %@",model.orderNo];
    money.textAlignment = NSTextAlignmentLeft;
    money.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    money.textColor = colorWithDeepGray;
    [money sizeToFit];
    money.frame = CGRectMake(10,money.y , money.width, 35);
    [footerView addSubview:money];
    
    return footerView;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    JobOutSourceRecoredModel *model = _listArray[section];

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    footerView.backgroundColor = colorWithYGWhite;
    
    UILabel  *money = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , YGScreenWidth-20, 40)];
    money.text = [NSString stringWithFormat:@"您的服务正在受理中！ %@",model.middleTime];
    money.textAlignment = NSTextAlignmentLeft;
    money.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    money.textColor = colorWithDeepGray;
    [money sizeToFit];
    money.frame = CGRectMake(10,money.y , money.width, 40);
    [footerView addSubview:money];
    
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

@end
