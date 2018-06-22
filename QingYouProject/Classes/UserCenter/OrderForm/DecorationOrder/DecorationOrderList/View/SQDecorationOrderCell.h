//
//  SQDecorationOrderCell.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/17.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQBaseTableViewCell.h"

#import "WKDecorationDetailViewModel.h"
#import "WKDecorationOrderDetailModel.h"

#import "WKDecorationStageView.h"

@class SQDecorationOrderCell;

@protocol decorationOrderCellDelegate<NSObject>

@optional
/** 点击了按钮动作 */
- (void)decorationCell:(SQDecorationOrderCell *)decorationCell tapedOrderActionType:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage;

@end


/** 基本订单cell */
@interface SQDecorationOrderCell : SQBaseTableViewCell<WKDecorationDetailViewProtocol, WKDecorationStageViewDelegate>

@property (nonatomic, weak  ) id <decorationOrderCellDelegate>       delegate;

@property (nonatomic, assign) id model;
/** 是否在订单详情中(详情中可能需要展示退款) */
@property (nonatomic, assign) BOOL isInOrderDetail;

+ (CGFloat)cellHeightWithOrderInfo:(WKDecorationOrderListModel *)orderInfo;

@end


/** 多阶段cell */
@interface WKDecorationOrderMutableStageCell: SQDecorationOrderCell

@end

/** 受理中状态cell */
@interface WKDecorationDealingOrderCell: SQDecorationOrderCell

@end


