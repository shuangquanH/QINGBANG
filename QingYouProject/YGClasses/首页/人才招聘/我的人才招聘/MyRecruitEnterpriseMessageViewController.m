//
//  MyRecruitEnterpriseMessageViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/11/16.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyRecruitEnterpriseMessageViewController.h"
#import "AdvertiseModel.h"

@interface MyRecruitEnterpriseMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
}



@end

@implementation MyRecruitEnterpriseMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
- (void)configAttribute
{
    self.naviTitle = @"我的消息";

    _listArray = [[NSMutableArray alloc] init];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_MyRecruitmentCounts parameters:@{@"phone":YGSingletonMarco.user.phone,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }
        
        [_listArray addObjectsFromArray:[AdvertiseModel mj_objectArrayWithKeyValuesArray:responseObject[@"List"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        if ([(NSArray *)responseObject[@"List"] count] == 0)
        {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
- (void)configUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, YGScreenWidth-160, 20)];
        titleLabel.textColor = colorWithDeepGray;
        titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.tag = indexPath.section+10000;
        [cell.contentView addSubview:titleLabel];
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(YGScreenWidth-150, 10, 140, 20)];
        numberLabel.textColor = colorWithBlack;
        numberLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        numberLabel.textAlignment = NSTextAlignmentRight;
        numberLabel.tag = indexPath.section+100;
        [cell.contentView addSubview:numberLabel];
    }
    cell.backgroundColor = colorWithYGWhite;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AdvertiseModel *model = _listArray[indexPath.section];
    UILabel *label = [cell.contentView viewWithTag:100+indexPath.section];
    label.text = [NSString stringWithFormat:@"%@个人已投递",model.count];
    UILabel *titleLabel = [cell.contentView viewWithTag:10000+indexPath.section];
    titleLabel.text = [NSString stringWithFormat:@"诚聘%@",model.name];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
@end
