//
//  WKDecorationStageView.m
//  QingYouProject
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationStageView.h"
#import "WKDecorationCellPayButtonView.h"

#import "WKDecorationOrderDetailModel.h"

@interface WKDecorationStageView()<WKDecorationCellPayButtonViewDelegate>

@property (nonatomic, strong) UIButton *refundDetailBtn;

@property (nonatomic, strong) UIButton *refundBtn;

@end

@implementation WKDecorationStageView {
    CALayer *lineLayer;
    UILabel *stageTitleLabel;
    UILabel *stagePriceLab;
    WKDecorationCellPayButtonView *stageStateView;
}

- (instancetype)init {
    if (self == [super init]) {
        [self setupSubviews];
        [self makeConstaints];
    }
    return self;
}

- (void)setupSubviews {
    lineLayer = [CALayer layer];
    lineLayer.backgroundColor = colorWithLine.CGColor;
    [self.layer addSublayer:lineLayer];
    
    stageTitleLabel = [[UILabel alloc] init];
    stageTitleLabel.font = [UIFont systemFontOfSize:KSCAL(28.0)];
    stageTitleLabel.textColor = kCOLOR_333;
    [self addSubview:stageTitleLabel];
    
    stagePriceLab = [[UILabel alloc] init];
    stagePriceLab.font = [UIFont systemFontOfSize:KSCAL(28.0)];
    stagePriceLab.textColor = kCOLOR_PRICE_RED;
    [stagePriceLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self addSubview:stagePriceLab];
    
    stageStateView = [[WKDecorationCellPayButtonView alloc] init];
    stageStateView.actionDelegate = self;
    [self addSubview:stageStateView];
}

- (void)makeConstaints {
    [stageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.mas_equalTo(0);
    }];
    [stagePriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stageTitleLabel.mas_right);
        make.centerY.equalTo(stageTitleLabel);
    }];
    [stageStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(stagePriceLab);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(KSCAL(260)).priorityHigh();
        make.height.mas_equalTo(KSCAL(45));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    lineLayer.frame = CGRectMake(0, 0, self.width, 1);
}

- (void)configOrderInfo:(WKDecorationOrderListModel *)orderInfo withStage:(NSInteger)stage withInDetail:(BOOL)inDetail {
    
    if (!orderInfo.paymentList.count) {
        stagePriceLab.text = @"";
        stageTitleLabel.text = @"";
        [stageStateView removeAllAction];
        _refundBtn.hidden = YES;
        _refundDetailBtn.hidden = YES;
        return;
    }
    
    WKDecorationStageModel *stageInfo = orderInfo.paymentList[stage];
    stageTitleLabel.text = [NSString stringWithFormat:@"%@：", stageInfo.name];
    stagePriceLab.text   = [NSString stringWithFormat:@"¥ %@", stageInfo.amount];
    [stageStateView configStageModel:stageInfo withStage:stage inDetail:inDetail];
    
}

- (void)configOrderDetailInfo:(WKDecorationOrderDetailModel *)orderDetailInfo withStage:(NSInteger)stage withInDetail:(BOOL)inDetail {
    
    [self configOrderInfo:orderDetailInfo.orderInfo withStage:stage withInDetail:inDetail];
    if (stage == 0 && inDetail) {//订金阶段&&在详情中
        
        if (orderDetailInfo.orderInfo.refund && orderDetailInfo.orderInfo.status == 3) {//可以退款&&处于处理中状态
            self.refundBtn.hidden = NO;
            _refundDetailBtn.hidden = YES;
            [stageStateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.height.equalTo(stagePriceLab);
                make.right.mas_equalTo(0);
                make.left.equalTo(self.refundBtn.mas_right).offset(KSCAL(15));
                make.height.mas_equalTo(KSCAL(45));
            }];
            return;
        }
        
        if (!orderDetailInfo.orderInfo.refund) {//不能退款
            self.refundDetailBtn.hidden = NO;
            _refundBtn.hidden = YES;
            [stageStateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.height.equalTo(stagePriceLab);
                make.right.mas_equalTo(0);
                make.left.equalTo(self.refundDetailBtn.mas_right).offset(KSCAL(15));
                make.height.mas_equalTo(KSCAL(45));
            }];
            return;
        }
        
    }
    else {
        if (!_refundBtn || _refundBtn.hidden) {
            return;
        }
        _refundBtn.hidden = YES;
        _refundDetailBtn.hidden = YES;
        [stageStateView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.equalTo(stagePriceLab);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(KSCAL(260)).priorityHigh();
            make.height.mas_equalTo(KSCAL(45));
        }];
    }
}

- (void)click_refundDetailBtn {
    if ([self.delegate respondsToSelector:@selector(stageView:didClickActionType:forStage:)]) {
        [self.delegate stageView:self didClickActionType:WKDecorationOrderActionTypeRefundDetail forStage:0];
    }
}

- (void)click_refundBtn {
    if ([self.delegate respondsToSelector:@selector(stageView:didClickActionType:forStage:)]) {
        [self.delegate stageView:self didClickActionType:WKDecorationOrderActionTypeRefund forStage:0];
    }
}

#pragma mark - WKDecorationCellPayButtonViewDelegate
- (void)actionView:(WKDecorationCellPayButtonView *)actionView didClickActionType:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage {
    if ([self.delegate respondsToSelector:@selector(stageView:didClickActionType:forStage:)]) {
        [self.delegate stageView:self didClickActionType:actionType forStage:stage];
    }
}

#pragma mark - lazy load
- (UIButton *)refundBtn {
    if (!_refundBtn) {
        _refundBtn = [UIButton buttonWithTitle:@"申请退款" titleFont:KSCAL(28.0) titleColor:KCOLOR_MAIN];
        _refundBtn.layer.borderWidth = 1.0;
        _refundBtn.layer.borderColor = KCOLOR_MAIN.CGColor;
        _refundBtn.layer.cornerRadius = 4.0;
        [_refundBtn addTarget:self action:@selector(click_refundBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_refundBtn];
        
        [_refundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.equalTo(stagePriceLab.mas_right).offset(KSCAL(15));
            make.size.mas_equalTo(CGSizeMake(KSCAL(140), KSCAL(50)));
        }];
    }
    return _refundBtn;
}

- (UIButton *)refundDetailBtn {
    if (!_refundDetailBtn) {
        _refundDetailBtn = [UIButton buttonWithTitle:@"¥" titleFont:KSCAL(28.0) titleColor:KCOLOR_MAIN];
        _refundDetailBtn.layer.borderWidth = 1.0;
        _refundDetailBtn.layer.borderColor = KCOLOR_MAIN.CGColor;
        _refundDetailBtn.layer.cornerRadius = 4.0;
        [_refundDetailBtn addTarget:self action:@selector(click_refundDetailBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_refundDetailBtn];
        
        [_refundDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.equalTo(stagePriceLab.mas_right).offset(KSCAL(15));
            make.size.mas_equalTo(CGSizeMake(KSCAL(50), KSCAL(50)));
        }];
    }
    return _refundDetailBtn;
}

@end
