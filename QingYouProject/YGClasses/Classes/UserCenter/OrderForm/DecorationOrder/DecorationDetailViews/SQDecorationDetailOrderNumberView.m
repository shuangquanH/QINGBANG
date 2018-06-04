//
//  SQDecorationDetailOrderNumberView.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationDetailOrderNumberView.h"
#import "NSString+SQStringSize.h"

@implementation SQDecorationDetailOrderNumberView
{
    UILabel *_numberLab;
    UILabel *_createTimeLab;
    UILabel *_payTimeLab;
    UILabel *_finishedLab;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {
    
    if (!_numberLab) {
        [self setupSubviews];
    }
    
    _numberLab.text     = @"订单编号：21414352453452431";
    _createTimeLab.text = @"订单编号：21414352453452431";
    _payTimeLab.text  = @"订单编号：21414352453452431";
    _finishedLab.text = @"订单编号：21414352453452431";
    
}

- (void)setupSubviews {
    
    _numberLab = [UILabel labelWithFont:14 textColor:[UIColor blackColor]];
    [self addSubview:_numberLab];

    _createTimeLab = [UILabel labelWithFont:14 textColor:[UIColor blackColor]];
    [self addSubview:_createTimeLab];
    
    _payTimeLab = [UILabel labelWithFont:14 textColor:[UIColor blackColor]];
    [self addSubview:_payTimeLab];
    
    _finishedLab = [UILabel labelWithFont:14 textColor:[UIColor blackColor]];
    [self addSubview:_finishedLab];
                   
    [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(0);
    }];
    
    [_createTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(self->_numberLab);
        make.top.equalTo(self->_numberLab.mas_bottom).offset(8);
    }];
    
    [_payTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(self->_numberLab);
        make.top.equalTo(self->_createTimeLab.mas_bottom).offset(8);
    }];
    
    [_finishedLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(self->_numberLab);
        make.top.equalTo(self->_payTimeLab.mas_bottom).offset(8);
    }];
    
}

- (CGSize)viewSize {
    
    if (!_numberLab.text.length) return CGSizeMake(kScreenW, 44);
    
    CGFloat height = 4 * [_numberLab.text sizeWithFont:[UIFont systemFontOfSize:14.0] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height + 3 * 8 + 20;
    
    return CGSizeMake(kScreenW, height);
}

@end
