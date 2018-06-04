//
//  WKAfterSaleRecordCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKAfterSaleRecordCell.h"

@implementation WKAfterSaleRecordCell
{
    UILabel *_stateLab;
    UILabel *_timeLab;
    UILabel *_problemLab;
    UIView  *_certificateView;
    UILabel *_resultLab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupSubviews];
        [self makeConstraints];
    }
    return self;
}

- (void)setupSubviews {
    _stateLab = [UILabel labelWithFont:22 textColor:[UIColor redColor]];
    [self.contentView addSubview:_stateLab];
    
    _timeLab = [UILabel labelWithFont:14 textColor:[UIColor blackColor]];
    [self.contentView addSubview:_timeLab];
    
    _problemLab = [UILabel labelWithFont:14 textColor:[UIColor blackColor]];
    [self.contentView addSubview:_problemLab];
    
    _certificateView = [UIView new];
    _certificateView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_certificateView];
    
    _resultLab = [UILabel labelWithFont:14 textColor:[UIColor blackColor]];
    [self.contentView addSubview:_resultLab];
    
    _stateLab.text = @"售后申请已提交，等待系统处理";
    _timeLab.text = @"您于2018-05-18 15:56发起了售后申请:";
    _problemLab.text = @"xxxxxxxxxxxxxxx";
    _resultLab.text = @"处理结果：好的，马上派人跟进。";
}

- (void)makeConstraints {
    [_stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self->_stateLab);
        make.top.equalTo(self->_stateLab.mas_bottom).offset(10);
    }];
    
    [_problemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self->_stateLab);
        make.top.equalTo(self->_timeLab.mas_bottom).offset(10);
    }];
    
    [_certificateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self->_stateLab);
        make.top.equalTo(self->_problemLab.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [_resultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self->_stateLab);
        make.top.equalTo(self->_certificateView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-10);
    }];
}

@end
