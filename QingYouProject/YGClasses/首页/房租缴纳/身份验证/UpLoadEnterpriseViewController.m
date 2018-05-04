//
//  UpLoadEnterpriseViewController.m
//  FrienDo
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "UpLoadEnterpriseViewController.h"
#import "UpLoadEnterpriseTableViewCell.h"

#define headerHeight 65 //header高度

@interface UpLoadEnterpriseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
}
@end

@implementation UpLoadEnterpriseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = colorWithYGWhite;
    [self configUI];
}


-(void)configUI
{
    self.view.frame = _controllerFrame;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, self.view.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UpLoadEnterpriseTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"yy"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpLoadEnterpriseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yy" forIndexPath:indexPath];
    [cell.upLoadButton addTarget:self action:@selector(upLoadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.mainModel = _listArray[indexPath.section];
    [cell showFadeAnimate];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YGScreenHeight / 2.8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return headerHeight;
    }else
        return 0.00001;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, headerHeight)];
        baseView.backgroundColor = colorWithYGWhite;
        
        UILabel * headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, baseView.width, 20)];
        headerLabel.text = @"请上传营业执照";
        headerLabel.textColor = colorWithBlack;
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        [baseView addSubview:headerLabel];
        
        return baseView;
    }
    else
        return nil;
}

//点击上传图片
-(void)upLoadButtonClick:(UIButton *)button
{
    //0 正面 1反面
    [self.delegate upLoadPersonBtnAction:button];
    
}


@end
