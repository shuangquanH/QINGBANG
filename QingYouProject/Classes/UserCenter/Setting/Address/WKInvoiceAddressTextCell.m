//
//  WKInvoiceAddressTextCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/26.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKInvoiceAddressTextCell.h"
#import "UILabel+SQAttribut.h"
#import "WKInvoiceAddressModel.h"
#import "ManageMailPostModel.h"

@implementation WKInvoiceAddressTextCell {
    UILabel *_nameLabel;
    UILabel *_phoneLabel;
    UILabel *_addressLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _nameLabel = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_333];
    [_nameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    _nameLabel.numberOfLines = 1;
    [self.contentView addSubview:_nameLabel];
    
    _phoneLabel = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_333];
    _phoneLabel.numberOfLines = 1;
    _phoneLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_phoneLabel];
    
    _addressLabel = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_333];
    [self.contentView addSubview:_addressLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(30));
        make.top.mas_equalTo(KSCAL(30));
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(KSCAL(20));
        make.centerY.equalTo(_nameLabel);
        make.right.mas_equalTo(-KSCAL(30));
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.right.equalTo(_phoneLabel);
        make.top.equalTo(_nameLabel.mas_bottom).offset(KSCAL(20));
        make.bottom.mas_equalTo(-KSCAL(30));
    }];
}

- (void)configAddress:(WKInvoiceAddressModel *)addressInfo {
    _nameLabel.text = addressInfo.name?:@"";
    _phoneLabel.text = addressInfo.phone?:@"";
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@", addressInfo.provName?:@"", addressInfo.cityName?:@"", addressInfo.distName?:@"", addressInfo.detail?:@""];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3.0;
    _addressLabel.attributedText = [[NSAttributedString alloc] initWithString:address attributes:@{NSParagraphStyleAttributeName: style}];
}

- (void)configMailAddress:(ManageMailPostModel *)addressInfo {
    _nameLabel.text = addressInfo.name;
    _phoneLabel.text = addressInfo.phone;
    
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@", addressInfo.prov?:@"", addressInfo.city?:@"", addressInfo.dist?:@"", addressInfo.address?:@""];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3.0;
    _addressLabel.attributedText = [[NSAttributedString alloc] initWithString:address attributes:@{NSParagraphStyleAttributeName: style}];
}

@end
