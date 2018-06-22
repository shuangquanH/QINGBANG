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


- (void)configOrderDetailInfo:(WKDecorationOrderDetailModel *)orderDetailInfo {
    [self setupSubviewsByOrderInfo:orderDetailInfo];
    
    _numberLab.text     = [NSString stringWithFormat:@"订单编号：%@", orderDetailInfo.orderInfo.orderNum];
    _createTimeLab.text = [NSString stringWithFormat:@"创建时间：%@", orderDetailInfo.orderInfo.createTime];
    
}

- (void)setupSubviewsByOrderInfo:(WKDecorationOrderDetailModel *)orderInfo {
    
    
    
    if (!_numberLab) {
        _numberLab = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_666 textAlignment:NSTextAlignmentCenter];
        [self addSubview:_numberLab];
        
        _createTimeLab = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_666 textAlignment:NSTextAlignmentCenter];
        [self addSubview:_createTimeLab];
        
        [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KSCAL(30));
            make.top.mas_equalTo(KSCAL(36));
            make.centerX.mas_equalTo(0);
        }];
        
        [_createTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerX.equalTo(self->_numberLab);
            make.top.equalTo(self->_numberLab.mas_bottom).offset(KSCAL(14.0));
        }];
    }

    if (orderInfo.orderInfo.status == 3 || orderInfo.orderInfo.status == 4 || orderInfo.orderInfo.status == 5) {
        if (!_payTimeLab) {
            _payTimeLab = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_666 textAlignment:NSTextAlignmentCenter];
            [self addSubview:_payTimeLab];
            
            [_payTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.centerX.equalTo(self->_numberLab);
                make.top.equalTo(self->_createTimeLab.mas_bottom).offset(KSCAL(14));
            }];
        }
        _payTimeLab.hidden = NO;
        _payTimeLab.text  = [NSString stringWithFormat:@"付款时间：%@", orderInfo.orderInfo.paymentList.firstObject.payDate];
    }
    else {
        _payTimeLab.hidden = YES;
    }
    
    if (orderInfo.orderInfo.status == 5) {
        if (!_finishedLab) {
            _finishedLab = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_666 textAlignment:NSTextAlignmentCenter];
            [self addSubview:_finishedLab];
            [_finishedLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.centerX.equalTo(self->_numberLab);
                make.top.equalTo(self->_payTimeLab.mas_bottom).offset(KSCAL(14.0));
            }];
        }
        _finishedLab.hidden = NO;
        _finishedLab.text = [NSString stringWithFormat:@"完成时间：%@", orderInfo.orderInfo.paymentList.lastObject.payDate];
    }
    else {
        _finishedLab.hidden = YES;
    }
 
}

- (CGSize)viewSize {
    
    if (!_numberLab.text.length) return CGSizeMake(kScreenW, 44);
    
    NSInteger count = 0;
    for (UIView *v in self.subviews) {
        if (!v.hidden) {
            count += 1;
        }
    }
    
    CGFloat height = count * [_numberLab.text sizeWithFont:KFONT(28.0) andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height + (count - 1) * KSCAL(14) + KSCAL(72);
    return CGSizeMake(kScreenW, height);
}

@end
