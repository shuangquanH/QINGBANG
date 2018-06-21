//
//  WKDecorationOrderModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/15.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  订单信息

#import <Foundation/Foundation.h>

/*********** 阶段模型 *************/
@interface WKDecorationStageModel : NSObject

@property (nonatomic, copy  ) NSString *ID;
/** 阶段名称 */
@property (nonatomic, copy  ) NSString *name;
/** 阶段价格 */
@property (nonatomic, copy  ) NSString *amount;
/** 阶段状态 1:待付款,补登 2:补登审核 3:已支付 4:已关闭 默认0:未激活 */
@property (nonatomic, assign) NSInteger status;

@end

/*********** 订单信息模型 *************/
@interface WKDecorationOrderModel : NSObject

@property (nonatomic, copy  ) NSString *ID;

@property (nonatomic, copy  ) NSString *orderNum;

@property (nonatomic, copy  ) NSString *count;

@property (nonatomic, copy  ) NSString *createDate;

@property (nonatomic, copy  ) NSString *addressId;

@property (nonatomic, copy  ) NSString *price;

@property (nonatomic, copy  ) NSString *skuId;

@property (nonatomic, copy  ) NSString *updateDate;

@property (nonatomic, assign) BOOL     deleted;

@property (nonatomic, copy  ) NSString *remarks;
/** 1:待付款 2:已关闭 3:受理中 4:装修中,待付款 5:已完成 */
@property (nonatomic, copy  ) NSString *status;

@end

