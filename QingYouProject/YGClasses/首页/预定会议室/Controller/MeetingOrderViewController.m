//
//  MeetingOrderViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MeetingOrderViewController.h"
#import "MeetingOrderCell.h"
#import "RefundViewController.h"
#import "MyOrderModel.h"
#import "MeetingPayingViewController.h"

@interface MeetingOrderViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSString *pointsString; //青币
@property(nonatomic,strong)NSString *offPriceString;//抵扣钱数

@end

@implementation MeetingOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"我的订单";
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.dataArray = [NSMutableArray array];
    
    [self configUI];
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
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [self.view addSubview:_tableView];
    
    [_tableView.mj_header beginRefreshing];
}


-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_myOrder parameters:@{@"uId":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (((NSArray *)responseObject[@"aList"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        if (headerAction == YES) {
            [self.dataArray removeAllObjects];
        }
        NSLog(@"%@",responseObject);
        [self.dataArray addObjectsFromArray:[MyOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"aList"]]];
        [self addNoDataImageViewWithArray:self.dataArray shouldAddToView:_tableView headerAction:YES];
        self.pointsString = [responseObject valueForKey:@"point"];
        self.offPriceString = [responseObject valueForKey:@"offPrice"];
        
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingOrderCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MeetingOrderCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
    }
    cell.model = self.dataArray[indexPath.section];
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
    return YGScreenWidth * 0.33;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if(section == 0)
//    {
//        return nil;
//    }
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *orderNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, YGScreenWidth, 40)];
//    orderNumberLabel.text = @"订单号 1948593894795348";
    orderNumberLabel.text = [NSString stringWithFormat:@"订单号  %@",[self.dataArray[section] valueForKey:@"orderNum"]];
    orderNumberLabel.textColor = colorWithDeepGray;
    [orderNumberLabel setFont:[UIFont systemFontOfSize:14.0]];
    [headerView addSubview:orderNumberLabel];
    UIButton *stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stateButton.frame = CGRectMake(YGScreenWidth - 70, 0, 70, 40);
//    [stateButton setTitle:@"待完成" forState:UIControlStateNormal];
    NSString *statusString = [self.dataArray[section] valueForKey:@"status"];
    NSString *stateString; //右上角显示的状态
    if ([statusString isEqualToString:@"0"] || [statusString isEqualToString:@"1"] || [statusString isEqualToString:@"2"]) {
        stateString = @"待完成";
    }
    if([statusString isEqualToString:@"3"])
    {
        stateString = @"已支付";
    }
    if([statusString isEqualToString:@"4"])
    {
        stateString = @"已取消";
    }
    if([statusString isEqualToString:@"5"])
    {
        stateString = @"退款中";
    }
    if([statusString isEqualToString:@"6"])
    {
        stateString = @"已退款";
    }
    if([statusString isEqualToString:@"7"])
    {
        stateString = @"已完成";
    }
    [stateButton setTitle:stateString forState:UIControlStateNormal];
    [stateButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    stateButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [headerView addSubview:stateButton];
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 60)];
    footerView.backgroundColor = [UIColor whiteColor];

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:bottomView];
    
    UIButton *refundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refundButton.frame = CGRectMake(YGScreenWidth - 100, 10, 80, 30);
    refundButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    [refundButton setTitle:@"申请退款" forState:UIControlStateNormal];
    [refundButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    refundButton.layer.cornerRadius = 15;
    refundButton.clipsToBounds = YES;
    refundButton.layer.borderColor = colorWithTabNaviLine.CGColor;
    refundButton.layer.borderWidth = 1;
    [refundButton addTarget:self action:@selector(refund:) forControlEvents:UIControlEventTouchUpInside];
    refundButton.tag = section;
    [bottomView addSubview:refundButton];
    
    //section之间的分割线
    UIView *sepeView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, YGScreenWidth, 10)];
    sepeView.backgroundColor = colorWithPlateSpacedColor;
    [footerView addSubview:sepeView];
    [sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10);
        make.left.equalTo(footerView).with.offset(0);
        make.right.equalTo(footerView).with.offset(0);
        make.bottom.equalTo(footerView).with.offset(0);
    }];
    NSString *statusString = [self.dataArray[section] valueForKey:@"status"];
    
    NSString *orderDateStr = [NSString stringWithFormat:@"%@ %@",[self.dataArray[section] valueForKey:@"orderDate"],[self.dataArray[section] valueForKey:@"beginTime"]];
    
    BOOL isMoreThan = [self compareTimeWithNowTime:orderDateStr];//是否大于24小时
    
    if ([statusString isEqualToString:@"0"] || ([statusString isEqualToString:@"3"] && isMoreThan) || [statusString isEqualToString:@"4"] || [statusString isEqualToString:@"6"] || [statusString isEqualToString:@"7"])
    {
        bottomView.hidden = NO;
        if ([statusString isEqualToString:@"0"]) {
            [refundButton setTitle:@"去付款" forState:UIControlStateNormal];
        }
        if ([statusString isEqualToString:@"3"] && isMoreThan) {
            [refundButton setTitle:@"申请退款" forState:UIControlStateNormal];
        }
        if ([statusString isEqualToString:@"4"] || [statusString isEqualToString:@"6"] || [statusString isEqualToString:@"7"]) {
            [refundButton setTitle:@"删除订单" forState:UIControlStateNormal];
        }
    }
    else
    {
        bottomView.hidden = YES;
    }
    
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if(section == 0)
//    {
//        return 0;
//    }
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSString *statusString = [self.dataArray[section] valueForKey:@"status"];
    
    NSString *orderDateStr = [NSString stringWithFormat:@"%@ %@",[self.dataArray[section] valueForKey:@"orderDate"],[self.dataArray[section] valueForKey:@"beginTime"]];
    
    BOOL isMoreThan = [self compareTimeWithNowTime:orderDateStr];//是否大于24小时
    
    if ([statusString isEqualToString:@"0"] || ([statusString isEqualToString:@"3"] && isMoreThan) || [statusString isEqualToString:@"4"] || [statusString isEqualToString:@"6"] || [statusString isEqualToString:@"7"])
    {
        return 60;
    }
    else
    {
        return 10;
    }
}

