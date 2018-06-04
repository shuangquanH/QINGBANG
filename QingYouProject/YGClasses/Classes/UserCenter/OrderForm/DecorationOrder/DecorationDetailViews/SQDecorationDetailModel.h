//
//  SQDecorationDetailModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  订单详情模型

#import <Foundation/Foundation.h>

@interface SQDecorationDetailModel : NSObject

/** 1:待付款 2:已关闭 3:受理中 4:装修中,待付款 5:已完成 */
@property (nonatomic, assign) NSInteger orderState;

@property (nonatomic, copy  ) NSString *orderTitle;

/** 针对订单状态4的阶段1状态，其他订单状态无效 1:待付款,补登 2:已支付 3:补登审核 默认1 */
@property (nonatomic, assign) NSInteger stageOneState;
/** 针对订单状态4的阶段2状态，其他订单状态无效 1:待付款,补登 2:已支付 3:补登审核 默认1 */
@property (nonatomic, assign) NSInteger stageTwoState;
/** 针对订单状态4的阶段3状态，其他订单状态无效 1:待付款,补登 2:已支付 3:补登审核 默认1 */
@property (nonatomic, assign) NSInteger stageThreeState;


@end
