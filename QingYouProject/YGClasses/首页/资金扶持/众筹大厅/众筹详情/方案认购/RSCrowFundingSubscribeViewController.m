//
//  RSCrowFundingSubscribeViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RSCrowFundingSubscribeViewController.h"
#import "RSCrowFundingSubscribeTableViewCell.h"
#import "RSCorwFundingSubscribeModel.h"
#import "RSCrowFundingSubscribeConfrimViewController.h"

@interface RSCrowFundingSubscribeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_listArray;
    UILabel *_titlesLabel;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation RSCrowFundingSubscribeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    
}

- (void)configAttribute
{
    self.naviTitle = @"方案认购";
    _listArray = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = colorWithTable;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];

}

- (void)configUI
{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 60)];
    [self.view addSubview:tableHeaderView];
    
    _titlesLabel = [[UILabel alloc] init];
    _titlesLabel.textColor = colorWithBlack;
    _titlesLabel.font = [UIFont systemFontOfSize:YGFontSizeBigThree];
    _titlesLabel.text = _projectName;
    _titlesLabel.frame = CGRectMake(10, 0, YGScreenWidth-20, 60);
    _titlesLabel.numberOfLines = 0;
    [_titlesLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-20];
    _titlesLabel.frame = CGRectMake(10, 0, YGScreenWidth-20, _titlesLabel.height+20);
    [tableHeaderView addSubview:_titlesLabel];
    _titlesLabel.hidden = YES;
    tableHeaderView.frame = CGRectMake(10, 0, YGScreenWidth-20, _titlesLabel.height);

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64-YGBottomMargin) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableHeaderView = tableHeaderView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[RSCrowFundingSubscribeTableViewCell class] forCellReuseIdentifier:@"RSCrowFundingSubscribeTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
//
//    [self createRefreshWithScrollView:_tableView containFooter:YES];
//    [_tableView.mj_header beginRefreshing];
    
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
    RSCorwFundingSubscribeModel *model = _listArray[indexPath.section];
    
    RSCrowFundingSubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RSCrowFundingSubscribeTableViewCell" forIndexPath:indexPath];
    
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSCorwFundingSubscribeModel *model = _listArray[indexPath.section];

    return [tableView fd_heightForCellWithIdentifier:@"RSCrowFundingSubscribeTableViewCell" cacheByIndexPath:indexPath configuration:^(RSCrowFundingSubscribeTableViewCell *cell) {
//        cell.fd_enforceFrameLayout = YES;
        cell.model = model;

    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    FundSupportModel *model = _listArray[indexPath.section];
   
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RSCorwFundingSubscribeModel *model = _listArray[section];
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    sectionHeaderView.backgroundColor = colorWithYGWhite;

    UILabel *incomesLabel = [[UILabel alloc] init];
    incomesLabel.textColor = colorWithBlack;
    incomesLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
//    incomesLabel.text = [NSString stringWithFormat:@"%@%@万",model.power,model.amount];
    incomesLabel.text = [NSString stringWithFormat:@"%@",model.power];
    incomesLabel.frame = CGRectMake(10, 0, YGScreenWidth/2, 40);
    [sectionHeaderView addSubview:incomesLabel];
    
    UILabel *pricesLabel = [[UILabel alloc] init];
    pricesLabel.textColor = colorWithMainColor;
    pricesLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    pricesLabel.text = [NSString stringWithFormat:@"¥%@/份",model.amount];
    pricesLabel.textAlignment = NSTextAlignmentRight;
    pricesLabel.frame = CGRectMake(YGScreenWidth/2, 0, YGScreenWidth/2-10, 40);
    [sectionHeaderView addSubview:pricesLabel];
    
    return sectionHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    RSCorwFundingSubscribeModel *model = _listArray[section];

    UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 70)];
    sectionFooterView.backgroundColor = colorWithYGWhite;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [sectionFooterView addSubview:lineView];
    
    
    UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    addressImageView.image = [UIImage imageNamed:@"steward_capital_time_redoregon"];
    [addressImageView sizeToFit];
    [sectionFooterView addSubview:addressImageView];
    
    UILabel *limitPurchaseLabel = [[UILabel alloc] init];
    limitPurchaseLabel.textColor = colorWithOrangeColor;
    limitPurchaseLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    limitPurchaseLabel.text = [NSString stringWithFormat:@"个人限购%@份",model.forPurchasing];
    limitPurchaseLabel.frame = CGRectMake(addressImageView.x+addressImageView.width+5, addressImageView.y, YGScreenWidth-(addressImageView.x+addressImageView.width+5-20)-80, 20);
    [sectionFooterView addSubview:limitPurchaseLabel];
    limitPurchaseLabel.centery = addressImageView.centery;
    
    UIImageView *beleftWithTotalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 20, 20)];
    beleftWithTotalImageView.image = [UIImage imageNamed:@"steward_capital_hourglass"];
    [beleftWithTotalImageView sizeToFit];
    [sectionFooterView addSubview:beleftWithTotalImageView];
    
    UILabel *beleftWithTotalLabel = [[UILabel alloc] init];
    beleftWithTotalLabel.textColor = colorWithBlack;
    beleftWithTotalLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    beleftWithTotalLabel.text = [NSString stringWithFormat:@"剩余%@份/共%@份",model.leftCopies,model.copies];
    beleftWithTotalLabel.frame = CGRectMake(beleftWithTotalImageView.x+beleftWithTotalImageView.width+5, beleftWithTotalImageView.y, YGScreenWidth-(beleftWithTotalImageView.x+beleftWithTotalImageView.width+5-20)-80, 20);
    [sectionFooterView addSubview:beleftWithTotalLabel];
    beleftWithTotalLabel.centery = beleftWithTotalImageView.centery;

    //收益权
    UIButton *subscribeButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-75, 17, 65, 25)];
    [subscribeButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    subscribeButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [subscribeButton setTitle:@"认购" forState:UIControlStateNormal];
    subscribeButton.layer.cornerRadius = 12;
    subscribeButton.clipsToBounds = YES;
    subscribeButton.backgroundColor = colorWithMainColor;
    subscribeButton.tag = 20000+section;
    [sectionFooterView addSubview:subscribeButton];
    [subscribeButton addTarget:self action:@selector(subscribeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    subscribeButton.centery = sectionFooterView.centery;
    
    UIView *sectionlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, YGScreenWidth, 10)];
    sectionlineView.backgroundColor = colorWithTable;
    [sectionFooterView addSubview:sectionlineView];
//    if ([model.leftCopies intValue] == 0) {
//        subscribeButton.enabled = NO;
//    }
    return sectionFooterView;
}
- (void)loadData
{
    

    [self startPostWithURLString:REQUEST_getProjectSubscribe parameters:@{@"pId":_projectID,@"uId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil];
    
}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    BOOL headerAction = NO;
    [_listArray removeAllObjects];
    [_listArray addObjectsFromArray:[RSCorwFundingSubscribeModel mj_objectArrayWithKeyValuesArray:responseObject[@"sList"]]];
    if (_listArray.count == 0) {
        headerAction = YES;
        _titlesLabel.hidden = YES;
    }else
    {
        _titlesLabel.hidden = NO;
    }
    [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
    [_tableView reloadData];
}
#pragma 点击事件
- (void)subscribeButtonAction:(UIButton *)btn
{
    RSCorwFundingSubscribeModel *model = _listArray[btn.tag -20000];
    if ([model.leftCopies intValue] == 0) {
        [YGAppTool showToastWithText:@"当前剩余认购份数不足"];
        return ;
    }
    RSCrowFundingSubscribeConfrimViewController *rsCrowFundingSubscribeConfrimViewController = [[RSCrowFundingSubscribeConfrimViewController alloc] init];
    rsCrowFundingSubscribeConfrimViewController.model = model;
    rsCrowFundingSubscribeConfrimViewController.projectID = self.projectID;
    rsCrowFundingSubscribeConfrimViewController.coolTimeDescription = self.coolTimeDescription;
    [self.navigationController pushViewController:rsCrowFundingSubscribeConfrimViewController animated:YES];
}
@end
