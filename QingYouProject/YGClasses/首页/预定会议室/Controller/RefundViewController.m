//
//  RefundViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RefundViewController.h"
#import "RefundModel.h"
#import "RefundHearderView.h"
#import "OtherReasonCell.h"

@interface RefundViewController () <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *reasonArray;
@property(nonatomic,strong)NSString *reasonString;//退款原因
@property(nonatomic,strong)NSString *textViewString;//

@end

@implementation RefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"申请退款";
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 0, 35, 35);
    [submitButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [submitButton setTitle:@"提交" forState:normal];
    [submitButton addTarget:self action:@selector(submitInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.reasonArray = [NSMutableArray array];
    NSArray *resp = @[
                         @{
                             @"reason":@"会议取消",
                             @"select":@"1"
                             },
                         @{
                             @"reason":@"人员有变动",
                             @"select":@"0"
                             },
                         @{
                             @"reason":@"会议时间改动",
                             @"select":@"0"
                             },
                         @{
                             @"reason":@"其他",
                             @"select":@"0"
                             },
                         ];
    [self.reasonArray addObjectsFromArray:[RefundModel mj_objectArrayWithKeyValuesArray:resp]];
    [self configTableView];
}

-(void)configTableView
{
    self.reasonString = @"会议取消";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight) style:UITableViewStyleGrouped];
//    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = YGScreenWidth * 0.13;
    [self.view addSubview:_tableView];
    
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    topView.backgroundColor = colorWithTable;
    
    UILabel *chooseReasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, YGScreenWidth - 30, 40)];
    chooseReasonLabel.text = @"选择取消原因";
    chooseReasonLabel.font = [UIFont systemFontOfSize:16.0];
    chooseReasonLabel.textColor = colorWithBlack;
    [topView addSubview:chooseReasonLabel];
    _tableView.tableHeaderView = topView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherReasonCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OtherReasonCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.delegate = self;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3 && [[self.reasonArray[3] valueForKey:@"select"] isEqualToString:@"1"])
    {
        return 1;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RefundHearderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"RefundHearderView" owner:self options:nil]firstObject];
    headerView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.13);
    headerView.tag = section;
    headerView.rowButton.tag = section;
    [headerView.rowButton addTarget:self action:@selector(rowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    RefundModel *model = self.reasonArray[section];
    headerView.refundModel = model;
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return YGScreenWidth * 0.13;
}

//header行点击
-(void)rowButtonClick:(UIButton *)button
{
//    for (int i = 0; i < 4; i++) {
//        RefundHearderView *headerView = [self.view viewWithTag:i];
//        headerView.radioButton.selected = NO;
//    }
//    RefundHearderView *selectView = [self.view viewWithTag:button.tag];
//    selectView.radioButton.selected = YES;
    for (int i = 0; i < self.reasonArray.count; i++) {
        RefundModel *model = self.reasonArray[i];
        NSString *string = model.select;
        string = @"0";
        model.select = string;
    }
    RefundModel *model = self.reasonArray[button.tag];
    if(button.tag == 3)
    {
        self.reasonString = self.textViewString;
    }
    else
    {
        self.reasonString = [self.reasonArray[button.tag] valueForKey:@"reason"];
    }
    NSString *selectString = model.select;
    selectString = @"1";
    model.select = selectString;
    [_tableView reloadData];
}

//提交
-(void)submitInfo:(UIButton *)button
{
    if (!self.reasonString.length) {
        self.reasonString = @"";
    }
    [YGNetService YGPOST:REQUEST_refund parameters:@{@"orderNum":self.orderNumString,@"refundStr":self.reasonString} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        [YGAppTool showToastWithText:@"取消成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    OtherReasonCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    if (textView.text.length == 0)
    {
        cell.placeholder.text = @"请输入内容";
    }
    else
    {
        cell.placeholder.text = @"";
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.textViewString = textView.text;
    self.reasonString = self.textViewString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
