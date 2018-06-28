  //
//  MeetingPayingViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MeetingPayingViewController.h"
#import "PayWayCell.h"
#import "PayHeaderView.h"
#import "PointsPayCell.h"
#import "OffLineSubmitController.h"
#import "ResultViewController.h"

#import <Pingpp.h>


@interface MeetingPayingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_iconArray;
    NSArray *_titleArray;
}

@property(nonatomic,strong)PayHeaderView *payheaderView;
@property(nonatomic,strong)NSString *timeIntervalString;//时间间隔
@property(nonatomic,copy)NSString *payStatus; //alipay : 支付宝支付  wx： 微信支付  2:线下支付
@property(nonatomic,strong)NSString *availablePointsString;//可用青币
@property(nonatomic,assign)CGFloat timeInterval;
@property(nonatomic,strong)NSString *isCheck; //0未勾选青币  1 勾选青币
@property(nonatomic,strong)NSString *earnPointString;//得到的青币

@end

@implementation MeetingPayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"支付";
    
     [self setFd_interactivePopDisabled:YES];
    
    _iconArray = [NSArray arrayWithObjects:@"pay_alipay",@"pay-wechat",@"pay_offline", nil];
    _titleArray = [NSArray arrayWithObjects:@"支付宝支付",@"微信支付",@"线下支付", nil];
    
    self.availablePointsString = self.pointString;
    self.isCheck = @"0";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - YGBottomMargin - 50) style:UITableViewStyleGrouped];
//    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
//    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(0, YGScreenHeight - 50 - YGStatusBarHeight - YGNaviBarHeight, YGScreenWidth, 50);
    confirmButton.backgroundColor = colorWithMainColor;
    [confirmButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    [self configHeader];
    
//    //接收支付结果的消息
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushViewController:) name:@"paySuccess" object:nil];
}

-(void)configHeader
{
    self.payheaderView = [[[NSBundle mainBundle]loadNibNamed:@"PayHeaderView" owner:self options:nil]firstObject];
    self.payheaderView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.31);
    self.payheaderView.roomNameLabel.text = [self.orderDic valueForKey:@"boardroomName"];
    NSString *beginHour = [[self.orderDic valueForKey:@"beginTime"] substringWithRange:NSMakeRange(0, 2)];
    NSString *endHour = [[self.orderDic valueForKey:@"endTime"] substringWithRange:NSMakeRange(0, 2)];
    NSString *beginMinute = [[self.orderDic valueForKey:@"beginTime"] substringWithRange:NSMakeRange(3, 2)];
    NSString *endMinute = [[self.orderDic valueForKey:@"endTime"] substringWithRange:NSMakeRange(3, 2)];
    if([beginMinute isEqualToString:@"30"])
    {
        beginMinute = @"5";
    }
    if([endMinute isEqualToString:@"30"])
    {
        endMinute = @"5";
    }
    if ([endHour isEqualToString:@"00"]) {
        endHour = @"24";
    }
    CGFloat beginNum = [[NSString stringWithFormat:@"%@.%@",beginHour,beginMinute] floatValue];
    CGFloat endNum = [[NSString stringWithFormat:@"%@.%@",endHour,endMinute] floatValue];
    self.timeInterval = endNum - beginNum;
    
    self.timeIntervalString = [NSString stringWithFormat:@"%.f小时",self.timeInterval];
    self.payheaderView.timeLabel.text = [NSString stringWithFormat:@"时间: %@",self.timeIntervalString];
    self.payheaderView.moneyLabel.text = [NSString stringWithFormat:@"费用总计:¥ %.2lf",[[self.orderDic valueForKey:@"price"] floatValue]];
    self.payheaderView.timeDetailLabel.text = [NSString stringWithFormat:@"%@ %@至%@",[self.orderDic valueForKey:@"orderDate"],[self.orderDic valueForKey:@"beginTime"],[self.orderDic valueForKey:@"endTime"]];
//    NSLog(@"%@",self.orderDic);
    _tableView.tableHeaderView = self.payheaderView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            PointsPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PointsPayCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"PointsPayCell" owner:self options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
