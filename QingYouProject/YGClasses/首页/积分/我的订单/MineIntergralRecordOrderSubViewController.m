//
//  MineIntergralRecordOrderSubViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MineIntergralRecordOrderSubViewController.h"
#import "MineIntergralRecordOrderTableViewCell.h"
#import "MineIntergralRecordOrderModel.h"
#import "MineIntergralOrderDetailsController.h"

@interface MineIntergralRecordOrderSubViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation MineIntergralRecordOrderSubViewController
{
    NSMutableArray *_listArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _listArray = [[NSMutableArray alloc] init];
    
    [self configUI];
    // Do any additional setup after loading the view.
}

- (void)configAttribute
{
    self.view.frame = self.controllerFrame;
    
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:@"orderList" parameters:@{@"userId":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString,@"type":self.controllerType} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if (((NSArray *)responseObject[@"list1"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }

        [_listArray addObjectsFromArray:[MineIntergralRecordOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"list1"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        [_tableView reloadData];
    } failure:^(NSError *error) {

    }];
}
- (void)configUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[MineIntergralRecordOrderTableViewCell class] forCellReuseIdentifier:@"MineIntergralRecordOrderTableViewCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineIntergralRecordOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineIntergralRecordOrderTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MineIntergralRecordOrderModel *model = _listArray[indexPath.section];
    [cell setModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    MineProjectApplyModel *model = _listArray[section];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    footerView.backgroundColor = colorWithYGWhite;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    lineView.backgroundColor = colorWithTable;
    [footerView addSubview:lineView];
    
    UILabel  *money = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 35)];
    money.text = [NSString stringWithFormat:@"订单编号 %@",[_listArray[section] valueForKey:@"dNum"]];
    money.textAlignment = NSTextAlignmentLeft;
    money.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    money.textColor = colorWithDeepGray;
    money.frame = CGRectMake(10,money.y , money.width,35);
    [footerView addSubview:money];
    
    
    UILabel  *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(YGScreenWidth-130,10 , 120, 35)];
    NSString *orderType = [_listArray[section] valueForKey:@"dType"];//订单状态，0待发货，1待收货，2已完成
    NSString *statusString;
    switch ([orderType integerValue]) {
        case 0:
            statusString = @"待发货";
            break;
        case 1:
            statusString = @"待收货";
            break;
        case 2:
            statusString = @"已完成";
            break;
            
        default:
            break;
    }
    statusLabel.text = statusString;
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    statusLabel.textColor = colorWithOrangeColor;
    [footerView addSubview:statusLabel];
    
    return footerView;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSString *orderType = [_listArray[section] valueForKey:@"dType"];//订单状态，0待发货，1待收货，2已完成
    if ([orderType isEqualToString:@"0"]) {
        return nil;
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
    footerView.backgroundColor = colorWithYGWhite;
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-70,7,70,25)];
    if ([orderType isEqualToString:@"1"]) {
        [deleteButton setTitle:@"确认收货" forState:UIControlStateNormal];
        [deleteButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        deleteButton.layer.borderColor = colorWithMainColor.CGColor;
    }
    else
    {
        [deleteButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [deleteButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        deleteButton.layer.borderColor = colorWithLine.CGColor;
    }
    
   
    [deleteButton addTarget:self action:@selector(deliverCurriculumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.layer.borderWidth = 1;
    deleteButton.layer.cornerRadius = 15;
    deleteButton.tag = 1000+section;
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [deleteButton sizeToFit];
    [footerView addSubview:deleteButton];
    deleteButton.frame = CGRectMake(YGScreenWidth-deleteButton.width-30,12,deleteButton.width+20,30);;
    
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSString *orderType = [_listArray[section] valueForKey:@"dType"];//订单状态，0待发货，1待收货，2已完成
    if ([orderType isEqualToString:@"0"]) {
        return 0;
    }
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineIntergralOrderDetailsController *vc = [[MineIntergralOrderDetailsController alloc]init];
    vc.idString = [_listArray[indexPath.section] valueForKey:@"ID"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//确认收货||删除订单
-(void)deliverCurriculumButtonAction:(UIButton *)button
{
    if([button.titleLabel.text isEqualToString:@"确认收货"])
    {
        [YGAlertView showAlertWithTitle:@"是否确认收货？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return ;
            }else
            {
                [YGNetService YGPOST:@"GoodsReceipt" parameters:@{@"oId":[_listArray[button.tag - 1000] valueForKey:@"ID"]} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
                    
                    NSLog(@"%@",responseObject);
                    
                    [YGAppTool showToastWithText:@"确认收货成功!"];
                    [self refreshActionWithIsRefreshHeaderAction:YES];
                    
                } failure:^(NSError *error) {
                    
                }];
            }
        }];
    }
    else
    {
        [YGAlertView showAlertWithTitle:@"确定删除此订单？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return ;
            }else
            {
                [YGNetService YGPOST:@"DeleteOrder" parameters:@{@"id":[_listArray[button.tag - 1000] valueForKey:@"ID"]} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
                    
                    NSLog(@"%@",responseObject);
                    
                    [_listArray removeObjectAtIndex:button.tag];
                    [_tableView reloadData];
                    
                } failure:^(NSError *error) {
                    
                }];
            }
        }];
    }
}




@end
