//
//  WKAddInvoiceAddressViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKAddInvoiceAddressViewController.h"

#import "WKInvoiceAddressAreaPicker.h"
#import "WKAnimationAlert.h"
#import "SQAddTicketApplyInputCell.h"
#import "PlaceholderAndNoticeTextView.h"

#import "YZLAreaModel.h"

@interface WKAddInvoiceAddressViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, SQAddTicketApplyInputCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) PlaceholderAndNoticeTextView *detailAddressTV;

@property (nonatomic, strong) WKInvoiceAddressAreaPicker *areaPicker;

@property (nonatomic, strong) NSString *areaString;

@end

@implementation WKAddInvoiceAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNavigaiton];
    [self setupSubviews];

}

- (void)layoutNavigaiton {
    if (self.editAddress) {
        self.naviTitle = @"编辑地址";
        [self setupAreaString];
    } else {
        self.naviTitle = @"新增地址";
        self.editAddress = [[WKInvoiceAddressModel alloc] init];
    }
}

- (void)setupSubviews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorInset = UIEdgeInsetsMake(0, KSCAL(30), 0, KSCAL(30));
    [self.view addSubview:_tableView];
    
    _confirmButton = [UIButton buttonWithTitle:@"确定" titleFont:KSCAL(38) titleColor:[UIColor whiteColor] bgColor:KCOLOR_MAIN];
    _confirmButton.layer.cornerRadius = KSCAL(50);
    [_confirmButton addTarget:self action:@selector(click_confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
    
    _detailAddressTV = [[PlaceholderAndNoticeTextView alloc] initWithFrame:CGRectZero];
    _detailAddressTV.placeholder = @"请填写详情地址，街道及门牌号";
    _detailAddressTV.placeholderFont = KFONT(28);
    _detailAddressTV.font = KFONT(28);
    _detailAddressTV.delegate = self;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(550));
    }];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(KSCAL(30));
        make.height.mas_equalTo(KSCAL(100));
        make.top.equalTo(_tableView.mas_bottom).offset(KSCAL(200));
    }];

}

- (void)setupAreaString {
    NSMutableString *tmp = [[NSMutableString alloc] initWithString:self.editAddress.provName];
    if (self.editAddress.cityName.length) {
        [tmp appendString:[NSString stringWithFormat:@" %@", self.editAddress.cityName]];
    }
    self.areaString = [tmp copy];
}

