//
//  MyRecruitBeInviteInterviewViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/11/16.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyRecruitBeInviteInterviewViewController.h"
#import "MyRecruitBeInviteInterviewTableViewCell.h"
#import "AdvertiseModel.h"

@interface MyRecruitBeInviteInterviewViewController ()<UITableViewDelegate,UITableViewDataSource,MyRecruitBeInviteInterviewTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
}


@end

@implementation MyRecruitBeInviteInterviewViewController

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
    [YGNetService YGPOST:REQUEST_MyDeliverRecord parameters:@{@"userid":YGSingletonMarco.user.userId,@"type":@"2",@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
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
    self.naviTitle = @"";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[MyRecruitBeInviteInterviewTableViewCell class] forCellReuseIdentifier:@"MyRecruitBeInviteInterviewTableViewCell"];
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
    MyRecruitBeInviteInterviewTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRecruitBeInviteInterviewTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AdvertiseModel *model = _listArray[indexPath.section];
    model.indexPath = indexPath;
    cell.delegate = self;
    [cell setModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
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

- (void)acceptInterviewButtonActionWithModel:(AdvertiseModel *)model
{
    [YGNetService YGPOST:REQUEST_AcceptInterview parameters:@{@"id":model.id} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        AdvertiseModel *cellModel = _listArray[model.indexPath.section];
        cellModel.state = @"3";
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
@end
