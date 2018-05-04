//
//  MyDecorationMoneyOrderController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyDecorationMoneyOrderController.h"
#import "DecorationOrderView.h"
#import "DecorationMoneyDetailsCell.h"
#import "DecorationOrderDetailsController.h"
#import "DecorationPayNowController.h"
#import "DecorationMoneyDetailsCell.h"

@interface MyDecorationMoneyOrderController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)DecorationOrderView *headerView;
@property(nonatomic,strong)NSDictionary *resultDictionary;
@property(nonatomic,strong)NSString *payFlag;//支付按钮标示 0不能支付 1可以支付
@property(nonatomic,strong)UIButton *payButton;//支付按钮

@end

@implementation MyDecorationMoneyOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"我的装修订单";
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self configUI];
    
    [self loadData];
}

-(void)loadData
{
    [YGNetService YGPOST:@"myFitmentOrder" parameters:@{@"id":self.orderIdString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        self.resultDictionary = [responseObject valueForKey:@"fitmentOrder"];
        
        self.headerView.orderNumberLabel.text = [NSString stringWithFormat:@"订单编号: %@",[self.resultDictionary valueForKey:@"orderNum"]];
        self.headerView.createTimeLabel.text = [NSString stringWithFormat:@"创建时间: %@",[self.resultDictionary valueForKey:@"createDate"]];
        
        self.payFlag = [responseObject valueForKey:@"payFlag"];
        
        if ([self.payFlag isEqualToString:@"1"]) {
//            [self configFooterView];
            self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.payButton.backgroundColor = colorWithMainColor;
            [self.payButton setTitle:@"立即付款" forState:UIControlStateNormal];
            [self.payButton addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
            self.payButton.frame = CGRectMake(0, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - 50, YGScreenWidth, 50);
            [self.view addSubview:self.payButton];
        }
        else
        {
            _tableView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight);
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - 50 -YGBottomMargin) style:UITableViewStyleGrouped];
    _tableView.estimatedRowHeight = YGScreenWidth * 0.29;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    [_tableView registerNib:[UINib nibWithNibName:@"DecorationMoneyDetailsCell" bundle:nil] forCellReuseIdentifier:@"DecorationMoneyDetailsCell"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    
    [self configHeaderView];
    
    
   
}

-(void)configHeaderView
{
    self.headerView = [[[NSBundle mainBundle]loadNibNamed:@"DecorationOrderView" owner:self options:nil] firstObject];
    self.headerView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.17 + 40);
    [self.headerView.seeDetailButton addTarget:self action:@selector(seeDetailClick:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = self.headerView;
}



//-(void)configFooterView
//{
//    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
//    footerView.backgroundColor = colorWithTable;
//
//    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    payButton.backgroundColor = colorWithMainColor;
//    [payButton setTitle:@"立即付款" forState:UIControlStateNormal];
//    [payButton addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
//    payButton.frame = CGRectMake(0, 0, YGScreenWidth, 50);
//    [footerView addSubview:payButton];
//
//    self.tableView.tableFooterView = footerView;
//
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DecorationMoneyDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DecorationMoneyDetailsCell" forIndexPath:indexPath];
    if(indexPath.section == 0)
    {
        [cell.payDateLabel addAttributedWithString:[NSString stringWithFormat:@"付款日期:  %@",[self.resultDictionary valueForKey:@"priceDate1"]] lineSpace:8];
        [cell.payDateLabel addAttributedWithString:[NSString stringWithFormat:@"付款日期:  %@",[self.resultDictionary valueForKey:@"priceDate1"]] range:NSMakeRange(0, @"付款日期:".length) color:colorWithDeepGray];
//        cell.payMoneyLabel.text = [NSString stringWithFormat:@"付款金额: %@万元",[self.resultDictionary valueForKey:@"price1"]];
        [cell.payMoneyLabel addAttributedWithString:[NSString stringWithFormat:@"付款金额:  %@万元",[self.resultDictionary valueForKey:@"price1"]] lineSpace:8];
        [cell.payMoneyLabel addAttributedWithString:[NSString stringWithFormat:@"付款金额:  %@万元",[self.resultDictionary valueForKey:@"price1"]] range:NSMakeRange(0, @"付款金额:".length) color:colorWithDeepGray];
        cell.payExplainLabel.text = [self.resultDictionary valueForKey:@"explain1"];
    }
    if(indexPath.section == 1)
    {
        [cell.payDateLabel addAttributedWithString:[NSString stringWithFormat:@"付款日期:  %@",[self.resultDictionary valueForKey:@"priceDate2"]] lineSpace:8];
        [cell.payDateLabel addAttributedWithString:[NSString stringWithFormat:@"付款日期:  %@",[self.resultDictionary valueForKey:@"priceDate2"]] range:NSMakeRange(0, @"付款日期:".length) color:colorWithDeepGray];
//        cell.payMoneyLabel.text = [NSString stringWithFormat:@"付款金额: %@万元",[self.resultDictionary valueForKey:@"price2"]];
        [cell.payMoneyLabel addAttributedWithString:[NSString stringWithFormat:@"付款金额:  %@万元",[self.resultDictionary valueForKey:@"price2"]] lineSpace:8];
        [cell.payMoneyLabel addAttributedWithString:[NSString stringWithFormat:@"付款金额:  %@万元",[self.resultDictionary valueForKey:@"price2"]] range:NSMakeRange(0, @"付款金额:".length) color:colorWithDeepGray];
        cell.payExplainLabel.text = [self.resultDictionary valueForKey:@"explain2"];
    }
    if(indexPath.section == 2)
    {
        [cell.payDateLabel addAttributedWithString:[NSString stringWithFormat:@"付款日期:  %@",[self.resultDictionary valueForKey:@"priceDate3"]] lineSpace:8];
        [cell.payDateLabel addAttributedWithString:[NSString stringWithFormat:@"付款日期:  %@",[self.resultDictionary valueForKey:@"priceDate3"]] range:NSMakeRange(0, @"付款日期:".length) color:colorWithDeepGray];
//        cell.payMoneyLabel.text = [NSString stringWithFormat:@"付款金额: %@万元",[self.resultDictionary valueForKey:@"price3"]];
        [cell.payMoneyLabel addAttributedWithString:[NSString stringWithFormat:@"付款金额:  %@万元",[self.resultDictionary valueForKey:@"price3"]] lineSpace:8];
        [cell.payMoneyLabel addAttributedWithString:[NSString stringWithFormat:@"付款金额:  %@万元",[self.resultDictionary valueForKey:@"price3"]] range:NSMakeRange(0, @"付款金额:".length) color:colorWithDeepGray];
        cell.payExplainLabel.text = [self.resultDictionary valueForKey:@"explain3"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *keyString = [NSString stringWithFormat:@"explain%ld",indexPath.section + 1];
    NSString *remarkString = [self.resultDictionary valueForKey:keyString];
    if(remarkString.length)
    {
        return [tableView fd_heightForCellWithIdentifier:@"DecorationMoneyDetailsCell" cacheByIndexPath:indexPath configuration:^(DecorationMoneyDetailsCell *cell) {
            cell.payExplainLabel.text = remarkString;
        }];
    }
    return 120;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 50)];
    if (section == 0) {
        nameLabel.text = @"第一期";
    }
    if (section == 1) {
        nameLabel.text = @"第二期";
    }
    if (section == 2) {
        nameLabel.text = @"第三期";
    }
    nameLabel.font = [UIFont systemFontOfSize:15.0];
    [headerView addSubview:nameLabel];
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(YGScreenWidth - 70, 0, 60, 50)];
    stateLabel.textAlignment = NSTextAlignmentRight;
    NSString *valueKey = [NSString stringWithFormat:@"status%ld",section + 1];
    NSString *status = [self.resultDictionary valueForKey:valueKey];
    if ([status isEqualToString:@"0"]) {
        stateLabel.text = @"待付款";
    }
    if ([status isEqualToString:@"1"]) {
        stateLabel.text = @"已支付";
    }
    if ([status isEqualToString:@"2"]) {
        stateLabel.text = @"未到期";
    }
    stateLabel.textColor = colorWithOrangeColor;
    stateLabel.font = [UIFont systemFontOfSize:15.0];
    [headerView addSubview:stateLabel];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView;
    footerView.backgroundColor = colorWithRedColor;
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

//立即付款
-(void)payClick:(UIButton *)button
{
    DecorationPayNowController *vc = [[DecorationPayNowController alloc]init];
    vc.orderIdString = self.orderIdString;
    vc.orderNumberString = [self.resultDictionary valueForKey:@"orderNum"];
    [self.navigationController pushViewController:vc animated:YES];

}

//订单信息详情
-(void)seeDetailClick:(UIButton *)button
{
    DecorationOrderDetailsController *vc = [[DecorationOrderDetailsController alloc]init];
    vc.orderIdString = self.orderIdString;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
