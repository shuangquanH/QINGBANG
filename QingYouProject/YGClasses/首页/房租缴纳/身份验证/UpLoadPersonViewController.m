//
//  UpLoadPersonViewController.m
//  FrienDo
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "UpLoadPersonViewController.h"
#import "UpLoadPersonTableViewCell.h"
#import "UpLoadModel.h"

#define headerHeight 65 //header高度

@interface UpLoadPersonViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation UpLoadPersonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = colorWithYGWhite;
    [self configUI];
}

-(void)configUI
{
    self.view.frame = _controllerFrame;

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, self.view.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = colorWithTable;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UpLoadPersonTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"xx"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
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
    UpLoadPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xx" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.upLoadButton addTarget:self action:@selector(upLoadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.mainModel = _listArray[indexPath.section];
    cell.upLoadButton.tag = indexPath.section;
    [cell showFadeAnimate];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YGScreenHeight / 4.3;
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
        headerLabel.text = @"请上传本人身份证反正面";
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
