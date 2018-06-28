//
//  SQTicketApplyViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQTicketApplyViewController.h"
#import "SQTicketApplyListViewController.h"
#import "WKInvoiceAddressViewController.h"

#import "WKInvoiceModel.h"
#import "WKInvoiceAddressModel.h"
#import "WKDecorationOrderDetailModel.h"

#import "UILabel+SQAttribut.h"

@interface SQTicketApplyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISwitch *sendSwitch;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) NSArray<NSMutableArray *> *tableData;

@property (nonatomic, assign) BOOL isNeedPostMail;

@property (nonatomic, strong) WKInvoiceModel *invoiceInfo;

@property (nonatomic, strong) WKInvoiceAddressModel *postInfo;

@end

@implementation SQTicketApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviTitle = @"开票申请";
    
    [self sendDefaultInfoReqeust];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
    _isNeedPostMail = YES;
    
    _tableData = @[
                   @[@{@"title": @"发票类型", @"detail": @"纸质发票", @"accessoryType": @(0)},
                     @{@"title": @"发票内容", @"detail": @"明细", @"accessoryType": @(0)},
                     @{@"title": @"发票抬头", @"detail": @"",    @"accessoryType": @(1)}].mutableCopy,
                   
                   @[@{@"title": @"是否邮寄", @"detail": @"", @"accessoryType": @(2)},
                     @{@"title": @"邮寄地址", @"detail": @"", @"accessoryType": @(1)}].mutableCopy
                   ];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = KSCAL(90);
    _tableView.separatorInset = UIEdgeInsetsMake(0, KSCAL(30), 0, KSCAL(30));
    [self.view addSubview:_tableView];
    
    _confirmButton = [UIButton buttonWithTitle:@"提交申请" titleFont:KSCAL(38) titleColor:[UIColor whiteColor] bgColor:KCOLOR_MAIN];
    [_confirmButton addTarget:self action:@selector(click_confirmButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
        
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(100));
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.equalTo(self.confirmButton.mas_top);
    }];
}

#pragma mark - reqeust
- (void)sendDefaultInfoReqeust {
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    [SQRequest post:KAPI_GETDEFAULTINFO param:nil success:^(id response) {
        [YGNetService dissmissLoadingView];
        if ([response[@"code"] longLongValue] == 0) {
            self.postInfo = [WKInvoiceAddressModel yy_modelWithJSON:response[@"data"][@"addressInfo"]];
            self.invoiceInfo = [WKInvoiceModel yy_modelWithJSON:response[@"data"][@"invoiceInfo"]];
            [self.tableView reloadData];
        } else {
            [YGAppTool showToastWithText:response[@"msg"]];
        }
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
        [YGAppTool showToastWithText:@"网络错误"];
    }];
}

#pragma mark - action
- (void)postMailValueChanged:(UISwitch *)switcher {
    _isNeedPostMail = !_isNeedPostMail;
    if (_isNeedPostMail) {
        [self.tableData[1] addObject:@{@"title": @"邮寄地址", @"detail": @"", @"accessoryType": @(1)}];
    }
    else {
        [self.tableData[1] removeLastObject];
    }
    [self.tableView reloadData];
}

- (void)click_confirmButton {
    
    if (!self.invoiceInfo.title.length) {
        [YGAppTool showToastWithText:@"请选择发票抬头"];
        return;
    }
    
    if (self.sendSwitch.isOn && !self.postInfo.ID.length) {
        [YGAppTool showToastWithText:@"请选择邮寄地址"];
        return;
    }
    
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    
    NSDictionary *param;
    if (self.sendSwitch.isOn) {
        param =  @{@"orderId": self.orderDetailInfo.orderInfo.ID,
                   @"invoiceInfoId": self.invoiceInfo.ID,
                   @"addressId": self.postInfo.ID,
                   @"ispost": @(1)
                   };
    }
    else {
        param =  @{@"orderId": self.orderDetailInfo.orderInfo.ID,
                   @"invoiceInfoId": self.invoiceInfo.ID,
                   @"ispost": @(0)
                   };
    }
    
    [SQRequest post:KAPI_APPLYINVOICE param:param success:^(id response) {
        [YGNetService dissmissLoadingView];
        if ([response[@"code"] longLongValue] == 0) {
            [YGAppTool showToastWithText:@"申请成功，等待审核"];
            self.orderDetailInfo.orderInfo.invoice = YES;
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.5];
        } else {
            [YGAppTool showToastWithText:response[@"msg"]];
        }
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
        [YGAppTool showToastWithText:@"网络错误"];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData objectAtIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.textColor = kCOLOR_666;
        cell.textLabel.font = KFONT(28);
        cell.detailTextLabel.font = KFONT(28);
    }
    cell.detailTextLabel.textColor = kCOLOR_666;

    NSDictionary *dict = [[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = dict[@"title"];
    cell.detailTextLabel.text = dict[@"detail"];
    
    NSInteger accessoryType = [dict[@"accessoryType"] integerValue];
    if (accessoryType == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (accessoryType == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryView = self.sendSwitch;
    }
    
    if (indexPath.section == 0 && indexPath.row == 2) {//发票抬头
        if (self.invoiceInfo.title.length) {
            cell.detailTextLabel.textColor = kCOLOR_666;
            cell.detailTextLabel.text = self.invoiceInfo.title;
        }
        else {
            cell.detailTextLabel.textColor = colorWithPlaceholder;
            cell.detailTextLabel.text = @"请选择";
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {//邮寄地址
        if (self.postInfo.detail.length) {
            cell.detailTextLabel.textColor = kCOLOR_666;
            cell.detailTextLabel.text = self.postInfo.detail;
        }
        else {
            cell.detailTextLabel.textColor = colorWithPlaceholder;
            cell.detailTextLabel.text = @"请选择";
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0 && indexPath.row == 2) {//发票抬头列表
        SQTicketApplyListViewController *next = [SQTicketApplyListViewController new];
        next.defaultInvoiceId = self.invoiceInfo.ID;
        next.selectInvoiceBlock = ^(WKInvoiceModel *invoiceInfo) {
            self.invoiceInfo = invoiceInfo;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:next animated:YES];
        return;
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {//邮寄地址管理
        WKInvoiceAddressViewController *vc = [[WKInvoiceAddressViewController alloc] init];
        vc.addressSelecter = ^(WKInvoiceAddressModel *addressInfo) {
            self.postInfo = addressInfo;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!_isNeedPostMail && section == 1) {
        return self.footerView;
    }
    UIView *view = [tableView dequeueReusableCellWithIdentifier:@"footer"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footer"];
    }
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (!_isNeedPostMail && section == 1) {
        return KSCAL(60);
    }
    return KSCAL(20);
}

#pragma mark - lazy load
- (UISwitch *)sendSwitch {
    if (!_sendSwitch) {
        _sendSwitch = [[UISwitch alloc] init];
        _sendSwitch.on = YES;
        _sendSwitch.onTintColor = kCOLOR_RGB(59, 186, 229);
        [_sendSwitch addTarget:self action:@selector(postMailValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _sendSwitch;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, KSCAL(60))];
        UILabel *tipLab = [UILabel labelWithFont:KSCAL(26) textColor:colorWithLightGray text:@" 可联系客户经理索取"];
        [tipLab appendImage:[UIImage imageNamed:@"invoicetitle_redpoint"] imageFrame:CGRectMake(0, 0, 7, 7) withType:SQAppendImageInLeft];
        [_footerView addSubview:tipLab];
        [tipLab sizeToFit];
        tipLab.x = KSCAL(30);
        tipLab.centery = KSCAL(30);
    }
    return _footerView;
}

@end