//            if([self.pointString floatValue] > [[self.orderDic valueForKey:@"price"] floatValue])
//            {
//                self.availablePointsString = [NSString stringWithFormat:@"%.2lf",[[self.orderDic valueForKey:@"price"] floatValue]];
//            }
//            cell.pointsLabel.text = [NSString stringWithFormat:@"(可用%ld青币抵¥%.2lf)",[self.availablePointsString integerValue],[self.availablePointsString floatValue]];
             cell.pointsLabel.text = [NSString stringWithFormat:@"(可用%@青币抵¥%@)",self.pointString,self.offPriceString];
            return cell;
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"还需支付";
        cell.textLabel.frame = CGRectMake(20, 0, 150, 40);
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2lf",[[self.orderDic valueForKey:@"price"] floatValue]];
        cell.detailTextLabel.textColor = [UIColor orangeColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        return cell;
    }
    
    PayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PayWayCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.iconImageView.image = [UIImage imageNamed:_iconArray[indexPath.row]];
    cell.paywayLabel.text = _titleArray[indexPath.row];
    if (indexPath.row == 0)
    {
        self.payStatus = @"alipay";
        cell.radioButton.selected = YES;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 2;
    }
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return YGScreenWidth * 0.13;
    }
    return YGScreenWidth * 0.16;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView;
    if(section == 0){
        return nil;
    }
    else
    {
        headView.frame = CGRectMake(0, 0, YGScreenWidth, 45);
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
        UILabel *paylabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 45)];
        paylabel.text = @"支付方式";
        paylabel.textColor = colorWithDeepGray;
        paylabel.font = [UIFont systemFontOfSize:13.0];
        backView.backgroundColor = colorWithTable;
        [backView addSubview:paylabel];
        headView = backView;
        return headView;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 45;
    }
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *moneyCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    PointsPayCell *pointcell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        if ([self.payStatus isEqualToString:@"alipay"] ||[self.payStatus isEqualToString:@"wx"] ) {
            pointcell.pointsRadioButton.selected = !pointcell.pointsRadioButton.selected;
            if (pointcell.pointsRadioButton.selected == YES) {
                self.isCheck = @"1";
            }
            else
            {
                self.isCheck = @"0";
            }
            
            if (pointcell.pointsRadioButton.selected == YES) {
                moneyCell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2lf",[[self.orderDic valueForKey:@"price"] floatValue] - [self.offPriceString floatValue]];
                if (([[self.orderDic valueForKey:@"price"] floatValue] - [self.offPriceString floatValue]) <= 0) {
                    moneyCell.detailTextLabel.text = @"¥0";
                }
            }
            else
            {
                moneyCell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[self.orderDic valueForKey:@"price"]];
            }
        }
    }
    if(indexPath.section == 1)
    {
        for (int i = 0; i < 3; i++) {
            PayWayCell *unselectCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            unselectCell.radioButton.selected = NO;
        }
        PayWayCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.radioButton.selected = YES;
        switch (indexPath.row) {
            case 0:
                self.payStatus = @"alipay";
                break;
            case 1:
                self.payStatus = @"wx";
                break;
            case 2:
                self.payStatus = @"2";
                pointcell.pointsRadioButton.selected = NO;
                moneyCell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2lf",[[self.orderDic valueForKey:@"price"] floatValue]];
                [YGAlertView showAlertWithTitle:@"线下支付不支持青币购支付哦" buttonTitlesArray:@[@"确定"] buttonColorsArray:@[colorWithMainColor] handler:^(NSInteger buttonIndex) {
                    return ;
                }];
                break;
            default:
                break;
        }
    }
}