//去付款或者申请退款
-(void)refund:(UIButton *)button
{
    if([button.titleLabel.text isEqualToString:@"去付款"])
    {
        MeetingPayingViewController *vc = [[MeetingPayingViewController alloc]init];
        vc.orderDic = _dataArray[button.tag];
        vc.pointString = self.pointsString;
        vc.offPriceString = self.offPriceString;
        vc.isOrderoffPay = @"isOrder";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if([button.titleLabel.text isEqualToString:@"申请退款"])
    {
        RefundViewController *rVC = [[RefundViewController alloc]init];
        rVC.orderNumString = [_dataArray[button.tag] valueForKey:@"orderNum"];
        [self.navigationController pushViewController:rVC animated:YES];
    }
    if([button.titleLabel.text isEqualToString:@"删除订单"])
    {
        [YGAlertView showAlertWithTitle:@"确认删除订单吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return ;
            }else
            {
                [YGNetService YGPOST:@"delOrder" parameters:@{@"orderNum":[self.dataArray[button.tag] valueForKey:@"orderNum"]} showLoadingView:YES scrollView:nil success:^(id responseObject) {
                    
                    NSLog(@"%@",responseObject);
                    [YGAppTool showToastWithText:@"删除成功"];
                    
                    [self.dataArray removeObjectAtIndex:button.tag];
                    [_tableView reloadData];
                    
                } failure:^(NSError *error) {
                    
                }];
            }
        }];
    }
}

//比较距离预定时间是否大于24小时 YES：大于 NO：不大于
-(BOOL)compareTimeWithNowTime:(NSString *)orderDateStr
{
    //比较时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *systemDateStr = [formatter stringFromDate:date];
    
    NSString *systemYearStr = [systemDateStr substringWithRange:NSMakeRange(0, 4)];
    NSInteger systemYear = [systemYearStr integerValue];
    NSString *systemMonthStr = [systemDateStr substringWithRange:NSMakeRange(5,2)];
    NSInteger systemMonth = [systemMonthStr integerValue];
    NSString *systemDayStr = [systemDateStr substringWithRange:NSMakeRange(8,2)];
    NSInteger systemDay = [systemDayStr integerValue];
    NSString *systemHourStr = [systemDateStr substringWithRange:NSMakeRange(11,2)];
    NSInteger systemHour = [systemHourStr integerValue];
    
    NSString *orderYearStr = [orderDateStr substringWithRange:NSMakeRange(0, 4)];
    NSInteger orderYear = [orderYearStr integerValue];
    NSString *orderMonthStr = [orderDateStr substringWithRange:NSMakeRange(5,2)];
    NSInteger orderMonth = [orderMonthStr integerValue];
    NSString *ordermDayStr = [orderDateStr substringWithRange:NSMakeRange(8,2)];
    NSInteger orderDay = [ordermDayStr integerValue];
    NSString *orderHourStr = [orderDateStr substringWithRange:NSMakeRange(11,2)];
    NSInteger orderHour = [orderHourStr integerValue];
    
    if (orderYear > systemYear) {
        return YES;
    }
    else if(orderMonth > systemMonth)
    {
        return YES;
    }
    else if(orderDay - systemDay >1)
    {
        return YES;
    }
    else if ((orderDay - systemDay == 1) && (orderHour >= systemHour))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
