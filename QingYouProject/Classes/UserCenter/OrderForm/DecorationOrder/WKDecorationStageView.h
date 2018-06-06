//
//  WKDecorationStageView.h
//  QingYouProject
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKDecorationStageModel;

@interface WKDecorationStageView : UIView
//设置阶段模型，阶段数，是否能退款(阶段数为0订金时需要)，是否在退款中(阶段数为0订金时需要)，是否在详情中(阶段数为0订金时需要)，
- (void)configStageModel:(WKDecorationStageModel *)stageModel withStage:(NSInteger)stage canRefund:(BOOL)canRefund inRefund:(BOOL)inRefund inDetail:(BOOL)inDetail;

@end
