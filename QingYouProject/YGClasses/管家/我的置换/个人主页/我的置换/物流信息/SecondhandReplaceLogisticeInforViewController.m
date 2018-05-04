//
//  SecondhandReplaceLogisticeInforViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/28.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplaceLogisticeInforViewController.h"
#import "SecondhandReplaceLogisticeInforTableViewCell.h"
#import "SecondhandReplaceLogisticeInforModel.h"

@interface SecondhandReplaceLogisticeInforViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray * _dataArray;
    UILabel * _stateLabel;
    UILabel * _nameLabel;
    UILabel * _phoneLabel;

}
@end

@implementation SecondhandReplaceLogisticeInforViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.naviTitle =@"物流信息";
    [self ceratUI];
    _dataArray= [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    [self refreshAction];
}
-(void)ceratUI
{
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDHPadding, LDHPadding, YGScreenWidth -2* LDHPadding, 30)];
    _stateLabel.text = @"已发货";
    _stateLabel.textColor = LDFFTextColor;
    _stateLabel.font =[UIFont systemFontOfSize:YGFontSizeBigOne];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDHPadding,_stateLabel.y + _stateLabel.height , YGScreenWidth -2* LDHPadding, 20)];
    _nameLabel.textColor =colorWithDeepGray;
    _nameLabel.font =[UIFont systemFontOfSize:YGFontSizeSmallTwo];
    
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDHPadding, _nameLabel.height +_nameLabel.y, YGScreenWidth -2* LDHPadding, 20)];
    _phoneLabel.textColor =colorWithDeepGray;
    _phoneLabel.font =[UIFont systemFontOfSize:YGFontSizeSmallTwo];
}
#pragma mark - 网络请求
//刷新
-(void)refreshAction
{
    NSDictionary *parameters = @{
                                 @"num":self.num,
                                 @"com":self.com,
                                 };
    NSString *url = @"inquiryLogistics";
    
    [YGNetService YGPOST:url
              parameters:parameters
         showLoadingView:NO
              scrollView:_tableView
                 success:^( id responseObject) {
                     _nameLabel.text = [NSString stringWithFormat:@"%@：%@",responseObject[@"name"],self.num];
                     _phoneLabel.text = [NSString stringWithFormat:@"官方电话：%@",responseObject[@"tel"]];

                [_dataArray addObjectsFromArray:[SecondhandReplaceLogisticeInforModel mj_objectArrayWithKeyValuesArray:responseObject[@"resp"]]];
                     [_tableView reloadData];
                 } failure:^(NSError *error)
     {
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0)
        return 1;
    else
        return _dataArray.count;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section ==0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell addSubview:_stateLabel];
        [cell addSubview:_nameLabel];
        [cell addSubview:_phoneLabel];
        
        return cell;
    }
    else
    {
        SecondhandReplaceLogisticeInforTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SecondhandReplaceLogisticeInforTableViewCellID];
        [cell setModel:((SecondhandReplaceLogisticeInforModel*)_dataArray[indexPath.row]) withRow:indexPath.row withCount:_dataArray.count];
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0)
        return 90;
    else
   return [tableView fd_heightForCellWithIdentifier:SecondhandReplaceLogisticeInforTableViewCellID cacheByIndexPath:indexPath configuration:^(SecondhandReplaceLogisticeInforTableViewCell *cell) {
        
        [cell setModel:((SecondhandReplaceLogisticeInforModel*)_dataArray[indexPath.row]) withRow:indexPath.row withCount:_dataArray.count];

    }];
}
static NSString * const SecondhandReplaceLogisticeInforTableViewCellID = @"SecondhandReplaceLogisticeInforTableViewCellID";

- (UITableView *)tableView{
    
    if (!_tableView) {
        CGFloat H = kScreenH - YGNaviBarHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, H) style:UITableViewStyleGrouped];

//        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
//        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[SecondhandReplaceLogisticeInforTableViewCell class] forCellReuseIdentifier:SecondhandReplaceLogisticeInforTableViewCellID];
    }
    return _tableView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
@end









