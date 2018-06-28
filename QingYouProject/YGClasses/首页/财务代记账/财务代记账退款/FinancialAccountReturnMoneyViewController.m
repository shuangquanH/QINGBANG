//
//  FinancialAccountReturnMoneyViewController.m
//  QingYouProject
//
//  Created by apple on 2017/11/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "FinancialAccountReturnMoneyViewController.h"
#import "MyFinancialAccountTableViewCell.h"
#import "MyIntegrationIndustryTableViewCell.h"
#import "IntegrationIndustryModel.h"

@interface FinancialAccountReturnMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * _reason;
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *btnArray;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;


@end

@implementation FinancialAccountReturnMoneyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    CGFloat Y = KAPP_HEIGHT - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight - YGBottomMargin;

    self.naviTitle =@"退款页面";
    UIButton * submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, Y, KAPP_WIDTH, YGNaviBarHeight + YGBottomMargin)];
    [submitBtn setTitle:@"提交" forState: UIControlStateNormal];
    [self.view addSubview:submitBtn];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.backgroundColor  = colorWithMainColor;
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
  
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if([self.isPush isEqualToString:@"FinancialAccount"])
    {
        MyFinancialAccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MyFinancialAccountTableViewCellID forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = self.financialAccountDetailModel;
        return cell;
    }
    else
    {
        MyIntegrationIndustryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MyIntegrationIndustryTableViewCellID forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = self.integrationModel;
        return cell;
    }

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.isPush isEqualToString:@"FinancialAccount"])
        return 175;
    else
        return 160;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 110)];
    footView.backgroundColor = [UIColor whiteColor];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
    line.backgroundColor = colorWithLine;
    [footView addSubview:line];
    
        UILabel *reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, line.y ,100, 35)];
        reasonLabel.textColor = colorWithBlack;
        reasonLabel.font = [UIFont systemFontOfSize:14.0];
        reasonLabel.text = @"退款原因";
    [footView addSubview:reasonLabel];
    
    self.btnArray = [[NSMutableArray alloc]init];
    NSArray * titleArry =@[@"多拍/拍错/不想要",@"信息填写错误",@"其他"];
    UIButton * flagBtn;
    for(int i =0 ;i<titleArry.count;i++)
    {
        UIButton * button  = [UIButton buttonWithType:UIButtonTypeCustom];
        
        float btnH =0;
        if(i==0)
        {
            btnH =  ([NSString stringWithFormat:@"%@",titleArry[i]].length  - 2)* 12  + 30;
            button.frame = CGRectMake(15 +  flagBtn.x + flagBtn.width , reasonLabel.y+ reasonLabel.height , btnH, 30);
        }
        else
        {
            btnH =  [NSString stringWithFormat:@"%@",titleArry[i]].length * 12  + 30;
            button.frame = CGRectMake(10 +  flagBtn.x + flagBtn.width , reasonLabel.y+ reasonLabel.height , btnH, 30);
        }
       

        [button setTitle:titleArry[i] forState:UIControlStateNormal];
        [button setTitleColor:colorWithBlack forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 15;
        button.layer.borderColor = colorWithLine.CGColor;
        button.tag = i;
        [button addTarget:self action:@selector(chooseMark:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 1;
        [footView addSubview:button];
        [self.btnArray addObject:button];
        flagBtn = button;
    }

    return footView;
}
- (void)chooseMark:(UIButton *)sender {
    
    _reason =sender.titleLabel.text;
    
    
    sender.selected = !sender.selected;
    
    for (NSInteger j = 0; j < [self.btnArray count]; j++) {
        UIButton *btn = self.btnArray[j] ;
        if (sender.tag == j) {
            btn.selected = sender.selected;
        } else {
            btn.selected = NO;
        }
        btn.layer.borderColor = colorWithLine.CGColor;
        [btn setTitleColor:colorWithBlack forState:UIControlStateNormal];
    }
    
    UIButton *btn = self.btnArray[sender.tag];
    if (sender.selected) {
        btn.layer.borderColor = colorWithMainColor.CGColor;
        [btn setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        
    } else {
        btn.layer.borderColor = colorWithLine.CGColor;
        [btn setTitleColor:colorWithBlack forState:UIControlStateNormal];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
        return 85;
}

static NSString * const MyFinancialAccountTableViewCellID = @"MyFinancialAccountTableViewCellID";
static NSString * const MyIntegrationIndustryTableViewCellID = @"MyIntegrationIndustryTableViewCellID";

- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat Y = KAPP_HEIGHT - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight - YGBottomMargin;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KAPP_WIDTH, Y) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.estimatedRowHeight = 120;
        _tableView.rowHeight = 220;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.estimatedRowHeight =0 ;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
        
        [_tableView registerNib:[UINib  nibWithNibName:NSStringFromClass([MyFinancialAccountTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MyFinancialAccountTableViewCellID];
        [_tableView registerNib:[UINib  nibWithNibName:NSStringFromClass([MyIntegrationIndustryTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MyIntegrationIndustryTableViewCellID];
        
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

-(void)submitBtnClick
{
    if(!_reason.length)
    {
        [YGAppTool showToastWithText:@"请选择退款原因"];
        return;
    }
    if([self.isPush isEqualToString:@"FinancialAccount"])
    {
        NSString * url = @"FinanceRefundOrder";
        
        NSDictionary *parameters = @{
                                     @"orderID":self.financialAccountDetailModel.orderID,
                                     @"refundReason":_reason,
                                     };
        
        [YGNetService YGPOST:url parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
            [self.delegate reloadViewWithReturnMonryWithReson:responseObject[@"refundReason"] withTime:responseObject[@"refundDate"] withRow:self.row];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:nil];
    }
    else
    {
        NSString * url = @"CommerceRefundOrder";
        
        
        NSDictionary *parameters = @{
                                     @"orderID":self.integrationModel.orderID,
                                     @"refundReason":_reason,
                                     };
        
        [YGNetService YGPOST:url parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
           
            [self.delegate reloadViewWithReturnMonryWithReson:responseObject[@"refundReason"] withTime:responseObject[@"refundDate"] withRow:self.row];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:nil];
    }

}
@end






