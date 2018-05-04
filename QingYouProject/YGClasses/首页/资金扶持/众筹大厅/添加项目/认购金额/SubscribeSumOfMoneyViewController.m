//
//  SubscribeSumOfMoneyViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SubscribeSumOfMoneyViewController.h"
#import "SubscribeSumOfMoneyTableViewCell.h"
#import "SubscribeSumOfMoneyModel.h"
#import "ChooseRightsViewController.h"
#import "AddSubscribeSumOfMoneyViewController.h"

@interface SubscribeSumOfMoneyViewController ()<UITableViewDelegate,UITableViewDataSource,ChooseRightsViewControllerDelegate,AddSubscribeSumOfMoneyViewControllerDelegate>

@end

@implementation SubscribeSumOfMoneyViewController
{
    UITableView *_tableView;
    UILabel *_nameLabel;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}

- (void)configAttribute
{
    self.naviTitle = @"认购金额";
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
}

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    [_tableView reloadData];
}
- (void)configUI
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 55)];
    headerView.backgroundColor = colorWithYGWhite;
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 100, 45)];
    _nameLabel.text = @"收益权";
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _nameLabel.textColor = colorWithDeepGray;
    [headerView addSubview:_nameLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.frame = CGRectMake(YGScreenWidth-30, 0, 17, 17);
    arrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
    [headerView addSubview:arrowImageView] ;
    [arrowImageView sizeToFit];
    arrowImageView.centery = _nameLabel.centery;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
    [button addTarget:self action:@selector(chooseSubscribeTypeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    
    UIView *seprareLineView = [[UIView alloc] initWithFrame:CGRectMake(0,45, YGScreenWidth, 10)];
    seprareLineView.backgroundColor = colorWithTable;
    [headerView addSubview:seprareLineView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
    footerView.backgroundColor = colorWithYGWhite;
    
    UIImageView *addSubscribeImageView = [[UIImageView alloc] init];
    addSubscribeImageView.frame = CGRectMake(10, 15, 17, 17);
    addSubscribeImageView.image = [UIImage imageNamed:@"steward_capital_add"];
    [addSubscribeImageView sizeToFit];
    [footerView addSubview: addSubscribeImageView];

    UILabel *addSubscribeLabel = [[UILabel alloc] initWithFrame:CGRectMake(addSubscribeImageView.x+addSubscribeImageView.width,0 , 100, 45)];
    addSubscribeLabel.text = @"添加认购金额";
    addSubscribeLabel.textAlignment = NSTextAlignmentLeft;
    addSubscribeLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    addSubscribeLabel.textColor = colorWithDeepGray;
    [footerView addSubview:addSubscribeLabel];
    
    UIImageView *addSubscribeArrowImageView = [[UIImageView alloc] init];
    addSubscribeArrowImageView.frame = CGRectMake(YGScreenWidth-30, 0, 17, 17);
    addSubscribeArrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
    [addSubscribeArrowImageView sizeToFit];
    [footerView addSubview:addSubscribeArrowImageView] ;
    addSubscribeArrowImageView.centery = addSubscribeLabel.centery;

    UIButton *addSubscribeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
    [addSubscribeButton addTarget:self action:@selector(addSubscribeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addSubscribeButton];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64-45) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = headerView;
    _tableView.tableFooterView = footerView;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[SubscribeSumOfMoneyTableViewCell class] forCellReuseIdentifier:@"SubscribeSumOfMoneyTableViewCell"];
    
    [self.view addSubview:_tableView];
    
    UIButton *applyButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
    applyButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    [applyButton addTarget:self action:@selector(applyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    applyButton.backgroundColor = colorWithMainColor;
    applyButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [self.view addSubview:applyButton];
    [applyButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [applyButton setTitle:@"保存" forState:UIControlStateNormal];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
  SubscribeSumOfMoneyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SubscribeSumOfMoneyTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SubscribeSumOfMoneyModel *model = _dataSource[indexPath.section];
    [cell setModel:model];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"SubscribeSumOfMoneyTableViewCell" cacheByIndexPath:indexPath configuration:^(SubscribeSumOfMoneyTableViewCell *cell) {
        cell.fd_enforceFrameLayout = YES;
        SubscribeSumOfMoneyModel *model = _dataSource[indexPath.section];
        [cell setModel:model];
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
        return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    return view;
}
#pragma 点击事件

- (void)chooseSubscribeTypeButtonAction
{
    ChooseRightsViewController *vc = [[ChooseRightsViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addSubscribeButtonAction
{
    AddSubscribeSumOfMoneyViewController *vc = [[AddSubscribeSumOfMoneyViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)applyButtonAction
{
    [self.delegate takeTypeValueBackWithModels:_dataSource withRights:_nameLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back
{
    if (_dataSource.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        
        [YGAlertView  showAlertWithTitle:@"是否保存添加的认购金额" buttonTitlesArray:@[@"是",@"否"] buttonColorsArray:@[colorWithMainColor,colorWithDeepGray] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self applyButtonAction];
            }else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
#pragma 代理
- (void)takeTypeValueBackWithValue:(NSString *)value
{
    _nameLabel.text = value;
}

- (void)takeTypeValueBackWithModel:(SubscribeSumOfMoneyModel *)model
{
    [_dataSource addObject:model];
    [_tableView reloadData];
}
@end
