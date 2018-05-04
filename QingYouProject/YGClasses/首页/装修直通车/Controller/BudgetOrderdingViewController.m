//
//  BudgetOrderdingViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "BudgetOrderdingViewController.h"
#import "ApplyCostCell.h"
#import "CompanyTextViewCell.h"
#import "ReserveInputCell.h"
#import "ReserveChooseCell.h"
#import "AreaSelectViewController.h"

@interface BudgetOrderdingViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation BudgetOrderdingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"预算下单";
    UIButton *intructButton = [UIButton buttonWithType:UIButtonTypeCustom];
    intructButton.frame = CGRectMake(0, 0, 35, 35);
    intructButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [intructButton setTitle:@"提交" forState:UIControlStateNormal];
    [intructButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [intructButton addTarget:self action:@selector(subInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:intructButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self configUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseArea:) name:@"decoration" object:nil];
}

//
-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.estimatedRowHeight = 50;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1) {
        ApplyCostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyCostCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ApplyCostCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.inputTextField.placeholder = @"";
        }
        if(indexPath.row == 0)
        {
            cell.nameLabel.text = @"房屋面积";
            cell.unitLabel.text = @"m²";
        }
        if(indexPath.row == 1)
        {
            cell.nameLabel.text = @"装修预算";
            cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
        return cell;
    }
    if (indexPath.row == 2)
    {
        CompanyTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyTextViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CompanyTextViewCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.xingLabel.hidden = YES;
        return cell;
    }
    if (indexPath.row == 3) {
        ReserveInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReserveInputCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ReserveInputCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text = @"手机号码";
        cell.titleLabel.textColor = colorWithDeepGray;
        cell.textField.placeholder = @"请输入联系电话";
        return cell;
    }
    ReserveChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReserveChooseCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ReserveChooseCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.titleLabel.text = @"所在地区";
    cell.titleLabel.textColor = colorWithDeepGray;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        return UITableViewAutomaticDimension;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        AreaSelectViewController * areaView =[[AreaSelectViewController alloc]init];
        areaView.tag = 2;
        [self.navigationController pushViewController:areaView animated:YES];
    }
}

- (void)chooseArea:(NSNotification *)notifit
{
    NSString * addressStr =[notifit object];
    ReserveChooseCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    cell.timeLabel.text = addressStr;
}

//提交
-(void)subInfo:(UIButton *)button
{
    if (![self loginOrNot])
    {
        return;
    }
    ApplyCostCell *cell0 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ApplyCostCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    CompanyTextViewCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    ReserveInputCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    ReserveChooseCell *cell4 =  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    if (!cell0.inputTextField.text.length) {
        [YGAppTool showToastWithText:@"请填写房屋面积！"];
        return ;
    }
    if (!cell1.inputTextField.text.length) {
        [YGAppTool showToastWithText:@"请填写装修预算！"];
        return ;
    }
    if (!cell2.companyTextView.text.length) {
        [YGAppTool showToastWithText:@"请填写企业/个人名称！"];
        return ;
    }
    if (!cell3.textField.text.length) {
        [YGAppTool showToastWithText:@"请填写联系电话！"];
        return ;
    }
    if ([cell4.timeLabel.text isEqualToString:@"请选择"]) {
        [YGAppTool showToastWithText:@"请选择所在地区！"];
        return ;
    }
    if ([YGAppTool isNotPhoneNumber:cell3.textField.text])
    {
        return;
    }
    [YGNetService YGPOST:@"addBudgetApply" parameters:@{@"name":cell2.companyTextView.text,@"phone":cell3.textField.text,@"address":cell4.timeLabel.text,@"uid":YGSingletonMarco.user.userId,@"areaCount":cell0.inputTextField.text,@"price":cell1.inputTextField.text} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if([[responseObject valueForKey:@"flag"] integerValue] == 1)
        {
            [YGAppTool showToastWithText:@"提交成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
