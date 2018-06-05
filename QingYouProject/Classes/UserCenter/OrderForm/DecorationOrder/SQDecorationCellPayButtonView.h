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
/** 是否在详情中，详情中会多出申请退款和查看退款详情入口 */
@property (nonatomic, assign) BOOL isInDetail;
/** 设置订单模型，以及阶段类型(0:定金 1:阶段1 2:阶段2 3:阶段3, 默认为0) */
- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo stage:(NSInteger)stage;

@end
