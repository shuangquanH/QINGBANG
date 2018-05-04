//
//  SeeAndSaveViewController.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SeeAndSaveViewController.h"
#import "SeeAndSaveTableViewCell.h"
#import "AdvertisesForStaffViewController.h"

@interface SeeAndSaveViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
}
@end

@implementation SeeAndSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configAttribute
{
    _listArray = _lastArray.mutableCopy;
    self.naviTitle = @"我的简历";


    for (NSMutableDictionary *infoDic in _listArray)
    {
        for (NSMutableDictionary *subDic in infoDic[@"list"])
        {
            subDic[@"detail"] = [_model performSelector:NSSelectorFromString(subDic[@"modelArg"])];

        }
    }

    self.navigationItem.rightBarButtonItem = [self createBarbuttonWithNormalTitleString:@"编辑简历" selectedTitleString:@"编辑简历" selector:@selector(popLastVierController)];
}
- (void)popLastVierController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)back
{
    UINavigationController *navc = self.navigationController;
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (UIViewController *vc in [navc viewControllers]) {
        [viewControllers addObject:vc];
        if ([vc isKindOfClass:[AdvertisesForStaffViewController class]]) {
            break;
        }
    }
    [navc setViewControllers:viewControllers];
}
- (void)configUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 20)];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"SeeAndSaveTableViewCell" bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"xx"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_listArray[section][@"isSelected"] boolValue])
    {
        return [_listArray[section][@"list"] count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ((section == 3 || section == 4) && [_listArray[section][@"isSelected"] boolValue])
    {
        if(section == 3)
        {
            return (CGFloat) ([UILabel calculateWidthWithString:_model.description textFont:[UIFont systemFontOfSize:YGFontSizeSmallOne] numerOfLines:0 maxWidth:YGScreenWidth - 24].height + 24.0 + 12 + 13);
        }
        else
        {
            return [UILabel calculateWidthWithString:_model.selfEvaluation textFont:[UIFont systemFontOfSize:YGFontSizeSmallOne] numerOfLines:0 maxWidth:YGScreenWidth - 24].height + 24;
        }
    }
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeeAndSaveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xx" forIndexPath:indexPath];
    cell.infoDic = _listArray[indexPath.section][@"list"][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"xx" cacheByIndexPath:indexPath configuration:^(SeeAndSaveTableViewCell *cell)
    {
        cell.infoDic = _listArray[indexPath.section][@"list"][indexPath.row];
    }];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
    sectionHeaderView.backgroundColor = colorWithTable;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    titleLabel.text = _listArray[section][@"indexName"];
    [sectionHeaderView addSubview:titleLabel];

    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"steward_paytherent_packup.png"]];
    [sectionHeaderView addSubview:arrowImageView];

    UIButton *sectionHeaderButton = [[UIButton alloc] init];
    sectionHeaderButton.tag = 300 + section;
    [sectionHeaderButton addTarget:self action:@selector(sectionHeaderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    sectionHeaderButton.selected = [_listArray[section][@"isSelected"] boolValue];
    [sectionHeaderView addSubview:sectionHeaderButton];

    arrowImageView.transform = CGAffineTransformRotate(arrowImageView.transform, (CGFloat) (sectionHeaderButton.isSelected * M_PI));

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(sectionHeaderButton.mas_centerY);
    }];

    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(titleLabel.mas_centerY);
    }];

    [sectionHeaderButton mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [sectionHeaderView addSubview:lineView];

    return sectionHeaderView;
}

- (void)sectionHeaderButtonClick:(UIButton *)button
{
    [self.view endEditing:YES];
    button.selected = !button.isSelected;
    _listArray[button.tag - 300][@"isSelected"] = @(button.isSelected);
    [_tableView reloadData];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 150)];
    sectionFooterView.backgroundColor = colorWithYGWhite;
    if ((section == 3 || section == 4) && [_listArray[section][@"isSelected"] boolValue])
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = colorWithBlack;
        titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [sectionFooterView addSubview:titleLabel];
        titleLabel.x = 12;
        titleLabel.y = 12;
        if (section == 3)
        {
            titleLabel.text = _model.description;

            UILabel *titleLabel1 = [[UILabel alloc] init];
            titleLabel1.textColor = colorWithDeepGray;
            titleLabel1.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
            titleLabel1.text = @"工作描述";
            [titleLabel1 sizeToFit];
            titleLabel1.x = 12;
            titleLabel1.y = 12;
            titleLabel.y = titleLabel1.y + titleLabel1.height + 12;
            [sectionFooterView addSubview:titleLabel1];


        }

        if (section == 4)
        {
            titleLabel.text = _model.selfEvaluation;
        }
        [titleLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth - 24];

    }
    return sectionFooterView;
}

@end
