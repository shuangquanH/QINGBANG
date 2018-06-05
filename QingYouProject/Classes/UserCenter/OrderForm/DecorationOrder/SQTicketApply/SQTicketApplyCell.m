//
//  SQTicketApplyCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQTicketApplyCell.h"
#import "WKInvoiceModel.h"

@implementation SQTicketApplyCell
{
    UILabel *_nameLab;
    UILabel *_numberLab;
    UILabel *_organizationLab;
    UILabel *_defaultLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews {
    _nameLab = [UILabel labelWithFont:15.0 textColor:[UIColor blackColor]];
    [self.contentView addSubview:_nameLab];
    
    _numberLab = [UILabel labelWithFont:15.0 textColor:[UIColor blackColor]];
    [self.contentView addSubview:_numberLab];
    
    _organizationLab = [UILabel labelWithFont:15.0 textColor:[UIColor blackColor]];
    [_organizationLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:_organizationLab];
    
    _defaultLabel = [UILabel labelWithFont:13.0 textColor:[UIColor redColor] textAlignment:NSTextAlignmentCenter];
    _defaultLabel.text = @"默认";
    [_defaultLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_defaultLabel sizeToFit];
    _defaultLabel.size = CGSizeMake(_defaultLabel.width + 6, _defaultLabel.height + 4);
    [self.contentView addSubview:_defaultLabel];
    _defaultLabel.hidden = YES;

    
    [_defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-KSCAL(15.0));
        make.top.equalTo(self.contentView.mas_centerY).offset(4);
    }];
    
    [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(15.0));
        make.right.equalTo(self->_defaultLabel.mas_left).offset(-10);
        make.top.equalTo(self.contentView.mas_centerY).offset(4);
    }];
}

- (void)configInvoiceInfo:(WKInvoiceModel *)invoiceInfo {
    if (invoiceInfo.is_personal) {
        _organizationLab.text = @"个人";
        _numberLab.hidden = YES;
        _nameLab.text = invoiceInfo.invoiceName;
        
        [_nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_numberLab);
            make.centerY.mas_equalTo(0);
            make.right.equalTo(self->_organizationLab.mas_left).offset(-10);
        }];
    }
    else {
        _organizationLab.text = @"公司";
        _numberLab.hidden = NO;
        _numberLab.text = invoiceInfo.invoiceDutyNum;
        _nameLab.text = invoiceInfo.invoiceName;
        
        [_nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_numberLab);
            make.bottom.equalTo(self.mas_centerY).offset(-4);
            make.right.equalTo(self->_organizationLab.mas_left).offset(-10);
        }];
    }
    
    if (invoiceInfo.isDefault) {
        _defaultLabel.hidden = NO;
        [_organizationLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self->_defaultLabel);
            make.bottom.equalTo(self.mas_centerY).offset(-4);
        }];
    }
    else {
        _defaultLabel.hidden = YES;
        [_organizationLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self->_defaultLabel);
            make.centerY.mas_equalTo(0);
        }];
    }
}

@end
