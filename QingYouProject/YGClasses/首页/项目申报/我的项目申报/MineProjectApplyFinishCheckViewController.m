//
//  MineProjectApplyFinishCheckViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/28.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MineProjectApplyFinishCheckViewController.h"
#import "MineProjectApplyModel.h"
#import "MineProjectApplyTableViewCell.h"
#import "ProjectApplySuccessDetailViewController.h"

@interface MineProjectApplyFinishCheckViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
}

@end

@implementation MineProjectApplyFinishCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_SearchApplicationOrder parameters:@{@"userId":YGSingletonMarco.user.userId,@"auditStatus":@"3",@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }
        [_listArray addObjectsFromArray:[MineProjectApplyModel mj_objectArrayWithKeyValuesArray:responseObject[@"searchApplication"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        if ([responseObject[@"searchApplication"] count] == 0) {
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
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = colorWithLine;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[MineProjectApplyTableViewCell class] forCellReuseIdentifier:@"MineProjectApplyTableViewCell"];
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
    MineProjectApplyTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"MineProjectApplyTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _listArray[indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"MineProjectApplyTableViewCell" cacheByIndexPath:indexPath configuration:^(MineProjectApplyTableViewCell *cell) {
        cell.fd_enforceFrameLayout = YES;
        cell.model = _listArray[indexPath.section];
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineProjectApplyModel *model = _listArray[indexPath.section];
    ProjectApplySuccessDetailViewController *vc = [[ProjectApplySuccessDetailViewController alloc] init];
    vc.pageType = 2;
    vc.itemID = model.id;
    vc.stateType = 3;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MineProjectApplyModel *model = _listArray[section];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    footerView.backgroundColor = colorWithYGWhite;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    lineView.backgroundColor = colorWithTable;
    [footerView addSubview:lineView];
    
    UILabel  *money = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 35)];
    money.text = [NSString stringWithFormat:@"订单号 %@",model.orderNumber];
    money.textAlignment = NSTextAlignmentLeft;
    money.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    money.textColor = colorWithDeepGray;
    [footerView addSubview:money];
    [money sizeToFit];
    money.frame = CGRectMake(10,money.y , money.width, 35);
    
     NSArray  *arry = @[@"",@"",@"",@"审核通过",@"审核未通过"];
    NSArray  *orderFinishColorArray = @[colorWithMainColor,colorWithMainColor,colorWithMainColor,colorWithMainColor,colorWithOrangeColor];

    UILabel  *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(YGScreenWidth-130,10 , 120, 35)];
    statusLabel.text = [NSString stringWithFormat:@"%@",arry[[model.auditStatus intValue]]];
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    statusLabel.textColor = orderFinishColorArray[[model.auditStatus intValue]];
    [footerView addSubview:statusLabel];
    
    return footerView;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    MineProjectApplyModel *model = _listArray[section];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
    footerView.backgroundColor = colorWithYGWhite;
    
    UILabel  *dealingNoticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 20)];
    dealingNoticeLabel.text = [NSString stringWithFormat:@"您的申请正在审核中！ %@",model.processTime];
    dealingNoticeLabel.textAlignment = NSTextAlignmentLeft;
    dealingNoticeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    dealingNoticeLabel.textColor = colorWithDeepGray;
    [dealingNoticeLabel sizeToFit];
    dealingNoticeLabel.frame = CGRectMake(10,dealingNoticeLabel.y , dealingNoticeLabel.width, 20);
    [footerView addSubview:dealingNoticeLabel];
    
    UILabel  *finishNoticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,dealingNoticeLabel.y+dealingNoticeLabel.height , YGScreenWidth-20, 20)];
    finishNoticeLabel.text = [NSString stringWithFormat:@"您的申请已经审核完！ %@",model.completedTime];
    finishNoticeLabel.textAlignment = NSTextAlignmentLeft;
    finishNoticeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    finishNoticeLabel.textColor = colorWithDeepGray;
    [finishNoticeLabel sizeToFit];
    finishNoticeLabel.frame = CGRectMake(10,finishNoticeLabel.y , finishNoticeLabel.width, 20);
    [footerView addSubview:finishNoticeLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithTable;
    [footerView addSubview:lineView];
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-70,lineView.y+lineView.height+7,70,30)];
    [deleteButton setTitle:@"删除订单" forState:UIControlStateNormal];
    [deleteButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deliverCurriculumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.layer.borderColor = colorWithLine.CGColor;
    deleteButton.layer.borderWidth = 1;
    deleteButton.layer.cornerRadius = 15;
    deleteButton.tag = 10000+section;
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [deleteButton sizeToFit];
    [footerView addSubview:deleteButton];
    deleteButton.frame = CGRectMake(YGScreenWidth-deleteButton.width-30,deleteButton.y,deleteButton.width+20,30);;
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 105;
}

//删除操作
- (void)deliverCurriculumButtonAction:(UIButton *)btn
{
    [YGAlertView showAlertWithTitle:@"您确定要删除申请吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            MineProjectApplyModel *model = _listArray[btn.tag-10000];
            [YGNetService YGPOST:REQUEST_DeletApplication parameters:@{@"id":model.id} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
                [YGAppTool showToastWithText:@"删除申请成功！"];
                [_listArray removeObjectAtIndex:btn.tag-10000];
                [_tableView reloadData];
            } failure:^(NSError *error) {

            }];
        }
    }];
    
}
@end
