//
//  MyCollectionListController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/9.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyCollectionListController.h"
#import "MyCollectionViewController.h"


@interface MyCollectionListController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    NSArray *_imageArray;
}
@end

@implementation MyCollectionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"我的收藏";
    
    _titleArray = [NSArray arrayWithObjects:@"资金扶持",@"财务代记账",@"工商一体化",@"广告位置",@"办公采购", nil];
    
    _imageArray = [NSArray arrayWithObjects:@"mine_nursery_finance_little",@"mine_finance_little",@"mine_industry_little",@"mine_steward_ad",@"mine_steward_purchasing", nil];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewController *vc = [[MyCollectionViewController alloc]init];
    vc.type = indexPath.row;
    vc.titleString = _titleArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
