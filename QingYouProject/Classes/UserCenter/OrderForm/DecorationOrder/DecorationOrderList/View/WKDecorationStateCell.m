//
//  WKDecorationStateCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationStateCell.h"

#import "NSString+SQStringSize.h"

@implementation WKDecorationStateCell
{
    UILabel *_stateLabel;
    UILabel *_otherStateLabel;
    CALayer *_bottomLineLayer;
    CAShapeLayer *_stateMaskLayer;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _stateLabel = [UILabel labelWithFont:KSCAL(28) textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    _stateLabel.backgroundColor = KCOLOR_MAIN;
    [self.contentView addSubview:_stateLabel];
    [_stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(0.1);
        make.height.mas_equalTo(KSCAL(40));
        make.bottom.mas_equalTo(-KSCAL(20));
    }];
    
    _stateMaskLayer = [CAShapeLayer layer];
    _stateLabel.layer.mask = _stateMaskLayer;
}

- (void)reloadWithTitle:(NSString *)title {
    if (!title.length) return;
    
    _stateLabel.text = title;
    
    CGFloat labelW = [title sizeWithFont:KFONT(28) andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + KSCAL(64);
    [_stateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(labelW);
    }];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(labelW-KSCAL(28), 0)];
    [path addLineToPoint:CGPointMake(labelW, KSCAL(40))];
    [path addLineToPoint:CGPointMake(0, KSCAL(40))];
    [path addLineToPoint:CGPointZero];
    _stateMaskLayer.path = path.CGPath;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!_bottomLineLayer) {
        _bottomLineLayer = [CALayer layer];
        _bottomLineLayer.backgroundColor = KCOLOR_MAIN.CGColor;
        [self.contentView.layer addSublayer:_bottomLineLayer];
    }
    
    CGFloat maxY = self.isInDetail ? KSCAL(19) : KSCAL(20);
    _bottomLineLayer.frame = CGRectMake(0, self.contentView.height-maxY-1.5, self.contentView.width, 1.5);
}

- (void)setIsInDetail:(BOOL)isInDetail {
    
    if (_isInDetail == isInDetail) return;
    
    _isInDetail = isInDetail;
    _bottomLineLayer.hidden = isInDetail;
    if (isInDetail) {
        [_stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(0.1);
            make.height.mas_equalTo(KSCAL(40));
            make.centerY.mas_equalTo(0);
        }];
    }
}

- (CGSize)intrinsicContentSize {
    return [self viewSize];
}

- (void)configOrderInfo:(WKDecorationOrderDetailModel *)orderInfo {
    if (orderInfo.status == 3 && orderInfo.isInRefund) {//受理中，待退款
        if (!_otherStateLabel) {
            _otherStateLabel = [UILabel labelWithFont:KSCAL(28) textColor:KCOLOR_MAIN];
            [self.contentView addSubview:_otherStateLabel];
            [_otherStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_stateLabel.mas_right);
                make.centerY.equalTo(_stateLabel);
            }];
        }

        _otherStateLabel.hidden = NO;
        _otherStateLabel.text = @"(待退款)";
    }
    else if (orderInfo.status == 4) {//阶段款
        if (!_otherStateLabel) {
            _otherStateLabel = [UILabel labelWithFont:KSCAL(28) textColor:KCOLOR_MAIN];
            [self.contentView addSubview:_otherStateLabel];
            [_otherStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_stateLabel.mas_right);
                make.centerY.equalTo(_stateLabel);
            }];
        }
        
        _otherStateLabel.hidden = NO;
        _otherStateLabel.text = [NSString stringWithFormat:@"(%@)", orderInfo.paymentList.lastObject.name];
    }
    else {
        _otherStateLabel.hidden = YES;
    }
    [self reloadWithTitle:orderInfo.orderTitle];
}

- (CGSize)viewSize {
    if (self.isInDetail) {
        return CGSizeMake(kScreenW, KSCAL(78));
    }
    return CGSizeMake(kScreenW, KSCAL(110));
}

@end