#pragma mark -
- (void)click_confirm {
    
    if (!self.editAddress.name.length) {
        [YGAppTool showToastWithText:@"请输入姓名"];
        return;
    }
    if (self.editAddress.name.length > 10) {
        [YGAppTool showToastWithText:@"姓名过长"];
        return;
    }
    if (!self.editAddress.phone.length) {
        [YGAppTool showToastWithText:@"请输入手机号码"];
        return;
    }
    if ([YGAppTool isNotPhoneNumber:self.editAddress.phone]) {
        [YGAppTool showToastWithText:@"手机号码不符合规则"];
        return;
    }
    if (!self.areaString.length) {
        [YGAppTool showToastWithText:@"请选择所在地区"];
        return;
    }
    if (!self.editAddress.detail.length) {
        [YGAppTool showToastWithText:@"请输入详细地址"];
        return;
    }
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    if (self.editAddress.ID.length) {//编辑地址
        NSDictionary *param = @{@"name": self.editAddress.name,
                                @"phone": self.editAddress.phone,
                                @"prov": self.editAddress.provName,
                                @"provId": @"0",
                                @"city": self.editAddress.cityName?:@"",
                                @"cityId": [NSString stringWithFormat:@"%@", self.editAddress.cityId==-1?@"":@(self.editAddress.cityId)],
                                @"dist": @"",
                                @"distId": @"0",
                                @"address": self.editAddress.detail,
                                @"id": self.editAddress.ID
                                };
        [SQRequest post:KAPI_INVOICEADDRESSUPDATE param:param success:^(id response) {
            [YGNetService dissmissLoadingView];
            if ([response[@"code"] longLongValue] == 0) {
                if (self.addressHandler) {
                    self.addressHandler(self.editAddress);
                }
                [YGAppTool showToastWithText:@"编辑成功"];
                [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:1.0];
            } else {
                [YGAppTool showToastWithText:response[@"msg"]];
            }
        } failure:^(NSError *error) {
            [YGNetService dissmissLoadingView];
            [YGAppTool showToastWithText:@"网络错误"];
        }];
    } else {//添加地址

        NSDictionary *param = @{@"name": self.editAddress.name,
                                @"phone": self.editAddress.phone,
                                @"prov": self.editAddress.provName,
                                @"provId": @"0",
                                @"city": self.editAddress.cityName?:@"",
                                @"cityId": [NSString stringWithFormat:@"%@", self.editAddress.cityId==-1?@"":@(self.editAddress.cityId)],
                                @"dist": @"",
                                @"distId": @"0",
                                @"address": self.editAddress.detail
                                };
        [SQRequest post:KAPI_INVOICEADDRESSADD param:param success:^(id response) {
            [YGNetService dissmissLoadingView];
            if ([response[@"code"] longLongValue] == 0) {
                if (self.addressHandler) {
                    self.addressHandler(nil);
                }
                [YGAppTool showToastWithText:@"添加成功"];
                [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:1.0];
            } else {
                [YGAppTool showToastWithText:response[@"msg"]];
            }
        } failure:^(NSError *error) {
            [YGNetService dissmissLoadingView];
            [YGAppTool showToastWithText:@"网络错误"];
        }];
    }
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {//详细地址
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textViewCell"];
            [cell.contentView addSubview:_detailAddressTV];
            [_detailAddressTV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
                make.left.mas_equalTo(KSCAL(30));
                make.top.mas_equalTo(KSCAL(20));
            }];
        }
        _detailAddressTV.text = self.editAddress.detail;
        return cell;
    }
    
    SQAddTicketApplyInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inputCell"];
    if (!cell) {
        cell = [[SQAddTicketApplyInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inputCell"];
        cell.contentAlignment = NSTextAlignmentRight;
        cell.delegate = self;
    }
    if (indexPath.row == 0) {
        cell.editEnable = YES;
        cell.keyboardType = UIKeyboardTypeDefault;
        [cell configTitle:@"姓名" placeHodler:@"请输入姓名" content:self.editAddress.name necessary:NO];
    } else if (indexPath.row == 1) {
        cell.editEnable = YES;
        cell.keyboardType = UIKeyboardTypeNumberPad;
        [cell configTitle:@"手机号" placeHodler:@"请输入手机号码" content:self.editAddress.phone necessary:NO];
    } else {
        cell.editEnable = NO;
        [cell configTitle:@"所在地区" placeHodler:@"请选择" content:self.areaString necessary:NO];
    }
    return cell;
}

#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return KSCAL(250);
    }
    return KSCAL(100);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {//地区
        [WKAnimationAlert showAlertWithInsideView:self.areaPicker animation:WKAlertAnimationTypeBottom canTouchDissmiss:NO];
    }
}

#pragma mark -
- (void)textViewDidChange:(UITextView *)textView {
    self.editAddress.detail = textView.text;
}

#pragma mark - SQAddTicketApplyInputCellDelegate
- (void)cell:(SQAddTicketApplyInputCell *)cell didEditTextField:(UITextField *)textField {
    NSIndexPath *index = [_tableView indexPathForCell:cell];
    if (!index) return;
    
    if (index.row == 0) {
        self.editAddress.name = textField.text;
    } else if (index.row == 1) {
        self.editAddress.phone = textField.text;
    }
}

#pragma mark -
- (WKInvoiceAddressAreaPicker *)areaPicker {
    if (!_areaPicker) {
        _areaPicker = [[WKInvoiceAddressAreaPicker alloc] initWithFrame:CGRectMake(0, 0, kScreenW, KSCAL(600))];
        @weakify(self)
        _areaPicker.areaPickerBlock = ^(NSDictionary *addressDic) {
            @strongify(self)
            
            YZLAreaModel *province = addressDic[@"province"];
            YZLAreaModel *city = addressDic[@"city"];
            self.editAddress.provName = province.name;
            self.editAddress.cityName = city.name;
            self.editAddress.cityId = city.ID;

            [self setupAreaString];
            [self.tableView reloadData];
        };
    }
    return _areaPicker;
}


@end
