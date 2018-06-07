//
//  WKDecorationStageView.m
//  QingYouProject
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationStageView.h"
#import "SQDecorationCellPayButtonView.h"

#import "SQDecorationDetailModel.h"

@interface WKDecorationStageView()<SQDecorationCellPayButtonViewDelegate>

@end

@implementation WKDecorationStageView
{
    CALayer *lineLayer;
    UILabel *stageTitleLabel;
    UILabel *stagePriceLab;
    SQDecorationCellPayButtonView *stageStateView;
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

    stageStateView = [[SQDecorationCellPayButtonView alloc] init];
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
        make.left.mas_equalTo(KSCAL(260));
        make.height.mas_equalTo(KSCAL(45));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    lineLayer.frame = CGRectMake(0, 0, self.width, 1);
}

- (void)configStageModel:(WKDecorationStageModel *)stageModel withStage:(NSInteger)stage canRefund:(BOOL)canRefund inRefund:(BOOL)inRefund inDetail:(BOOL)inDetail {
    stageTitleLabel.text = [NSString stringWithFormat:@"%@：", stageModel.stageName];
    stagePriceLab.text = [NSString stringWithFormat:@"¥ %@", stageModel.stagePrice];
    [stageStateView configStageModel:stageModel withStage:stage canRefund:canRefund inRefund:inRefund inDetail:inDetail];
}

#pragma mark - SQDecorationCellPayButtonViewDelegate
- (void)actionView:(SQDecorationCellPayButtonView *)actionView didClickActionType:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage {
    if ([self.delegate respondsToSelector:@selector(stageView:didClickActionType:forStage:)]) {
        [self.delegate stageView:self didClickActionType:actionType forStage:stage];
    }
}

@end
