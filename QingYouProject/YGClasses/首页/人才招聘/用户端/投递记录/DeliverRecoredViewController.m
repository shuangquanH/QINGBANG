//
//  DeliverRecoredViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "DeliverRecoredViewController.h"
#import "AdvertisesForInfoTableViewCell.h"

@interface DeliverRecoredViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    
}

@end

@implementation DeliverRecoredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
- (void)configAttribute
{
    _listArray = [[NSMutableArray alloc] init];
}
- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_DeliverRecord parameters:@{@"userid":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }

        [_listArray addObjectsFromArray:[AdvertiseModel mj_objectArrayWithKeyValuesArray:responseObject[@"RecruitmentInformation"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        if ([(NSArray *)responseObject[@"RecruitmentInformation"] count] == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
            return ;
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)configUI
{
    self.naviTitle = @"投递记录";
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
    [_tableView registerClass:[AdvertisesForInfoTableViewCell class] forCellReuseIdentifier:@"AdvertisesForInfoTableViewCellDeliverRecored"];
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
    AdvertisesForInfoTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"AdvertisesForInfoTableViewCellDeliverRecored" forIndexPath:indexPath];
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
    if (section == 0) {
        return 1;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    AdvertiseModel *model = _listArray[section];

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    footerView.backgroundColor = colorWithYGWhite;
    
    UILabel  *money = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , YGScreenWidth-20, 40)];
    money.text = model.company;
    money.textAlignment = NSTextAlignmentLeft;
    money.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    money.textColor = colorWithDeepGray;
    [money sizeToFit];
    money.frame = CGRectMake(10,money.y , money.width, 40);
    [footerView addSubview:money];
    
    UILabel  *identifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(money.x+money.width+10,money.y , 100, 20)];
    identifyLabel.text = @"认证";
    identifyLabel.textAlignment = NSTextAlignmentLeft;
    identifyLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    identifyLabel.textColor = colorWithMainColor;
    [identifyLabel sizeToFit];
    identifyLabel.frame = CGRectMake(identifyLabel.x,identifyLabel.y , identifyLabel.width+3, identifyLabel.height+2);
    identifyLabel.layer.cornerRadius = 3;
    identifyLabel.layer.borderColor = colorWithMainColor.CGColor;
    identifyLabel.layer.borderWidth = 1;
    identifyLabel.clipsToBounds = YES;
    [footerView addSubview:identifyLabel];
    identifyLabel.centery = money.centery;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [footerView addSubview:lineView];
    
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (void)deliverCurriculumButtonAction:(UIButton *)btn
{
    if (btn.tag == 100000) {
    }
}

@end
