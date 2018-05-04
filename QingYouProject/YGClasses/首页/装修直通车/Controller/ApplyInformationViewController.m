//
//  ApplyInformationViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ApplyInformationViewController.h"
#import "CompanyTextViewCell.h"
#import "ReserveInputCell.h"
#import "ReserveChooseCell.h"
#import "AreaSelectViewController.h"
#import "DesignEffectViewController.h"


@interface ApplyInformationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ApplyInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"填写申请信息";
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.frame = CGRectMake(0, 0, 35, 35);
    [completeButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [completeButton setTitle:@"提交" forState:UIControlStateNormal];
    completeButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [completeButton addTarget:self action:@selector(completeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:completeButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self configUI];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseArea:) name:@"decoration" object:nil];
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight) style:UITableViewStyleGrouped];
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
    if (indexPath.row == 0) {
        CompanyTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyTextViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CompanyTextViewCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.xingLabel.hidden = YES;
        return cell;
    }
    if (indexPath.row == 1) {
        ReserveInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReserveInputCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ReserveInputCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text = @"手机号码";
        cell.titleLabel.textColor = colorWithDeepGray;
        cell.textField.placeholder = @"请输入联系电话";
        cell.textField.keyboardType = UIKeyboardTypePhonePad;
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
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return UITableViewAutomaticDimension;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        AreaSelectViewController * areaView =[[AreaSelectViewController alloc]init];
        areaView.tag = 2;
        [self.navigationController pushViewController:areaView animated:YES];
    }
}

- (void)chooseArea:(NSNotification *)notifit
{
    NSString * addressStr =[notifit object];
    ReserveChooseCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.timeLabel.text = addressStr;
}

//提交
-(void)completeButtonClick:(UIButton *)button
{
    CompanyTextViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ReserveInputCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    ReserveChooseCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (!cell1.companyTextView.text.length)
    {
        [YGAppTool showToastWithText:@"请输入企业/个人全称！"];
        return;
    }
    
    if (!cell2.textField.text.length)
    {
        [YGAppTool showToastWithText:@"请输入电话号码！"];
        return;
    }
    if ([YGAppTool isNotPhoneNumber:cell2.textField.text])
    {
        return;
    }
    if ([cell3.timeLabel.text isEqualToString:@"请选择"])
    {
        [YGAppTool showToastWithText:@"请选择所在地区！"];
        return;
    }
    [YGNetService YGPOST:@"addFitmentApply" parameters:@{@"name":cell1.companyTextView.text,@"phone":cell2.textField.text,@"address":cell3.timeLabel.text,@"effectId":self.effectIdString,@"uid":YGSingletonMarco.user.userId,@"designer":self.designerIdString} showLoadingView:NO scrollView:nil success:^(id responseObject) {

        NSLog(@"%@",responseObject);
        
        if ([[responseObject valueForKey:@"flag"] integerValue] == 1) {
            
            [YGAppTool showToastWithText:@"提交成功"];
            
            
            UINavigationController *navc = self.navigationController;
            NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
            for (UIViewController *vc in [navc viewControllers]) {
                [viewControllers addObject:vc];
                if ([vc isKindOfClass:[DesignEffectViewController class]]) {
                    break;
                }
            }
            [navc setViewControllers:viewControllers];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
