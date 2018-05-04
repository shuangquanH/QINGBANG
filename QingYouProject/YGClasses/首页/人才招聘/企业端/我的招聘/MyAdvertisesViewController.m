//
//  MyAdvertisesViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyAdvertisesViewController.h"
#import "AdvertisesForInfoTableViewCell.h"
#import "AdvertisesForEnterpriseViewController.h"
#import "AdvertiseModel.h"
#import "AdvertisesForInfoDetailViewController.h"

@interface MyAdvertisesViewController ()<UITableViewDelegate,UITableViewDataSource,AdvertisesForInfoTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    
}

@end

@implementation MyAdvertisesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
- (void)configAttribute
{
    self.naviTitle = @"我的招聘";
    _listArray = [[NSMutableArray alloc] init];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_MyRecruitmentList parameters:@{@"phone":YGSingletonMarco.user.phone,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }

        [_listArray addObjectsFromArray:[AdvertiseModel mj_objectArrayWithKeyValuesArray:responseObject[@"List"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        if ([(NSArray *)responseObject[@"List"] count] == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
            return ;
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
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[AdvertisesForInfoTableViewCell class] forCellReuseIdentifier:@"AdvertisesForInfoTableViewCellEnterprise"];
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
    AdvertisesForInfoTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"AdvertisesForInfoTableViewCellEnterprise" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
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
    AdvertiseModel *model = _listArray[indexPath.section];
    AdvertisesForInfoDetailViewController *vc = [[AdvertisesForInfoDetailViewController alloc] init];
    vc.recruitmentItemId = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


-(void)deleteAdvertiseWithModel:(AdvertiseModel *)model
{
    [YGAlertView showAlertWithTitle:@"确定删除这条招聘消息吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [YGNetService YGPOST:REQUEST_RecruitmentDel parameters:@{@"id":model.id} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
                [_listArray removeObjectAtIndex:model.indexPath.section];
                [_tableView reloadData];
            } failure:^(NSError *error) {
                
            }];
        }
   
    }];
}

-(void)back
{
    if ([self.pageType isEqualToString:@"issueAdvertisement"]) {
        UINavigationController *navc = self.navigationController;
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        for (UIViewController *vc in [navc viewControllers]) {
            [viewControllers addObject:vc];
            if ([vc isKindOfClass:[AdvertisesForEnterpriseViewController class]]) {
                break;
            }
        }
        [navc setViewControllers:viewControllers];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
@end
