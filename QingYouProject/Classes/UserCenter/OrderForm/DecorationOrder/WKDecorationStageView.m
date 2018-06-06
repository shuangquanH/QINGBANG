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
    UIView *lineView;
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
    lineView = [UIView new];
    lineView.backgroundColor = colorWithLine;
    [self addSubview:lineView];
    
    stageTitleLabel = [[UILabel alloc] init];
    stageTitleLabel.font = [UIFont systemFontOfSize:KSCAL(28.0)];
    stageTitleLabel.textColor = KCOLOR(@"333333");
    [self addSubview:stageTitleLabel];
    
    stagePriceLab = [[UILabel alloc] init];
    stagePriceLab.font = [UIFont systemFontOfSize:KSCAL(28.0)];
    stagePriceLab.textColor = KCOLOR(@"e60012");
    [stagePriceLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self addSubview:stagePriceLab];

    stageStateView = [[SQDecorationCellPayButtonView alloc] init];
    stageStateView.actionDelegate = self;
    [self addSubview:stageStateView];
}

- (void)makeConstaints {
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1.0);
    }];
    [stageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-kScreenW+KSCAL(300));
    }];
    [stagePriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stageTitleLabel.mas_right).offset(KSCAL(20.0));
        make.centerY.equalTo(stageTitleLabel);
    }];
    [stageStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(stagePriceLab);
        make.right.mas_equalTo(0);
        make.left.equalTo(stagePriceLab.mas_right).offset(KSCAL(20.0));
    }];
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
