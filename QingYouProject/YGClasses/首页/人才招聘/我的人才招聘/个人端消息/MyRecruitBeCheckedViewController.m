//
//  MyRecruitBeCheckedViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/11/16.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyRecruitBeCheckedViewController.h"
#import "MyRecruitBeCheckedTableViewCell.h"

@interface MyRecruitBeCheckedViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
}


@end

@implementation MyRecruitBeCheckedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
- (void)configAttribute
{
    self.view.frame = self.controllerFrame;
    _listArray = [[NSMutableArray alloc] init];
}
- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_MyDeliverRecord parameters:@{@"userid":YGSingletonMarco.user.userId,@"type":@"1",@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }
        
        [_listArray addObjectsFromArray:[AdvertiseModel mj_objectArrayWithKeyValuesArray:responseObject[@"RecruitmentInformation"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        if ([(NSArray *)responseObject[@"RecruitmentInformation"] count] == 0) {
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[MyRecruitBeCheckedTableViewCell class] forCellReuseIdentifier:@"MyRecruitBeCheckedTableViewCell"];
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
    MyRecruitBeCheckedTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRecruitBeCheckedTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AdvertiseModel *model = _listArray[indexPath.section];
    model.indexPath = indexPath;
    [cell setModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    AdvertisesForInfoDetailViewController *vc = [[AdvertisesForInfoDetailViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)deliverCurriculumButtonAction:(UIButton *)btn
{
    if (btn.tag == 100000) {
    }
}


@end
