//
//  WKDecorationStageView.m
//  QingYouProject
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationStageView.h"
#import "SQDecorationCellPayButtonView.h"

@implementation WKDecorationStageView
{
    UIView *lineView;
    UILabel *stageTitleLabel;
    UILabel *stagePriceLab;
    SQDecorationCellPayButtonView *stageStateView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupSubviews];
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
//    [oneStagePrice setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//    [oneStageBgView addSubview:oneStagePrice];
//
//    oneStageState = [[SQDecorationCellPayButtonView alloc] init];
//    oneStageState.actionDelegate = self;
//    [oneStageBgView addSubview:oneStageState];
}

@end
