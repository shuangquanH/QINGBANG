//
//  WKUserInfoMessageCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKUserInfoMessageCell.h"

@implementation WKUserInfoMessageCell
{
    UILabel *_titleLabel;
    UILabel *_detailLabel;
    UILabel *_timeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _titleLabel = [UILabel labelWithFont:KSCAL(28) textColor:[UIColor blackColor]];
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [UILabel labelWithFont:KSCAL(28) textColor:[UIColor blackColor]];
    [self.contentView addSubview:_detailLabel];
    
    _timeLabel = [UILabel labelWithFont:KSCAL(28) textColor:colorWithPlaceholder];
    [self.contentView addSubview:_timeLabel];
    
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.layer.borderColor = colorWithLine.CGColor;
    self.contentView.layer.borderWidth = 1.0;
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(30));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(KSCAL(20));
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(KSCAL(20));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(_titleLabel);
        make.bottom.mas_equalTo(-KSCAL(20));
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(KSCAL(30));
        make.top.mas_equalTo(KSCAL(20));
        make.bottom.mas_equalTo(0);
    }];
    
    _titleLabel.text = @"装修服务付款提醒";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3.0];
    NSAttributedString *detail = [[NSAttributedString alloc] initWithString:@"您的装修服务订单“商品名称商品名称商品名称商品名称,有一笔款项待支付！" attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    _detailLabel.attributedText = detail;
    _timeLabel.text = @"2018-05-28  12:00:00";
}


@end
