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

#import "UIButton+SQImagePosition.h"

@interface SQAddTicketApplyViewController ()<UITableViewDelegate, UITableViewDataSource, SQAddTicketApplyInputCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
//头部选择背景视图
@property (nonatomic, strong) UIView   *selectView;
//确认按钮
@property (nonatomic, strong) UIButton *confirmButton;
//设置默认按钮
@property (nonatomic, strong) UIButton *selectDefaultButton;
//企业
@property (nonatomic, strong) UIButton *companyBtn;
//个人
@property (nonatomic, strong) UIButton *personalBtn;
//是否为编辑抬头
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
    
    if (!_invoiceInfo) {//默认添加企业
        _invoiceInfo = [WKInvoiceModel new];
        _invoiceInfo.type = 2;
    }

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = KSCAL(88);
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.separatorInset = UIEdgeInsetsMake(0, KSCAL(30), 0, KSCAL(30));
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    _confirmButton = [UIButton buttonWithTitle:@"提交" titleFont:KSCAL(38) titleColor:[UIColor whiteColor] bgColor:KCOLOR_MAIN];
    [_confirmButton addTarget:self action:@selector(click_confirmButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
    
    _selectDefaultButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KSCAL(60), KSCAL(60))];
    _selectDefaultButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_selectDefaultButton setImage:[UIImage imageNamed:(_invoiceInfo.isDefault?@"invoicetitle_circle_selected":@"invoicetitle_circle")] forState:UIControlStateNormal];
    [_selectDefaultButton addTarget:self action:@selector(click_defaultButton) forControlEvents:UIControlEventTouchUpInside];
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

- (void)fillInvoiceInfoWithIndexPath:(NSIndexPath *)indexPath forCell:(SQAddTicketApplyInputCell *)cell {
    if (indexPath.row == 1) {
        [cell configTitle:@"名称" placeHodler:@"请输入抬头名称" content:self.invoiceInfo.title necessary:YES];
        cell.keyboardType = UIKeyboardTypeDefault;
        return;
    }
    
    if (self.invoiceInfo.type == 2) {//企业发票
        if (indexPath.row == 2) {
            [cell configTitle:@"税号" placeHodler:@"请输入纳税人识别号" content:self.invoiceInfo.taxNo necessary:YES];
            cell.keyboardType = UIKeyboardTypeDefault;
        }
        else if (indexPath.row == 3) {
            [cell configTitle:@"企业地址" placeHodler:@"请输入企业注册地址" content:self.invoiceInfo.address necessary:NO];
            cell.keyboardType = UIKeyboardTypeDefault;
        }
        else if (indexPath.row == 4) {
            [cell configTitle:@"电话号码" placeHodler:@"请输入企业电话号码" content:self.invoiceInfo.tel necessary:NO];
            cell.keyboardType = UIKeyboardTypeNumberPad;
        }
        else if (indexPath.row == 5) {
            [cell configTitle:@"开户银行" placeHodler:@"请输入企业开户银行" content:self.invoiceInfo.bankName necessary:NO];
            cell.keyboardType = UIKeyboardTypeDefault;
        }
        else if (indexPath.row == 6) {
            [cell configTitle:@"银行账户" placeHodler:@"请输入企业银行账户" content:self.invoiceInfo.bankNo necessary:NO];
            cell.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
}

#pragma mark - action
- (void)click_confirmButton {
    
    if (!_invoiceInfo.title.length) {
        [YGAppTool showToastWithText:@"请填写发票抬头名称"];
        return;
    }
    
    if (_invoiceInfo.type == 2 && !_invoiceInfo.taxNo.length) {//企业税号必填
        [YGAppTool showToastWithText:@"请填写发票抬头税号"];
        return;
    }
    
    if (_personalBtn.isSelected) {//个人，不需要其它数据
        self.invoiceInfo.bankName = nil;
        self.invoiceInfo.tel = nil;
        self.invoiceInfo.address = nil;
        self.invoiceInfo.bankNo = nil;
        self.invoiceInfo.taxNo = nil;
    }

    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[self.invoiceInfo yy_modelToJSONObject]];
    param[@"isDefault"] = @(self.invoiceInfo.isDefault);
    param[@"default"] = nil;
    if (_isEdit) {
        param[@"id"] = self.invoiceInfo.ID;
    }
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    [SQRequest post:(_isEdit?KAPI_EDITINVOICE:KAPI_ADDINVOICE) param:[param copy] success:^(id response) {
        [YGNetService dissmissLoadingView];
        if ([response[@"code"] longLongValue] == 0) {
            if (self.invoiceHandler) {
                if (_isEdit) {
                    self.invoiceHandler(self.invoiceInfo);
                } else {
                    self.invoiceHandler(nil);
                }
            }
            [YGAppTool showToastWithText:(_isEdit?@"修改成功":@"添加成功")];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.0];
        } else {
            [YGAppTool showToastWithText:response[@"msg"]];
        }
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
        [YGAppTool showToastWithText:@"网络错误"];
    }];
}