//确认支付
-(void)confirmClick:(UIButton *)button
{
    if([self.payStatus isEqualToString:@"alipay"] || [self.payStatus isEqualToString:@"wx"])
    {
        NSDictionary *orderDic = @{@"channel":self.payStatus,@"orderNum":[self.orderDic valueForKey:@"orderNum"],@"roomId":[self.orderDic valueForKey:@"roomId"],@"uId":YGSingletonMarco.user.userId,@"isCheck":self.isCheck};
        
        [YGNetService YGPOST:REQUEST_onLinePay parameters:orderDic showLoadingView:NO scrollView:nil success:^(id responseObject) {
            
            NSLog(@"%@",responseObject);
            NSString *charegeString = [responseObject valueForKey:@"charge"];
            self.earnPointString = [responseObject valueForKey:@"getPoint"];
            if (!charegeString.length)
            {
//                [YGAppTool showToastWithText:@"购买成功"];
//                NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
//                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
                ResultViewController *vc = [[ResultViewController alloc]init];
                if ([self.isOrderoffPay isEqualToString:@"isOrder"]) {
                    vc.pageType = ResultPageTypeSubmitPurchsePayResult;
                }
                else
                {
                    vc.pageType = ResultPageTypeMeetingResult;
                }
                vc.earnPoints = [self.earnPointString intValue];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [Pingpp createPayment:responseObject[@"charge"] viewController:self appURLScheme:@"qingyouhui" withCompletion:^(NSString *result, PingppError *error){
                    if ([result isEqualToString:@"success"])
                    {
                        /** 原来代码 */
//                        if ([self.payStatus isEqualToString:@"alipay"]) {
//                            //支付宝
//                            ResultViewController *vc = [[ResultViewController alloc]init];
//                            if ([self.isOrderoffPay isEqualToString:@"isOrder"]) {
//                                vc.pageType = ResultPageTypeSubmitPurchsePayResult;
//                            }
//                            else
//                            {
//                                vc.pageType = ResultPageTypeMeetingResult;
//                            }
//                            vc.earnPoints = [self.earnPointString intValue];
//                            [self.navigationController pushViewController:vc animated:YES];
//                        }
//                        NSLog(@"success");
                        /** 新改代码 */
                        if ([self.payStatus isEqualToString:@"alipay"]) {
                            //支付宝
                            ResultViewController *vc = [[ResultViewController alloc]init];
                            if ([self.isOrderoffPay isEqualToString:@"isOrder"]) {
                                vc.pageType = ResultPageTypeSubmitPurchsePayResult;
                            }
                            else
                            {
                                vc.pageType = ResultPageTypeMeetingResult;
                            }
                            vc.earnPoints = [self.earnPointString intValue];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        if ([self.payStatus isEqualToString:@"wx"]) {
                            //微信
                            ResultViewController *vc = [[ResultViewController alloc] init];
                            if ([self.isOrderoffPay isEqualToString:@"isOrder"]) {
                                vc.pageType = ResultPageTypeSubmitPurchsePayResult;
                            }
                            else
                            {
                                vc.pageType = ResultPageTypeMeetingResult;
                            }
                            vc.earnPoints = [self.earnPointString intValue];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        [YGAppTool showToastWithText:@"购买成功"];
                    } else {
//                        if (error.code == PingppErrWxNotInstalled || [self.payStatus isEqualToString:@"alipay"]) {
//                            [YGAppTool showToastWithText:@"请安装支付宝客户端"];
//                        }
                        if (error.code == PingppErrWxNotInstalled ) {
                            [YGAppTool showToastWithText:@"请安装微信客户端"];
                        } else {
                            [YGAppTool showToastWithText:@"购买失败"];
                        }
                        NSLog(@"PingppError: code=%lu msg=%@", error.code, [error getMsg]);
                    }
                }];
            }
            
        } failure:^(NSError *error) {
            
            
        }];
    }
    if([self.payStatus isEqualToString:@"2"])
    {
        [YGNetService YGPOST:@"underLinePay" parameters:@{@"orderNum":[self.orderDic valueForKey:@"orderNum"]} showLoadingView:YES scrollView:nil success:^(id responseObject) {
            
            NSLog(@"%@",responseObject);
            OffLineSubmitController *vc = [[OffLineSubmitController alloc]init];
            if ([self.isOrderoffPay isEqualToString:@"isOrder"]) {
                vc.pageType = @"orderPay";
            }
            else
            {
                vc.pageType = @"reservationPay";
            }
            [self.navigationController pushViewController:vc animated:YES];

        } failure:^(NSError *error) {
            
        }];
    }

}

//重写返回按钮
- (void)back
{
    [YGAlertView showAlertWithTitle:@"是否放弃支付？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            if ([self.isOrderoffPay isEqualToString:@"isOrder"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
            }
        }
    }];
}

/** 原来代码 */
//- (void)pushViewController:(NSNotification *)notif
//{
//    NSString *state = notif.userInfo[@"successOrNot"];
//    if ([state isEqualToString:@"1"])
//    {
//        if ([self.payStatus isEqualToString:@"alipay"]) {
//            //支付宝
//            ResultViewController *vc = [[ResultViewController alloc]init];
//            if ([self.isOrderoffPay isEqualToString:@"isOrder"]) {
//                vc.pageType = ResultPageTypeSubmitPurchsePayResult;
//            }
//            else
//            {
//                vc.pageType = ResultPageTypeMeetingResult;
//            }
//            vc.earnPoints = [self.earnPointString intValue];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        if ([self.payStatus isEqualToString:@"wx"]) {
//            //微信
//            ResultViewController *vc = [[ResultViewController alloc] init];
//            if ([self.isOrderoffPay isEqualToString:@"isOrder"]) {
//                vc.pageType = ResultPageTypeSubmitPurchsePayResult;
//            }
//            else
//            {
//                vc.pageType = ResultPageTypeMeetingResult;
//            }
//            vc.earnPoints = [self.earnPointString intValue];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        [YGAppTool showToastWithText:@"购买成功"];
//    }
//    else
//    {
//        [YGAppTool showToastWithText:@"购买失败"];
//    }
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
