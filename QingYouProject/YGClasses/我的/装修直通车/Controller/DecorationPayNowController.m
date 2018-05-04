//
//  DecorationPayNowController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "DecorationPayNowController.h"
#import "DecorationMoneyDetailsCell.h"
#import "PayWayCell.h"

#import <Pingpp.h>

@interface DecorationPayNowController () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_iconArray;
    NSArray *_titleArray;
}
@property(nonatomic,strong)NSDictionary *resultDic;
@property(nonatomic,strong)NSString *payStatus;//第三方支付渠道 alipay  wx


@property(nonatomic,strong)UITableView *tableView;

@end

@implementation DecorationPayNowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"立即支付";
    _iconArray = [NSArray arrayWithObjects:@"pay_alipay",@"pay-wechat", nil];
    _titleArray = [NSArray arrayWithObjects:@"支付宝支付",@"微信支付", nil];
    
    //接收支付结果的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushViewController:) name:@"paySuccess" object:nil];
    
    [self loadData];
    
}

-(void)loadData
{
    [YGNetService YGPOST:@"getOrderPayDetail" parameters:@{@"id":self.orderIdString} showLoadingView:NO scrollView:_tableView success:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        
        self.resultDic = [responseObject valueForKey:@"fitmentOrder"];
        
        [self configUI];
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - YGBottomMargin - 50) style:UITableViewStyleGrouped];
   [_tableView registerNib:[UINib nibWithNibName:@"DecorationMoneyDetailsCell" bundle:nil] forCellReuseIdentifier:@"DecorationMoneyDetailsCell"];
    _tableView.estimatedRowHeight = YGScreenWidth * 0.29;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(0, YGScreenHeight - 50 - YGStatusBarHeight - YGNaviBarHeight, YGScreenWidth, 50);
    payButton.backgroundColor = colorWithMainColor;
    [payButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];

    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
       DecorationMoneyDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DecorationMoneyDetailsCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.payDateLabel.text = [NSString stringWithFormat:@"付款日期: %@",[self.resultDic valueForKey:@"priceDate1"]];
//        cell.payMoneyLabel.text = [NSString stringWithFormat:@"付款金额: %@",[self.resultDic valueForKey:@"price1"]];
        [cell.payMoneyLabel addAttributedWithString:[NSString stringWithFormat:@"付款金额: %@万元",[self.resultDic valueForKey:@"price1"]] lineSpace:8];
        [cell.payMoneyLabel addAttributedWithString:[NSString stringWithFormat:@"付款金额: %@万元",[self.resultDic valueForKey:@"price1"]] range:NSMakeRange(0, @"付款金额:".length) color:colorWithLightGray];
        
        cell.payExplainLabel.text = [self.resultDic valueForKey:@"explain1"];
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
    if (section == 0) {
        return 1;
    }
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *explainString = [self.resultDic valueForKey:@"explain1"];
        if (explainString.length) {
            return [tableView fd_heightForCellWithIdentifier:@"DecorationMoneyDetailsCell" cacheByIndexPath:indexPath configuration:^(DecorationMoneyDetailsCell *cell) {
                    cell.payExplainLabel.text = explainString;
            }];
        }
    }
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    if(section == 0)
    {
        headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 50)];
        nameLabel.text = [self.resultDic valueForKey:@"designer"];
        nameLabel.font = [UIFont systemFontOfSize:15.0];
        [headerView addSubview:nameLabel];
    }
    else
    {
        headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 30)];
        headerView.backgroundColor = colorWithTable;
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 30)];
        nameLabel.text = @"支付方式";
        nameLabel.font = [UIFont systemFontOfSize:13.0];
        nameLabel.textColor = colorWithDeepGray;
        [headerView addSubview:nameLabel];
    }
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50;
    }
    else
    {
        return 30;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        for (int i = 0; i < 2; i++) {
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
            default:
                break;
        }
    }
    
}

//确认支付
-(void)payClick:(UIButton *)button
{
    NSDictionary *orderDic = @{@"channel":self.payStatus,@"orderNum":self.orderNumberString};
    
    [YGNetService YGPOST:@"FitmentOrderPay" parameters:orderDic showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);

            [Pingpp createPayment:responseObject[@"charge"] viewController:self appURLScheme:@"qingyouhui" withCompletion:^(NSString *result, PingppError *error){
                if ([result isEqualToString:@"success"])
                {
                    if ([self.payStatus isEqualToString:@"alipay"]) {
                        [YGAppTool showToastWithText:@"购买成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    NSLog(@"success");
                    
                } else {
                    if (error.code == PingppErrWxNotInstalled) {
                        [YGAppTool showToastWithText:@"请安装微信客户端"];
                    }
                    NSLog(@"PingppError: code=%lu msg=%@", error.code, [error getMsg]);
                }
            }];

    } failure:^(NSError *error) {
        
        
    }];
}

- (void)pushViewController:(NSNotification *)notif
{
    NSString *state = notif.userInfo[@"successOrNot"];
    if ([state isEqualToString:@"1"])
    {
        [YGAppTool showToastWithText:@"购买成功"];
        [self.navigationController popViewControllerAnimated:YES];
//        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
    }
    else
    {
        [YGAppTool showToastWithText:@"购买失败"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
