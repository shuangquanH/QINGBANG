//
//  WKDecorationStageView.h
//  QingYouProject
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQDecorationCellPayButtonView.h"

@class WKDecorationStageModel, WKDecorationStageView;

@protocol WKDecorationStageViewDelegate<NSObject>

- (void)stageView:(WKDecorationStageView *)stageView didClickActionType:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage;

@end

@interface WKDecorationStageView : UIView

@property (nonatomic, weak) id<WKDecorationStageViewDelegate> delegate;

//设置阶段模型，阶段数，是否能退款(阶段数为0订金时需要)，是否在退款中(阶段数为0订金时需要)，是否在详情中(阶段数为0订金时需要)，
- (void)configStageModel:(WKDecorationStageModel *)stageModel withStage:(NSInteger)stage canRefund:(BOOL)canRefund inRefund:(BOOL)inRefund inDetail:(BOOL)inDetail;

@end
