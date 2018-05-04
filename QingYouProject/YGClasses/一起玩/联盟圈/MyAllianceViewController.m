//
//  MyAllianceViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/4.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyAllianceViewController.h"
#import "MyAllianceTableViewCell.h"
#import "AllAllianceModel.h"
#import "AllianceCircleIntroduceViewController.h"

@interface MyAllianceViewController ()<UITableViewDelegate,UITableViewDataSource,MyAllianceTableViewCellDelegate>
{
    NSMutableArray                 *_dataArray; //数据源
    UITableView             *_tabelView;
}

@end

@implementation MyAllianceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)configAttribute
{
    self.view.frame = self.controllerFrame;
    self.view.backgroundColor = colorWithTable;
    self.naviTitle = @"财务代记账";
    _dataArray = [[NSMutableArray alloc] init];
    [self configUI];
    
    [_tabelView.mj_header beginRefreshing];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{

    [YGNetService YGPOST:REQUEST_getMineAllianceList parameters:@{@"userID":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tabelView success:^(id responseObject) {
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        if ([responseObject[@"alliance"] count] <= [YGPageSize intValue]) {
            [self noMoreDataFormatWithScrollView:_tabelView];
        }
        AllAllianceModel *model = [[AllAllianceModel alloc] init];
        NSArray *dataArr;
        if ([responseObject[@"mainAlliance"] allKeys].count == 0) {
            dataArr = [[NSArray alloc]init];

        }else
        {
            [model setValuesForKeysWithDictionary:responseObject[@"mainAlliance"]];
            dataArr = [[NSArray alloc]initWithObjects:model, nil];
        }
        
        NSArray *dataArr1 = [[NSArray alloc]initWithArray:[AllAllianceModel mj_objectArrayWithKeyValuesArray:responseObject[@"alliance"]]];
        
        _dataArray = [[NSMutableArray alloc] init];
        if (dataArr.count == 0) {
            [_dataArray addObject:dataArr1];
        }else
        {
            [_dataArray addObject:dataArr];
            [_dataArray addObject:dataArr1];
        }
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tabelView headerAction:headerAction];

        [_tabelView reloadData];
    } failure:^(NSError *error) {
        
    }];

  
}
#pragma mark --------- tabeleView 相关
-(void)configUI
{
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, YGScreenWidth, YGScreenHeight-64-40) style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    [self.view addSubview:_tabelView];
    _tabelView.backgroundColor = [UIColor clearColor];
//    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabelView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    [self createRefreshWithScrollView:_tabelView containFooter:YES];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return [(NSArray *)_dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"methodCell";
    MyAllianceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MyAllianceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.cellType = @"mine";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.myAllianceTableViewCellDelegate = self;
    AllAllianceModel *model = _dataArray[indexPath.section][indexPath.row];
    cell.model = model;
    [cell showFadeAnimate];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //发现详情
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //indexPath.section == 0 饮食方案 1：逆袭大法 2：运动视频
    AllAllianceModel *model = _dataArray[indexPath.section][indexPath.row];
    AllianceCircleIntroduceViewController *vc = [[AllianceCircleIntroduceViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.allianceID = model.allianceID;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    headerView.backgroundColor = colorWithYGWhite;
    
    //热门推荐label
   UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    titleLabel.text = @"我管理的";
    if (section == 1) {
        titleLabel.text = @"我加入的";
    }

    if (_dataArray.count == 1) {
            titleLabel.text = @"我加入的";
    }

    titleLabel.frame = CGRectMake(10, 10,YGScreenWidth-100-15, 20);
    [headerView addSubview:titleLabel];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

#pragma cell--delegateEvent
//退出联盟圈
- (void)applyBackOutBtnWithModel:(AllAllianceModel *)model
{
    
    [YGAlertView showAlertWithTitle:@"确认退出联盟吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:REQUEST_operateAllianceMember parameters:@{@"allianceID":model.allianceID,@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
#pragma 此处可以指刷新单行后面改
                [self refreshActionWithIsRefreshHeaderAction:YES];
                
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}
@end
