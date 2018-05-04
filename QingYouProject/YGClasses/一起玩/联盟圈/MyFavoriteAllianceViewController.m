//
//  MyFavoriteAllianceViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/4.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyFavoriteAllianceViewController.h"
#import "MyAllianceTableViewCell.h"
#import "AllAllianceModel.h"
#import "AllianceCircleIntroduceViewController.h"

@interface MyFavoriteAllianceViewController ()<UITableViewDelegate,UITableViewDataSource,MyAllianceTableViewCellDelegate>
{
    NSMutableArray                 *_dataArray; //数据源
    UITableView             *_tabelView;
}


@end

@implementation MyFavoriteAllianceViewController

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
    if (![self loginOrNot])
    {
        return;
    }
    [YGNetService YGPOST:REQUEST_getAllianceAttention parameters:@{@"total":self.totalString,@"count":self.countString,@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:_tabelView success:^(id responseObject) {
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        if ([responseObject[@"alliance"] count] <= [YGPageSize intValue]) {
            [self noMoreDataFormatWithScrollView:_tabelView];
        }
        [_dataArray addObjectsFromArray:[AllAllianceModel mj_objectArrayWithKeyValuesArray:responseObject[@"alliance"]]];
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tabelView headerAction:headerAction];
        [_tabelView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark --------- tabeleView 相关
-(void)configUI
{
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    [self.view addSubview:_tabelView];
    _tabelView.backgroundColor = [UIColor clearColor];
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabelView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    [self createRefreshWithScrollView:_tabelView containFooter:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"methodCell";
    MyAllianceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MyAllianceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.cellType = @"fravorite";
    cell.myAllianceTableViewCellDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = colorWithYGWhite;
    AllAllianceModel *model = _dataArray[indexPath.row];
    cell.model = model;
    [cell showFadeAnimate];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllAllianceModel *model = _dataArray[indexPath.row];
    //发现详情
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //indexPath.section == 0 饮食方案 1：逆袭大法 2：运动视频
    AllianceCircleIntroduceViewController *vc = [[AllianceCircleIntroduceViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.allianceID = model.allianceID;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)applyBackOutBtnWithModel:(AllAllianceModel *)model
{
    [YGAlertView showAlertWithTitle:@"确认不再关注？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:REQUEST_attentionAlliance parameters:@{@"allianceID":model.allianceID,@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                [YGAppTool showToastWithText:@"取消关注成功"];
#pragma 此处可以指刷新单行后面改
                [self refreshActionWithIsRefreshHeaderAction:YES];
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}
@end
