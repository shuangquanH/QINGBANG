//
//  MyDecorationApplyOrderController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyDecorationApplyOrderController.h"
#import "DecorationApplyCell.h"
#import "MyFitmentApplyOrderModel.h"
#import "QuotePlanViewController.h"

@interface MyDecorationApplyOrderController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;


@end

@implementation MyDecorationApplyOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray array];
    [self configUI];
    
}

-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:@"myFitmentApply" parameters:@{@"uid":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString,@"status":self.statusString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if (((NSArray *)responseObject[@"flist"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[MyFitmentApplyOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"flist"]]];
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DecorationApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DecorationApplyCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DecorationApplyCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.nameLabel.text = [self.dataArray[indexPath.section] valueForKey:@"name"];
    cell.createDateLabel.text = [NSString stringWithFormat:@"创建时间:%@",[self.dataArray[indexPath.section] valueForKey:@"createDate"]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YGScreenWidth * 0.17;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *orderNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, YGScreenWidth, 40)];
    orderNumberLabel.text = [NSString stringWithFormat:@"订单号 %@",[self.dataArray[section] valueForKey:@"orderNum"]];
    orderNumberLabel.textColor = colorWithDeepGray;
    [orderNumberLabel setFont:[UIFont systemFontOfSize:14.0]];
    [headerView addSubview:orderNumberLabel];
    UIButton *stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stateButton.frame = CGRectMake(YGScreenWidth - 70, 0, 70, 40);
    NSString *statusString = [self.dataArray[section] valueForKey:@"status"];
    NSString *stateString; //右上角显示的状态
    if ([statusString isEqualToString:@"1"]) {
        stateString = @"待受理";
    }
    if([statusString isEqualToString:@"2"])
    {
        stateString = @"受理中";
    }
    if ([statusString isEqualToString:@"3"]) {
        stateString = @"已报价";
    }
    if([statusString isEqualToString:@"4"])
    {
        stateString = @"合作达成";
    }
    [stateButton setTitle:stateString forState:UIControlStateNormal];
    [stateButton setTitleColor:colorWithOrangeColor forState:UIControlStateNormal];
    stateButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [headerView addSubview:stateButton];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    
    UILabel *createLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, YGScreenWidth * 0.02, YGScreenWidth - 15, YGScreenWidth * 0.06)];//创建了
    createLabel.textColor = colorWithMainColor;
    createLabel.text = [NSString stringWithFormat:@"%@",[self.dataArray[section] valueForKey:@"createTime"]];
    createLabel.font = [UIFont systemFontOfSize:14.0];
    
    UILabel *processingLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, YGScreenWidth * 0.08, YGScreenWidth - 15, YGScreenWidth * 0.06)];//已受理
    processingLabel.textColor = colorWithMainColor;
    processingLabel.text = [NSString stringWithFormat:@"%@",[self.dataArray[section] valueForKey:@"acceptTime"]];
    processingLabel.font = [UIFont systemFontOfSize:14.0];
    
    UILabel *priceSchemeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, YGScreenWidth * 0.14, YGScreenWidth - 15, YGScreenWidth * 0.12)];//报价
    priceSchemeLabel.textColor = colorWithMainColor;
    priceSchemeLabel.numberOfLines = 2;
    priceSchemeLabel.text = [NSString stringWithFormat:@"%@",[self.dataArray[section] valueForKey:@"quotedTime"]];
    priceSchemeLabel.font = [UIFont systemFontOfSize:14.0];
    
    UILabel *processedLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, YGScreenWidth * 0.26, YGScreenWidth - 15, YGScreenWidth * 0.12)];//达成合作
    processedLabel.textColor = colorWithMainColor;
    processedLabel.numberOfLines = 2;
    processedLabel.text = [NSString stringWithFormat:@"%@",[self.dataArray[section] valueForKey:@"finishTime"]];
    processedLabel.font = [UIFont systemFontOfSize:14.0];
    
    UILabel *processedLineLabel = [[UILabel alloc]init];
    processedLineLabel.backgroundColor = colorWithLine;
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenWidth * 0.2, YGScreenWidth, YGScreenWidth * 0.11)];
    [footView addSubview:bottomView];
    
    UIView *sectionView = [[UIView alloc]init];
    sectionView.backgroundColor = colorWithPlateSpacedColor;
    [footView addSubview:sectionView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(YGScreenWidth - 30 - 180, (YGScreenWidth * 0.11 - 30) / 2, 90, 30);
    [leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [leftButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    leftButton.clipsToBounds = YES;
    leftButton.layer.cornerRadius = 15;
    leftButton.layer.borderColor = colorWithLine.CGColor;
    leftButton.layer.borderWidth = 1;
    [leftButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.tag = section;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(YGScreenWidth - 15 - 90, (YGScreenWidth * 0.11 - 30) / 2, 90, 30);
    [rightButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [rightButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    rightButton.clipsToBounds = YES;
    rightButton.layer.cornerRadius = 15;
    rightButton.layer.borderColor = colorWithLine.CGColor;
    rightButton.layer.borderWidth = 1;
    [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag = section;
    [bottomView addSubview:rightButton];
    
    NSInteger status = [[self.dataArray[section] valueForKey:@"status"] integerValue];
    switch (status) {
        case 1:
            footView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.21 + 10);
            [footView addSubview:createLabel];
            [footView addSubview:processedLineLabel];
            bottomView.frame = CGRectMake(0, YGScreenWidth * 0.10, YGScreenWidth, YGScreenWidth * 0.11);
            processedLineLabel.frame = CGRectMake(0, YGScreenWidth * 0.10, YGScreenWidth, 0.5);
            sectionView.frame = CGRectMake(0, YGScreenWidth * 0.21, YGScreenWidth, 10);
            break;
        case 2:
            footView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.27 + 10);
            [footView addSubview:createLabel];
            [footView addSubview:processingLabel];
            [footView addSubview:processedLineLabel];
            bottomView.frame = CGRectMake(0, YGScreenWidth * 0.16, YGScreenWidth, YGScreenWidth * 0.11);
            processedLineLabel.frame = CGRectMake(0, YGScreenWidth * 0.16, YGScreenWidth, 0.5);
            sectionView.frame = CGRectMake(0, YGScreenWidth * 0.27, YGScreenWidth, 10);
            break;
        case 3:
            footView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.39 + 10);
            [footView addSubview:createLabel];
            [footView addSubview:processingLabel];
            [footView addSubview:priceSchemeLabel];
            [bottomView addSubview:leftButton];
            [footView addSubview:processedLineLabel];
            [rightButton setTitle:@"查看报价" forState:UIControlStateNormal];
            [rightButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
            rightButton.layer.borderColor = colorWithMainColor.CGColor;
            processedLineLabel.frame = CGRectMake(0, YGScreenWidth * 0.28, YGScreenWidth, 0.5);
            bottomView.frame = CGRectMake(0, YGScreenWidth * 0.28, YGScreenWidth, YGScreenWidth * 0.11);
            sectionView.frame = CGRectMake(0, YGScreenWidth * 0.39, YGScreenWidth, 10);
            break;

        default:
            footView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.51 + 10);
            [footView addSubview:createLabel];
            [footView addSubview:processingLabel];
            [footView addSubview:priceSchemeLabel];
            [footView addSubview:processedLabel];
            [footView addSubview:processedLineLabel];
            [rightButton setTitle:@"查看报价" forState:UIControlStateNormal];
            [rightButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
            rightButton.layer.borderColor = colorWithMainColor.CGColor;
            processedLineLabel.frame = CGRectMake(0, YGScreenWidth * 0.40, YGScreenWidth, 0.5);
            bottomView.frame = CGRectMake(0, YGScreenWidth * 0.40, YGScreenWidth, YGScreenWidth * 0.11);
            sectionView.frame = CGRectMake(0, YGScreenWidth * 0.51, YGScreenWidth, 10);
            break;
    }
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger status = [[self.dataArray[section] valueForKey:@"status"] integerValue];
    switch (status) {
        case 1:
            return YGScreenWidth * 0.21 + 10;
            break;
        case 2:
            return YGScreenWidth * 0.27 + 10;
            break;
        case 3:
            return YGScreenWidth * 0.39 + 10;
            break;
            
        default:
            return YGScreenWidth * 0.51 + 10;
            break;
    }
        return YGScreenWidth * 0.51 + 10;
}
//左边按钮点击
-(void)leftClick:(UIButton *)button
{
    [YGAlertView showAlertWithTitle:@"确认取消订单吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:@"downAwayOrder" parameters:@{@"id":[self.dataArray[button.tag] valueForKey:@"ID"],@"applyFlag":[self.dataArray[button.tag] valueForKey:@"phone"]} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
                
                NSLog(@"%@",responseObject);
                if ([[responseObject valueForKey:@"flag"] integerValue]) {
                    [YGAppTool showToastWithText:@"取消成功!"];
                    
                    [self.dataArray removeObjectAtIndex:button.tag];
                    [_tableView reloadData];
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}
//右边按钮点击
-(void)rightClick:(UIButton *)button
{
    if([button.titleLabel.text isEqualToString:@"取消订单"])
    {
        [YGAlertView showAlertWithTitle:@"确认取消订单吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return ;
            }else
            {
                [YGNetService YGPOST:@"downAwayOrder" parameters:@{@"id":[self.dataArray[button.tag] valueForKey:@"ID"],@"applyFlag":[self.dataArray[button.tag] valueForKey:@"phone"]} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
                    
                    NSLog(@"%@",responseObject);
                    if ([[responseObject valueForKey:@"flag"] integerValue]) {
                        [YGAppTool showToastWithText:@"取消成功!"];
                        
                        [self.dataArray removeObjectAtIndex:button.tag];
                        [_tableView reloadData];
                    }
                    
                } failure:^(NSError *error) {
                    
                }];
            }
        }];
    }
    if([button.titleLabel.text isEqualToString:@"查看报价"])
    {
        [YGNetService YGPOST:@"getText" parameters:@{@"id":[self.dataArray[button.tag] valueForKey:@"ID"],@"applyFlag":[self.dataArray[button.tag] valueForKey:@"phone"]} showLoadingView:NO scrollView:nil success:^(id responseObject) {

            QuotePlanViewController *vc = [[QuotePlanViewController alloc]init];
            vc.contentUrl = [responseObject valueForKey:@"text"];
            [self.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
