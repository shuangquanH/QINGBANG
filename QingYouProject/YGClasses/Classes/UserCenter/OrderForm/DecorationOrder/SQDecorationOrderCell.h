//
//  SQDecorationOrderCell.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/17.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQBaseTableViewCell.h"

#import "SQDecorationDetailViewModel.h"
#import "SQDecorationDetailModel.h"

#import "SQDecorationCellPayButtonView.h"

@class SQDecorationOrderCell;

@protocol decorationOrderCellDelegate<NSObject>

@optional
/** 点击了取消订单  */
- (void)tapedCancelOrderWithModel:(NSString *)model;

/** 点击了付款按钮  */
- (void)tapedPaymentWithModel:(NSString *)model;

/** 点击了申请退款按钮  */
- (void)tapedApplyRefundWithModel:(id)model;

/** 点击支付阶段款  */
- (void)tapedPaymentWithStages:(int)stages model:(id)model;

/** 点击补登阶段款  */
- (void)tapedPatchWithStages:(int)stages model:(id)model;

/** 点击了按钮动作 */
- (void)decorationCell:(SQDecorationOrderCell *)decorationCell tapedOrderActionType:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage;

@end


/** 基本订单cell */
@interface SQDecorationOrderCell : SQBaseTableViewCell<SQDecorationDetailViewProtocol, SQDecorationCellPayButtonViewDelegate>

@property (nonatomic, weak  ) id <decorationOrderCellDelegate>       delegate;

@property (nonatomic, assign) id       model;

+ (CGFloat)cellHeight;

@end


/** 装修中和已完成状态cell */
@interface SQDecorationOrderCellWithThreeStage : SQDecorationOrderCell

@end

/** 受理中状态cell */
@interface WKDecorationDealingOrderCell: SQDecorationOrderCell

@end


