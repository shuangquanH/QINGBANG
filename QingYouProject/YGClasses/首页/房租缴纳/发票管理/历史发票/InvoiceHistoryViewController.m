//
//  InvoiceHistoryViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "InvoiceHistoryViewController.h"
#import "InvoiceHistoryTableViewCell.h"
#import "InvoiceHistoryModel.h"
#import "AskForInvoiceInputEmailAddressView.h"

@interface InvoiceHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    
}
@end

@implementation InvoiceHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
- (void)configAttribute
{
    self.naviTitle = @"历史发票";
    _listArray = [[NSMutableArray alloc] init];
}
- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_PaymentRecords parameters:@{@"phone":YGSingletonMarco.user.myContractPhoneNumber,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction) {
            [_listArray removeAllObjects];
        }

        [_listArray addObjectsFromArray:[InvoiceHistoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"List"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        if ([responseObject[@"List"] count] == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)configUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[InvoiceHistoryTableViewCell class] forCellReuseIdentifier:@"InvoiceHistoryTableViewCell"];
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvoiceHistoryTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"InvoiceHistoryTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModle:_listArray[indexPath.section]];
    //    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvoiceHistoryModel *model = _listArray[indexPath.section];
    if ([model.status isEqualToString:@"1"]) {
        return 110;
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
    footerView.backgroundColor = colorWithYGWhite;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [footerView addSubview:lineView];
    
    UILabel  *money = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , YGScreenWidth-20, 44)];
    InvoiceHistoryModel *model = _listArray[section];
    money.text = @"增值税专用发票";
    if ([model.status isEqualToString:@"1"]) {
        money.text = @"增值税普通发票";
    }
    money.textAlignment = NSTextAlignmentLeft;
    money.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    money.textColor = colorWithBlack;
    [footerView addSubview:money];
    
    return footerView;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    InvoiceHistoryModel *model = _listArray[section];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    footerView.backgroundColor = colorWithYGWhite;
    
    UIView *seprateLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    seprateLineView.backgroundColor = colorWithTable;
    [footerView addSubview:seprateLineView];
    
    if ([model.status isEqualToString:@"1"]) {
        footerView.frame = CGRectMake(0, 0, YGScreenWidth, 55);
        seprateLineView.frame = CGRectMake(0, 45, YGScreenWidth, 10);

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
        lineView.backgroundColor = colorWithTable;
        [footerView addSubview:lineView];

        UIButton *sendEmailButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-120,lineView.y+lineView.height+7,110,30)];
        [sendEmailButton setTitle:@"发送电子发票" forState:UIControlStateNormal];
        [sendEmailButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        [sendEmailButton setTitleColor:colorWithLightGray forState:UIControlStateSelected];
        [sendEmailButton addTarget:self action:@selector(sendEmailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        sendEmailButton.layer.borderColor = colorWithLine.CGColor;
        sendEmailButton.layer.borderWidth = 1;
        sendEmailButton.layer.cornerRadius = 15;
        sendEmailButton.tag = 10000+section;
        sendEmailButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [sendEmailButton sizeToFit];
        [footerView addSubview:sendEmailButton];
        sendEmailButton.frame = CGRectMake(YGScreenWidth-sendEmailButton.width-30,sendEmailButton.y,sendEmailButton.width+20,30);;
//        if ([model.type isEqualToString:@"1"]) {
//            sendEmailButton.selected = YES;
//            sendEmailButton.userInteractionEnabled = NO;
//        }
        
    }

    footerView.backgroundColor = colorWithYGWhite;
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    InvoiceHistoryModel *model = _listArray[section];
    if ([model.status isEqualToString:@"1"]) {
        return 55;
    }
    return 10;
}

- (void)sendEmailButtonAction:(UIButton *)button
{
    InvoiceHistoryModel *model = _listArray[button.tag-10000];
    
    [AskForInvoiceInputEmailAddressView showAlertWithTitle:model.email buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithPlaceholder,colorWithMainColor] handler:^(NSInteger buttonIndex,NSString *emailAddress) {
        if (buttonIndex == 1) {
            if ([YGAppTool isNotEmail:emailAddress]) {
                return;
            }
            
            if ([model.state isEqualToString:@"已发送"]) {
                [YGNetService YGPOST:REQUEST_PushHistoryIssueInvoice parameters:@{@"id":model.id,@"email":emailAddress} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                    [YGAlertView showAlertWithTitle:@"您的电子发票已发送到邮箱\n请注意查收" buttonTitlesArray:@[@"确定"] buttonColorsArray:@[colorWithMainColor] handler:^(NSInteger buttonIndex) {
                        [self refreshActionWithIsRefreshHeaderAction:YES];
                    }];
                } failure:^(NSError *error) {
                    
                }];
                
            }else
            {
                [YGNetService YGPOST:REQUEST_HistoryIssueInvoice parameters:@{@"id":model.id,@"status":model.status,@"email":emailAddress} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                    [YGAlertView showAlertWithTitle:@"您的电子发票已发送到邮箱\n请注意查收" buttonTitlesArray:@[@"确定"] buttonColorsArray:@[colorWithMainColor] handler:^(NSInteger buttonIndex) {
                        [self refreshActionWithIsRefreshHeaderAction:YES];
                    }];
                } failure:^(NSError *error) {
                    
                }];
            }
        }
    }];
}
@end
