//
//  MyDecorationCenterViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyDecorationCenterViewController.h"
#import "DecorationCenterHeaderView.h"
#import "DecorationCenterCell.h"
#import "MyDecorationApplyStatusController.h"
#import "MyDecorationApplyOrderController.h"
#import "MyDecorationOrderController.h"
#import <UIButton+WebCache.h>

@interface MyDecorationCenterViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation MyDecorationCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.naviTitle = @"我的装修中心";
    
    [self configUI];
    
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self configHeader];
}

-(void)configHeader
{
    DecorationCenterHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"DecorationCenterHeaderView" owner:self options:nil]firstObject];
    headerView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.5);
    headerView.headImageButton.layer.cornerRadius = headerView.headImageButton.height / 2;
    headerView.headImageButton.clipsToBounds = YES;
    [headerView.headImageButton sd_setImageWithURL:[NSURL URLWithString:YGSingletonMarco.user.userImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultavatar"]];
    headerView.nameLabel.text = YGSingletonMarco.user.userName;
    self.tableView.tableHeaderView = headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DecorationCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DecorationCenterCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DecorationCenterCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    if (indexPath.section == 0) {
        cell.picImageView.image = [UIImage imageNamed:@"mine_decorate_apply"];
        cell.titleLabel.text = @"我的装修申请";
    }
    else
    {
        cell.picImageView.image = [UIImage imageNamed:@"mine_decorate_ordders"];
        cell.titleLabel.text = @"我的装修订单";
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YGScreenWidth * 0.33;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSArray * titleArr = @[@"全部",@"待受理",@"受理中",@"已报价",@"合作达成"];
        NSArray * classArr = @[@"MyDecorationApplyOrderController",@"MyDecorationApplyOrderController",@"MyDecorationApplyOrderController",@"MyDecorationApplyOrderController",@"MyDecorationApplyOrderController"];
        MyDecorationApplyStatusController * toVC= [[MyDecorationApplyStatusController alloc] initWithTitleArray:titleArr viewControllerClassStringArray:classArr navgationTitle:@"我的装修申请"];
        [self.navigationController pushViewController:toVC animated:YES];
    }
    else
    {
        MyDecorationOrderController *vc = [[MyDecorationOrderController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    return view;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
