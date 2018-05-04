//
//  SecondhandReplacementAddExpressViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplacementAddExpressViewController.h"
#import "YGActionSheetView.h"

@interface SecondhandReplacementAddExpressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    UITextField * _numberField ;
    UITextField * _companyField ;
    NSString * _companyNum;
}
@end

@implementation SecondhandReplacementAddExpressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle =@"填写物流信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _numberField =[[UITextField alloc]initWithFrame:CGRectMake(YGScreenWidth  - 25 -200, 0, 200, 44)];
    _numberField.placeholder = @"请填写物流单号";
    _numberField.font = [UIFont systemFontOfSize:15];
    _numberField.textColor =colorWithBlack;
    _numberField.delegate = self;
    _numberField.textAlignment =NSTextAlignmentRight;
    
    _companyField =[[UITextField alloc]initWithFrame:CGRectMake(YGScreenWidth  - 25 -200, 0, 200, 44)];
    _companyField.textAlignment =NSTextAlignmentRight;

    _companyField.font = [UIFont systemFontOfSize:15];
    _companyField.textColor =colorWithBlack;
    _companyField.userInteractionEnabled =NO;
    [self.view addSubview:self.tableView];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem backItemWithimage:nil highImage:nil target:self action:@selector(rightBarButtonClick:) title:@"提交" normalColor:LDMainColor highColor:LDMainColor titleFont:LDFont(14)];

}
-(void)rightBarButtonClick:(UIButton *)btn
{
    if(!_numberField.text.length)
    {
        [YGAppTool showToastWithText:@"请填写物流单号"];
        return;
    }
    if(!_companyNum.length)
    {
        [YGAppTool showToastWithText:@"请选择快递公司"];
        return;
    }
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    dict[@"orderNum"] = self.orderNum;
    dict[@"logNum"] = _numberField.text;
    dict[@"com"] = _companyNum;

    [YGNetService YGPOST:@"addLogisticsNum" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        [YGAppTool showToastWithText:@"提交成功"];

        [self.delegate secondhandReplacementAddExpressViewControllerDelegateReturnReloadViewWithRow:self.row];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row ==0)
        return;
    
    [YGNetService YGPOST:@"getExpressCompany" parameters:@{} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        NSArray *listArray = [NSArray array];
        listArray = [responseObject valueForKey:@"rList"];
        NSMutableArray *showMutableArray = [NSMutableArray array];
        NSMutableArray *comArray = [NSMutableArray array];

        for (int i = 0; i < listArray.count; i++) {
            [showMutableArray addObject:[listArray[i] valueForKey:@"name"]];
            [comArray addObject:[listArray[i] valueForKey:@"com"]];
        }
        
        [YGActionSheetView showAlertWithTitlesArray:showMutableArray handler:^(NSInteger selectedIndex, NSString *selectedString) {
            _companyField.text = selectedString;
            _companyNum = [NSString stringWithFormat:@"%@",comArray[selectedIndex]];
        }];
        
    } failure:^(NSError *error) {
        
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(indexPath.row ==0)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = colorWithBlack;
        cell.textLabel.text = @"填写物流单号";
  
        [cell addSubview:_numberField];
    }
    else
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = colorWithBlack;
        cell.textLabel.text = @"选择快递公司";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        [cell addSubview:_companyField];
    }

    return cell;
    
}

static NSString * const SecondhandReplacementSubstitutionWaitToGoodsTableViewCellID = @"SecondhandReplacementSubstitutionWaitToGoodsTableViewCellID";

- (UITableView *)tableView{
    
    if (!_tableView) {
        CGFloat H = kScreenH - YGNaviBarHeight ;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
      
    }
    return _tableView;
}

@end








