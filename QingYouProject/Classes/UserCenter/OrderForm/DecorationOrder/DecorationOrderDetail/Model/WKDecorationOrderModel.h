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
/** 阶段名称 */
@property (nonatomic, copy  ) NSString *stageName;
/** 阶段价格 */
@property (nonatomic, copy  ) NSString *stagePrice;
/** 阶段状态 1:待付款,补登 2:已支付 3:补登审核 4:已关闭 默认1 */
@property (nonatomic, assign) NSInteger stageState;

@property (nonatomic, copy  ) NSString *stageId;
/** 是否被激活 */
@property (nonatomic, assign) BOOL isActivity;

@end

/*********** 订单信息模型 *************/
@interface WKDecorationOrderModel : NSObject

@property (nonatomic, copy  ) NSString *ID;

@property (nonatomic, copy  ) NSString *orderNum;

@property (nonatomic, copy  ) NSString *updateBy;

@property (nonatomic, copy  ) NSString *count;

@property (nonatomic, copy  ) NSString *createDate;

@property (nonatomic, copy  ) NSString *addressId;

@property (nonatomic, copy  ) NSString *price;

@property (nonatomic, copy  ) NSString *skuId;

@property (nonatomic, copy  ) NSString *updateDate;

@property (nonatomic, assign) BOOL     deleted;

@property (nonatomic, copy  ) NSString *remarks;

@property (nonatomic, copy  ) NSString *status;

@property (nonatomic, copy  ) NSString *createBy;

@end

