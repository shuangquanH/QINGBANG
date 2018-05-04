//
//  MyPlayTogetherCollectionController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/12/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyPlayTogetherCollectionController.h"
#import "MyColectionCell.h"
#import "MyPalyTogetherCollectionCell.h"
#import "MyCollectionModel.h"
#import "PlayTogetherDetailViewController.h"
#import "AllianceCircleIntroduceViewController.h"

@interface MyPlayTogetherCollectionController () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    NSArray *_interfaceArray;
}

@end

@implementation MyPlayTogetherCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = self.controllerFrame;
    _dataArray = [NSMutableArray array];
    _interfaceArray = [NSArray arrayWithObjects:@"getAllianceActivityCollect",@"getAllianceCollect", nil];
    
    [self configUI];
    
}

-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:_interfaceArray[[_pageType integerValue]] parameters:@{@"userID":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if (((NSArray *)responseObject[@"list"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[MyCollectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 10;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.pageType isEqualToString:@"0"]) {
        MyColectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyColectionCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyColectionCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.nameLabel.text = [_dataArray[indexPath.row] valueForKey:@"name"];
        [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:[_dataArray[indexPath.row] valueForKey:@"img"]] placeholderImage:YGDefaultImgFour_Three];
        cell.cancelButton.tag = indexPath.row;
        [cell.cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    MyPalyTogetherCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyPalyTogetherCollectionCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyPalyTogetherCollectionCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.nameLabel.text = [_dataArray[indexPath.row] valueForKey:@"name"];
    [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:[_dataArray[indexPath.row] valueForKey:@"img"]] placeholderImage:YGDefaultImgSquare];
    cell.cancelButton.tag = indexPath.row;
    [cell.cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.pageType isEqualToString:@"0"]) {
        return YGScreenWidth * 0.28;
    }
    return YGScreenWidth * 0.25;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.pageType isEqualToString:@"0"])
    {
        PlayTogetherDetailViewController * detail = [[PlayTogetherDetailViewController alloc]init];
        detail.official = [_dataArray[indexPath.row] valueForKey:@"official"];
        detail.activityID = [_dataArray[indexPath.row] valueForKey:@"ID"];
        [self.navigationController pushViewController:detail animated:YES];
    }
    else
    {
        AllianceCircleIntroduceViewController *vc = [[AllianceCircleIntroduceViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.allianceID = [_dataArray[indexPath.row] valueForKey:@"ID"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//取消收藏
-(void)cancelClick:(UIButton *)button
{
    NSArray *cancelInterfaceArray = [NSArray arrayWithObjects:@"collectActivity",@"collectAlliance", nil];
    NSDictionary *cancelParaDic;
    if ([self.pageType isEqualToString:@"0"]) {
        cancelParaDic = @{@"activityID":[_dataArray[button.tag] valueForKey:@"ID"],@"userID":YGSingletonMarco.user.userId};
    }
    else
    {
        cancelParaDic = @{@"allianceID":[_dataArray[button.tag] valueForKey:@"ID"],@"userID":YGSingletonMarco.user.userId};
    }
    [YGAlertView showAlertWithTitle:@"确定取消收藏吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:cancelInterfaceArray[[self.pageType integerValue]] parameters:cancelParaDic showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
                
                NSLog(@"%@",responseObject);
                
                [YGAppTool showToastWithText:@"取消收藏成功"];
                [_dataArray removeObjectAtIndex:button.tag];
                [_tableView reloadData];
                
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
