//
//  WKAfterSaleRecordCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKAfterSaleRecordCell.h"
#import <CoreText/CoreText.h>

@implementation WKAfterSaleRecordCell
{
    UILabel *_stateLab;//状态
    UILabel *_timeLab;
    UILabel *_problemLab;
    UILabel *_certificateTipLab;
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

- (void)configInfo:(WKAfterSaleModel *)info {
    _stateLab.text = info.stateDesc;
    _timeLab.text = [NSString stringWithFormat:@"您于%@发起了售后申请：", info.createTime];
    _problemLab.text = [NSString stringWithFormat:@"问题描述：%@", info.afterSaleDesc];
    if (info.afterSaleState == 1) {
        _resultLab.text = @"";
        [_certificateView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_certificateTipLab.mas_right).offset(5);
            make.top.equalTo(_certificateTipLab);
            make.right.equalTo(_stateLab);
            make.height.mas_equalTo(KSCAL(130));
            make.bottom.mas_equalTo(-KSCAL(50));
        }];
    }
    else {
        _resultLab.text = [NSString stringWithFormat:@"处理结果：%@", info.afterSaleResult];
        [_certificateView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_certificateTipLab.mas_right).offset(5);
            make.top.equalTo(_certificateTipLab);
            make.right.equalTo(_stateLab);
            make.height.mas_equalTo(KSCAL(130));
        }];
    }
}

- (void)setupSubviews {
    _stateLab = [UILabel labelWithFont:KSCAL(44) textColor:kCOLOR_333];
    _stateLab.numberOfLines = 1;
    [self.contentView addSubview:_stateLab];
    
    _timeLab = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_999];
    _timeLab.numberOfLines = 1;
    [self.contentView addSubview:_timeLab];
    
    _problemLab = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_999];
    [self.contentView addSubview:_problemLab];
    
    _certificateTipLab = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_999];
    [_certificateTipLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:_certificateTipLab];
    
    _certificateView = [UIView new];
    _certificateView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_certificateView];
    
    _resultLab = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_999];
    [self.contentView addSubview:_resultLab];
 
    _certificateTipLab.text = @"凭证：";
}

- (void)makeConstraints {
    [_stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(30));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(KSCAL(50));
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self->_stateLab);
        make.top.equalTo(self->_stateLab.mas_bottom).offset(KSCAL(30));
    }];
    
    [_problemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self->_stateLab);
        make.top.equalTo(self->_timeLab.mas_bottom).offset(KSCAL(20));
    }];
    
    [_certificateTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_stateLab);
        make.top.equalTo(_problemLab.mas_bottom).offset(KSCAL(20));
    }];
    
    [_certificateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_certificateTipLab.mas_right).offset(5);
        make.top.equalTo(_certificateTipLab);
        make.right.equalTo(_stateLab);
        make.height.mas_equalTo(KSCAL(130));
    }];
    
    [_resultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self->_stateLab);
        make.top.equalTo(self->_certificateView.mas_bottom).offset(KSCAL(20));
        make.bottom.mas_equalTo(-KSCAL(50));
    }];
}


@end
