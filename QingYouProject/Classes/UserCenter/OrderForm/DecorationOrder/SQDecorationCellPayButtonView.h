//
//  SQDecorationCellPayButtonView.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/17.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQDecorationDetailModel.h"

typedef NS_ENUM(NSUInteger, WKDecorationOrderActionType) {
    WKDecorationOrderActionTypePay,         //付款
    WKDecorationOrderActionTypeCancel,      //取消订单
    WKDecorationOrderActionTypeDelete,      //删除订单
    WKDecorationOrderActionTypeRepair,      //补登
    WKDecorationOrderActionTypeCallService, //联系客服
    WKDecorationOrderActionTypeRefund,      //申请退款
    WKDecorationOrderActionTypeRefundDetail //退款详情
};

@class SQDecorationCellPayButtonView;
@protocol SQDecorationCellPayButtonViewDelegate<NSObject>

- (void)actionView:(SQDecorationCellPayButtonView *)actionView didClickActionType:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage;

@end

@interface SQDecorationCellPayButtonView : UIView

@property (nonatomic, weak) id<SQDecorationCellPayButtonViewDelegate> actionDelegate;
/** 设置阶段模型 */
- (void)configStageModel:(WKDecorationStageModel *)stageModel withStage:(NSInteger)stage canRefund:(BOOL)canRefund inRefund:(BOOL)inRefund inDetail:(BOOL)inDetail;


@end
