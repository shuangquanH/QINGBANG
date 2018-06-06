//
//  SQAddTicketApplyViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQAddTicketApplyViewController.h"

#import "SQAddTicketApplyInputCell.h"
#import "WKInvoiceModel.h"

@interface SQAddTicketApplyViewController ()<UITableViewDelegate, UITableViewDataSource, SQAddTicketApplyInputCellDelegate>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *selectView;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIButton *selectDefaultButton;

@property (nonatomic, strong) UIButton *companyBtn;

@property (nonatomic, strong) UIButton *personalBtn;

@property (nonatomic, assign) BOOL isEdit;

@end

@implementation SQAddTicketApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _isEdit = _invoiceInfo;
    self.naviTitle = _isEdit ? @"编辑抬头" : @"添加抬头";
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
    if (!_invoiceInfo) {
        _invoiceInfo = [WKInvoiceModel new];
    }
    
    _selectView = [UIView new];
    [self.view addSubview:_selectView];
    
    _companyBtn = [UIButton new];
    [_companyBtn setTitle:@"企业" forState:UIControlStateNormal];
    [_companyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_companyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_companyBtn addTarget:self action:@selector(click_selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [_selectView addSubview:_companyBtn];
    _companyBtn.selected = !self.invoiceInfo.is_personal;
    
    _personalBtn = [UIButton new];
    [_personalBtn setTitle:@"个人" forState:UIControlStateNormal];
    [_personalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_personalBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_personalBtn addTarget:self action:@selector(click_selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [_selectView addSubview:_personalBtn];
    _personalBtn.selected = self.invoiceInfo.is_personal;

    
    _selectDefaultButton = [UIButton new];
    [_selectDefaultButton setTitle:@"设置为默认抬头" forState:UIControlStateNormal];
    [_selectDefaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_selectDefaultButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    _selectDefaultButton.selected = _invoiceInfo.isDefault;
    [_selectDefaultButton addTarget:self
                             action:@selector(click_defaultButton) forControlEvents:UIControlEventTouchUpInside];
    [_selectDefaultButton sizeToFit];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    _confirmButton = [UIButton new];
    [_confirmButton setBackgroundColor:[UIColor redColor]];
    [_confirmButton setTitle:@"提交" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(click_confirmButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
        }
        else {
            make.bottom.mas_equalTo(-self.view.layoutMargins.bottom);
        }
    }];
    [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [_companyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(KSCAL(15.0));
    }];
    
    [_personalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.equalTo(self->_companyBtn.mas_right).offset(10.0);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.confirmButton.mas_top);
        make.top.equalTo(self.selectView.mas_bottom);
    }];
}

- (void)fillInvoiceInfoWithIndexPath:(NSIndexPath *)indexPath forCell:(SQAddTicketApplyInputCell *)cell {
    if (indexPath.row == 0) {
        [cell configTitle:@"名称：" placeHodler:@"请输入抬头名称" content:self.invoiceInfo.invoiceName];
        return;
    }
    if (!self.invoiceInfo.is_personal) {
        if (indexPath.row == 1) {
            [cell configTitle:@"税号：" placeHodler:@"请输入纳税人识别号" content:self.invoiceInfo.invoiceDutyNum];
        }
        else if (indexPath.row == 2) {
            [cell configTitle:@"企业地址：" placeHodler:@"请输入企业注册地址" content:self.invoiceInfo.companyAddress];
        }
        else if (indexPath.row == 3) {
            [cell configTitle:@"电话号码：" placeHodler:@"请输入企业电话号码" content:self.invoiceInfo.companyPhone];
        }
        else if (indexPath.row == 4) {
            [cell configTitle:@"开户银行：" placeHodler:@"请输入企业开户银行" content:self.invoiceInfo.companyBank];
        }
        else if (indexPath.row == 5) {
            [cell configTitle:@"银行账户：" placeHodler:@"请输入企业银行账户" content:self.invoiceInfo.companyBankAccount];
        }
    }
}

#pragma mark - action
- (void)click_confirmButton {
    
    if (_personalBtn.isSelected) {//个人
        self.invoiceInfo.companyBank = nil;
        self.invoiceInfo.companyPhone = nil;
        self.invoiceInfo.companyAddress = nil;
        self.invoiceInfo.companyBankAccount = nil;
        self.invoiceInfo.invoiceDutyNum = nil;
    }

    NSDictionary *param = [self.invoiceInfo yy_modelToJSONObject];
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    [SQRequest post:(_isEdit?KAPI_EDITINVOICE:KAPI_ADDINVOICE) param:param success:^(id response) {
        [YGNetService dissmissLoadingView];
        if ([response[@"state"] isEqualToString:@"success"]) {
            [YGAppTool showToastWithText:(_isEdit?@"修改成功":@"添加成功")];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.5];
        } else {
            [YGAppTool showToastWithText:response[@"data"][@"msg"]];
        }
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
        [YGAppTool showToastWithText:@"网络错误"];
    }];
}

- (void)click_selectButton:(UIButton *)sender {
    if (sender.isSelected) return;
    
    if (sender == _personalBtn) {
        self.invoiceInfo.is_personal = YES;
        _companyBtn.selected = NO;
    }
    else {
        self.invoiceInfo.is_personal = NO;
        _personalBtn.selected = NO;
    }
    sender.selected = YES;
    [self.tableView reloadData];
}

- (void)click_defaultButton {
    _selectDefaultButton.selected = !_selectDefaultButton.isSelected;
    self.invoiceInfo.isDefault = _selectDefaultButton.isSelected;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.invoiceInfo.is_personal) {
        return 2;
    }
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((self.invoiceInfo.is_personal && indexPath.row == 1) || (!self.invoiceInfo.is_personal && indexPath.row == 6)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectCell"];
            [cell.contentView addSubview:self.selectDefaultButton];
            [self.selectDefaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
            }];
        }
        return cell;
    }
    
    SQAddTicketApplyInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[SQAddTicketApplyInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.delegate = self;
    }
    [self fillInvoiceInfoWithIndexPath:indexPath forCell:cell];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        cell.separatorInset = UIEdgeInsetsMake(0, kScreenW, 0, 0);
    }
    else {
        cell.separatorInset = UIEdgeInsetsZero;
    }
}

#pragma mark - SQAddTicketApplyInputCellDelegate
- (void)cell:(SQAddTicketApplyInputCell *)cell didEditTextField:(UITextField *)textField {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath) return;
    
    if (indexPath.row == 0) {
        self.invoiceInfo.invoiceName = textField.text;
        return;
    }
    if (!self.invoiceInfo.is_personal) {
        if (indexPath.row == 1) {
            self.invoiceInfo.invoiceDutyNum = textField.text;
        }
        else if (indexPath.row == 2) {
            self.invoiceInfo.companyAddress = textField.text;
        }
        else if (indexPath.row == 3) {
            self.invoiceInfo.companyPhone = textField.text;
        }
        else if (indexPath.row == 4) {
            self.invoiceInfo.companyBank = textField.text;
        }
        else if (indexPath.row == 5) {
            self.invoiceInfo.companyBankAccount = textField.text;
        }
    }
}

@end
