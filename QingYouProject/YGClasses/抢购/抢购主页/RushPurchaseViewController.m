//
//  ServiceViewController.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/1/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RushPurchaseViewController.h"
#import "RushPurchaseSubViewController.h"

#import "EasyEnterprisePurchaseViewController.h"

@interface RushPurchaseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray          *dataSource;  //数据源

@end


@implementation RushPurchaseViewController
{
    UIView                              *_condationBaseView;
    UITableView                         *_tableView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configAttribute
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.naviTitle = @"路演大厅";
    self.fd_prefersNavigationBarHidden = YES;
    _dataSource = @[@"purchase_yellow",@"purchase_red"];
    self.view.backgroundColor = colorWithYGWhite;
    
}


//顶部的滚动标题
- (void)configUI
{
    UIView  *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth*0.613)];
    
    UIImageView *tableViewBackGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KAPP_WIDTH, KAPP_HEIGHT-KSTATU_HEIGHT-KTAB_HEIGHT)];
    tableViewBackGroundImageView.image = [UIImage imageNamed:@"purchase_bg"];
    tableViewBackGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    tableViewBackGroundImageView.clipsToBounds = YES;
    
    //tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSTATU_HEIGHT, KAPP_WIDTH, KAPP_HEIGHT-KTAB_HEIGHT-KSTATU_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView = tableViewBackGroundImageView;
    _tableView.tableHeaderView = baseView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YGScreenWidth*0.45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, YGScreenWidth-20, YGScreenWidth/2)];
        imageView.tag = 1000+indexPath.row;
        imageView.image = YGDefaultImgTwo_One;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        [cell.contentView addSubview:imageView];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imageView = [cell.contentView viewWithTag:1000+indexPath.row];
    imageView.image = [UIImage imageNamed:_dataSource[indexPath.row]];
    [imageView sizeToFit];
    imageView.x = (YGScreenWidth-imageView.width)/2;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self loginOrNot])
    {
        return;
    }
    if (indexPath.row == 0) {
        RushPurchaseSubViewController *vc = [[RushPurchaseSubViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        //    ProjectApplyForSubModel *model = _listArray[indexPath.section];
        EasyEnterprisePurchaseViewController *vc = [[EasyEnterprisePurchaseViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}


@end