- (void)click_selectButton:(UIButton *)sender {
    if (sender.isSelected) return;
    
    if (sender == _personalBtn) {
        self.invoiceInfo.type = 1;
    }
    else {
        self.invoiceInfo.type = 2;
    }
    
    if (_invoiceInfo.type == 1) {
        [_personalBtn setImage:[UIImage imageNamed:@"invoicetitle_circle_selected"] forState:UIControlStateNormal];
        [_companyBtn setImage:[UIImage imageNamed:@"invoicetitle_circle"] forState:UIControlStateNormal];
    }
    else {
        [_personalBtn setImage:[UIImage imageNamed:@"invoicetitle_circle"] forState:UIControlStateNormal];
        [_companyBtn setImage:[UIImage imageNamed:@"invoicetitle_circle_selected"] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

- (void)click_defaultButton {
    self.invoiceInfo.isDefault = !self.invoiceInfo.isDefault;
    [_selectDefaultButton setImage:[UIImage imageNamed:(_invoiceInfo.isDefault?@"invoicetitle_circle_selected":@"invoicetitle_circle")] forState:UIControlStateNormal];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.invoiceInfo.type == 1) {
            return 2;
        }
        return 7;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {//选择视图
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.selectView];
            [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
        }
        return cell;
    }
    
    if (indexPath.section == 1) {//设置默认cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = self.selectDefaultButton;
            cell.textLabel.textColor = kCOLOR_333;
            cell.textLabel.font = KFONT(28);
            cell.textLabel.text = @"设为默认地址";
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return KSCAL(20);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, KSCAL(20))];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}


#pragma mark - SQAddTicketApplyInputCellDelegate
- (void)cell:(SQAddTicketApplyInputCell *)cell didEditTextField:(UITextField *)textField {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath) return;
    
    if (indexPath.row == 1) {
        self.invoiceInfo.title = textField.text;
        return;
    }
    if (self.invoiceInfo.type == 2) {
        if (indexPath.row == 2) {
            self.invoiceInfo.taxNo = textField.text;
        }
        else if (indexPath.row == 3) {
            self.invoiceInfo.address = textField.text;
        }
        else if (indexPath.row == 4) {
            self.invoiceInfo.tel = textField.text;
        }
        else if (indexPath.row == 5) {
            self.invoiceInfo.bankName = textField.text;
        }
        else if (indexPath.row == 6) {
            self.invoiceInfo.bankNo = textField.text;
        }
    }
}

#pragma mark - lazy load
- (UIView *)selectView {
    if (!_selectView) {
        
        _selectView = [UIView new];
        [self.view addSubview:_selectView];
        
        _companyBtn = [UIButton buttonWithTitle:@"企业" titleFont:KSCAL(28) titleColor:kCOLOR_333];
        [_companyBtn addTarget:self action:@selector(click_selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:_companyBtn];
        
        _personalBtn = [UIButton buttonWithTitle:@"个人" titleFont:KSCAL(28) titleColor:kCOLOR_333];
        [_personalBtn addTarget:self action:@selector(click_selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:_personalBtn];
       
        if (_invoiceInfo.type == 1) {
            [_personalBtn setImage:[UIImage imageNamed:@"invoicetitle_circle_selected"] forState:UIControlStateNormal];
            [_companyBtn setImage:[UIImage imageNamed:@"invoicetitle_circle"] forState:UIControlStateNormal];
        }
        else {
            [_personalBtn setImage:[UIImage imageNamed:@"invoicetitle_circle"] forState:UIControlStateNormal];
            [_companyBtn setImage:[UIImage imageNamed:@"invoicetitle_circle_selected"] forState:UIControlStateNormal];
        }
        
        [_companyBtn sizeToFit];
        [_companyBtn sq_setImagePosition:SQImagePositionLeft spacing:6];
        [_personalBtn sizeToFit];
        [_personalBtn sq_setImagePosition:SQImagePositionLeft spacing:6];

        [_companyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(KSCAL(30));
        }];
        
        [_personalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.equalTo(_companyBtn.mas_right).offset(KSCAL(80));
        }];
    }
    return _selectView;
}

@end
