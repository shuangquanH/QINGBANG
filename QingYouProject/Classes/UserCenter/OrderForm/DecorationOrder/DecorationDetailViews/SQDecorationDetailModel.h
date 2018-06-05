//
//  SQDecorationDetailModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  订单详情模型

#import <Foundation/Foundation.h>
#import "ManageMailPostModel.h"

@interface SQDecorationDetailModel : NSObject

@property (nonatomic, copy  ) NSString *orderNum;
/** 1:待付款 2:已关闭 3:受理中 4:装修中,待付款 5:已完成 */
@property (nonatomic, assign) NSInteger orderState;

@property (nonatomic, copy  ) NSString *orderTitle;
/** 是否可退款 */
@property (nonatomic, assign) BOOL canRefund;
/** 是否退款中 */
@property (nonatomic, assign) BOOL isInRefund;
/** 装修产品描述 */
@property (nonatomic, copy  ) NSString *decorateDescribe;
/** 产品名称 */
@property (nonatomic, copy  ) NSString *decorateName;
/** 产品图片 */
@property (nonatomic, copy  ) NSString *decorate_icon;
/** 订金金额 */
@property (nonatomic, copy  ) NSString *depositPrice;
/** 订金状态 1:已付款 2:待付款 */
@property (nonatomic, copy  ) NSString *depositState;
/*  预估价  **/
@property (nonatomic, copy  ) NSString *estimate;
/** 阶段1价格 */
@property (nonatomic, copy  ) NSString *stageOnePrice;
/** 阶段2价格 */
@property (nonatomic, copy  ) NSString *stageThreePrice;
/** 阶段3价格 */
@property (nonatomic, copy  ) NSString *stageTwoPrice;
/** 针对订单状态4的阶段1状态，其他订单状态无效 1:待付款,补登 2:已支付 3:补登审核 默认1 */
@property (nonatomic, assign) NSInteger stageOneState;
/** 针对订单状态4的阶段2状态，其他订单状态无效 1:待付款,补登 2:已支付 3:补登审核 默认1 */
@property (nonatomic, assign) NSInteger stageTwoState;
/** 针对订单状态4的阶段3状态，其他订单状态无效 1:待付款,补登 2:已支付 3:补登审核 默认1 */
@property (nonatomic, assign) NSInteger stageThreeState;

@property (nonatomic, copy  ) NSString *payTime;

@property (nonatomic, copy  ) NSString *finishTime;

@property (nonatomic, copy  ) NSString *createTime;

@end

@interface WKDecorationOrderDetailModel: NSObject

@property (nonatomic, strong) SQDecorationDetailModel *order_info;

@property (nonatomic, strong) ManageMailPostModel *address_info;

@end
