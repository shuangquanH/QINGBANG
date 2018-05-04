//
//  InvoiceInfoManagerViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "InvoiceInfoManagerViewController.h"
#import "IssueInvoiceTableViewCell.h"
#import "InvoiceInfoManagerModel.h"

@interface InvoiceInfoManagerViewController ()<UITableViewDelegate,UITableViewDataSource,IssueInvoiceTableViewCellDelegate>

@end

@implementation InvoiceInfoManagerViewController
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    NSArray *_titleArray;
    InvoiceInfoManagerModel *_model;
    NSString *_titleStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)configAttribute
{
    //提交
    UIButton *rightButton = [[UIButton alloc]init];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(changeOrSubmitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    _listArray = [[NSMutableArray alloc] init];
    _model = [[InvoiceInfoManagerModel alloc] init];
}
- (void)loadData
{
    [self startPostWithURLString:REQUEST_InvoiceInformationManagement parameters:@{@"phone":YGSingletonMarco.user.myContractPhoneNumber} showLoadingView:YES scrollView:nil];
}

-(void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    if ([URLString isEqualToString:REQUEST_InvoiceInformationManagement]) {
        NSDictionary *dictRoot = responseObject[@"invoiceInManager"];
        NSArray *keyArray;
        if ([dictRoot[@"content"] isEqualToString:@"1"]) {//普通发票
            keyArray = @[@"id",@"name",@"type",@"number"];
        }else
        {
            keyArray = @[@"id",@"name",@"type",@"number",@"bankName",@"accountNumber",@"addrress",@"phone"];
        }
        for (NSString *str  in keyArray) {
            InvoiceInfoManagerModel *model = [[InvoiceInfoManagerModel alloc] init];
            model.title = str;
            model.content = dictRoot[str];
            [_listArray addObject:model];
        }
        
        [self configUI];
    
    }

    if ([URLString isEqualToString:REQUEST_SaveInvoiceInformationManagement]) {
        [YGAppTool showToastWithText:@"发票信息保存成功"];
        
    }
}

- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
    
}
- (void)configUI
{
    self.naviTitle = @"发票信息管理";
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    view.backgroundColor = colorWithYGWhite;
    //最新账单
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithDeepGray;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    titleLabel.text = @"发票抬头";
    titleLabel.frame = CGRectMake(10, 10,100, 20);
    [view addSubview:titleLabel];
    
    //最新账单
    UILabel * headerLabel = [[UILabel alloc]init];
    headerLabel.textColor = colorWithBlack;
    headerLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    headerLabel.text = ((InvoiceInfoManagerModel *)_listArray[1]).content;
    headerLabel.textAlignment = NSTextAlignmentRight;
    headerLabel.frame = CGRectMake(titleLabel.x+titleLabel.width+10, 0, YGScreenWidth-(titleLabel.x+titleLabel.width+10)-10, titleLabel.height);
    [view addSubview:headerLabel];
    headerLabel.centery = titleLabel.centery;
    
    _titleStr = headerLabel.text;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = view;
    for (int i = 0; i<6; i++) {
        [_tableView registerClass:[IssueInvoiceTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"CrowdFundingAddProjectTableViewCelltextfield%d",i]];
    }
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _listArray.count-2;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IssueInvoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"CrowdFundingAddProjectTableViewCelltextfield%d",(int)indexPath.row] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    InvoiceInfoManagerModel *model = _listArray[indexPath.row+2];
    [cell setModel:model withIsChange:true];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 1) {
        return 1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    view.backgroundColor = colorWithLine;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    return 0;
}

- (void)changeOrSubmitButtonAction:(UIButton *)btn
{

    btn.selected = YES;
    
    for (InvoiceInfoManagerModel *model in _listArray) {
        if ([model.content isEqualToString:@""]) {
            [YGAppTool showToastWithText:@"请填写完整信息"];
            return ;
        }
    }
    if (_listArray.count > 4) {
        InvoiceInfoManagerModel *model = _listArray[7];
        if ([YGAppTool isNotPhoneNumber:model.content]) {
            return;
        }
           [self startPostWithURLString:REQUEST_SaveInvoiceInformationManagement parameters:@{@"Telphone":YGSingletonMarco.user.myContractPhoneNumber,@"number":((InvoiceInfoManagerModel *)_listArray[3]).content,@"bankName":((InvoiceInfoManagerModel *)_listArray[4]).content,@"accountNumber":((InvoiceInfoManagerModel *)_listArray[5]).content,@"addrress":((InvoiceInfoManagerModel *)_listArray[6]).content,@"phone":((InvoiceInfoManagerModel *)_listArray[7]).content} showLoadingView:YES scrollView:nil];
    }else
    {
           [self startPostWithURLString:REQUEST_SaveInvoiceInformationManagement parameters:@{@"Telphone":YGSingletonMarco.user.myContractPhoneNumber,@"number":((InvoiceInfoManagerModel *)_listArray[3]).content,@"bankName":@"",@"accountNumber":@"",@"addrress":@"",@"phone":@""} showLoadingView:YES scrollView:nil];
    }
 
    
}

#pragma 代理
- (void)IssueInvoiceTableViewCellTakeTextfield:(UITextField *)textfield
{
    
    int tag = (int)textfield.tag-10000;
    InvoiceInfoManagerModel *model = _listArray[tag+2];
    model.content = textfield.text;
    
}

@end
