//
//  IssueInvoiceViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "IssueInvoiceViewController.h"
#import "IssueInvoiceTableViewCell.h"
#import "InvoiceInfoManagerModel.h"
#import "PayConfirmViewController.h"
@interface IssueInvoiceViewController ()<UITableViewDelegate,UITableViewDataSource,IssueInvoiceTableViewCellDelegate>

@end

@implementation IssueInvoiceViewController
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    NSArray *_titleArray;
    NSString *_titleStr;
    NSString *_number;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
    // Do any additional setup after loading the view.
}
- (void)configAttribute
{
    UIBarButtonItem *item = [self createBarbuttonWithNormalTitleString:@"提交" selectedTitleString:@"" selector:@selector(submitButton)];
    self.navigationItem.rightBarButtonItem = item;
    _listArray = [[NSMutableArray alloc] init];
    _number = @"";
}
- (void)back
{
    [self.delegate issueInvoiceViewControllerTakeNumber:_number andTitle:((InvoiceInfoManagerModel *)_listArray[1]).content];
    [self.navigationController popViewControllerAnimated:YES];
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
        _number = ((InvoiceInfoManagerModel *)_listArray[3]).content;

        [self configUI];
    }
    if ([URLString isEqualToString:REQUEST_SaveInvoiceInformationManagement]) {
        [YGAppTool showToastWithText:@"发票信息保存成功"];
        //返回
        if ([((InvoiceInfoManagerModel *)_listArray[3]).content isEqualToString:@""]) {
            _number = ((InvoiceInfoManagerModel *)_listArray[3]).content;
        }
        [self.delegate issueInvoiceViewControllerTakeNumber:_number andTitle:((InvoiceInfoManagerModel *)_listArray[1]).content];
        [self.navigationController popViewControllerAnimated:YES];
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
    //发票抬头
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithDeepGray;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    titleLabel.text = @"发票抬头";
    titleLabel.frame = CGRectMake(10, 10,100, 20);
    [view addSubview:titleLabel];
    
    //发票抬头
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
    for (int i = 1; i<6; i++) {
        [_tableView registerClass:[IssueInvoiceTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"CrowdFundingAddProjectTableViewCelltextfield%d",i]];
    }
    [_tableView registerClass:[IssueInvoiceTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCellChossType"];

    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _listArray.count -2;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
     IssueInvoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdFundingAddProjectTableViewCellChossType" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        InvoiceInfoManagerModel *model = _listArray[indexPath.row+2];
        [cell setModel:model withIsChange:true];
        return cell;

    }else
    {
        IssueInvoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"CrowdFundingAddProjectTableViewCelltextfield%d",(int)indexPath.row] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        InvoiceInfoManagerModel *model = _listArray[indexPath.row+2];
        [cell setModel:model withIsChange:true];
        return cell;

    }

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

- (void)submitButton
{
    for (InvoiceInfoManagerModel *model in _listArray) {
        if ([model.content isEqualToString:@""]) {
            [YGAppTool showToastWithText:@"请填写完整信息"];
            return ;
        }
    }
 
//
//    [self startPostWithURLString:REQUEST_SaveInvoiceInformationManagement parameters:@{@"Telphone":YGSingletonMarco.user.myContractPhoneNumber,@"number":((InvoiceInfoManagerModel *)_listArray[3]).content,@"bankName":((InvoiceInfoManagerModel *)_listArray[4]).content,@"accountNumber":((InvoiceInfoManagerModel *)_listArray[5]).content,@"addrress":((InvoiceInfoManagerModel *)_listArray[6]).content,@"phone":((InvoiceInfoManagerModel *)_listArray[7]).content} showLoadingView:YES scrollView:nil];

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
//- (void)chooseTypeWithIndex:(int)index
//{
//    _model.title0 = [NSString stringWithFormat:@"%d",index];
//
//}
@end
