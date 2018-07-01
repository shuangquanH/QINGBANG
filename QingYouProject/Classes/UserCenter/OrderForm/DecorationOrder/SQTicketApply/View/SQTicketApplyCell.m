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
    _nameLab = [UILabel labelWithFont:KSCAL(34) textColor:kCOLOR_333];
    _nameLab.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLab.numberOfLines = 1;
    [self.contentView addSubview:_nameLab];
    
    _numberLab = [UILabel labelWithFont:KSCAL(24) textColor:kCOLOR_666];
    _numberLab.lineBreakMode = NSLineBreakByTruncatingTail;
    _numberLab.numberOfLines = 1;
    [self.contentView addSubview:_numberLab];
    
    _organizationLab = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_666];
    [_organizationLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:_organizationLab];
    
    _defaultLabel = [UILabel labelWithFont:KSCAL(28) textColor:KCOLOR_MAIN textAlignment:NSTextAlignmentLeft];
    [_defaultLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    _defaultLabel.text = @"【默认】";
    _defaultLabel.hidden = YES;
    [self.contentView addSubview:_defaultLabel];

    [_organizationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-KSCAL(30));
    }];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(30));
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-3);
    }];
    [_defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLab.mas_right);
        make.bottom.equalTo(_nameLab);
        make.right.mas_equalTo(_organizationLab.mas_left).offset(-8);
    }];
    [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLab);
        make.top.equalTo(self.contentView.mas_centerY).offset(3);
        make.right.mas_equalTo(_organizationLab.mas_left).offset(-8);
    }];
}

- (void)configInvoiceInfo:(WKInvoiceModel *)invoiceInfo {
    if (invoiceInfo.type == 1) {
        _organizationLab.text = @"个人";
        _numberLab.hidden = YES;
        _nameLab.text = invoiceInfo.title;
        
        [_nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KSCAL(30));
            make.centerY.mas_equalTo(0);
        }];
    }
    else {
        _organizationLab.text = @"公司";
        _numberLab.hidden = NO;
        _numberLab.text = invoiceInfo.taxNo;
        _nameLab.text = invoiceInfo.title;
        
        [_nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KSCAL(30));
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-3);
        }];
    }
    
    _defaultLabel.hidden = !invoiceInfo.isDefault;
}

@end
