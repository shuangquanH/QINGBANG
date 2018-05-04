//
//  ChooseRightsViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ChooseRightsViewController.h"
#import "AdvertisesForInfoModel.h"

@interface ChooseRightsViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ChooseRightsViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}

- (void)configAttribute
{
    self.naviTitle = @"选择权益";
    _dataSource = [[NSMutableArray alloc] init];
}

- (void)configUI
{
    
    _dataSource = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:@[@{@"title":@"收益权"},@{@"title":@"股权"},@{@"title":@"物权"}]];
    for (AdvertisesForInfoModel *model in _dataSource) {
        model.isSelect = NO;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellpop"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellpop"];
        if (tableView == _tableView) {
            UIButton *chooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(tableView.width-50,0,40,40)];
            [chooseBtn setImage:[UIImage imageNamed:@"order_choice_btn_green"] forState:UIControlStateNormal];
            chooseBtn.tag = 1000+indexPath.row;
            chooseBtn.backgroundColor = colorWithMainColor;
            [cell.contentView addSubview:chooseBtn];
            chooseBtn.hidden = YES;
            
        }
        UIView *linview = [[UIView alloc] initWithFrame:CGRectMake(10, 40, YGScreenWidth-10, 1)];
        linview.backgroundColor = colorWithTable;
        [cell addSubview:linview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    cell.textLabel.textColor = colorWithBlack;
    AdvertisesForInfoModel *model;
    model = _dataSource[indexPath.row];
    UIButton *btn = [tableView viewWithTag:1000+indexPath.row];
    //右边的选中时按钮出现 字颜色变为主题色
    btn.hidden = !model.isSelect;
    cell.backgroundColor = colorWithYGWhite;
    cell.textLabel.text = model.title;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (AdvertisesForInfoModel *model in _dataSource) {
        model.isSelect = NO;
    }
    AdvertisesForInfoModel *model = _dataSource[indexPath.row];
    model.isSelect = YES;
    [self.delegate takeTypeValueBackWithValue:model.title];
    [_tableView reloadData];
    [self back];
    
}

@end
