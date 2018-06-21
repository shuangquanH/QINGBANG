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

//设置订单模型-阶段索引-是否在首页
- (void)configOrderDetailInfo:(WKDecorationOrderDetailModel *)orderDetailInfo withStage:(NSInteger)stage withInDetail:(BOOL)inDetail;

- (void)configOrderInfo:(WKDecorationOrderListModel *)orderInfo withStage:(NSInteger)stage withInDetail:(BOOL)inDetail;

@end
