//
//  SQDecorationDetailModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  订单列表模型

#import <Foundation/Foundation.h>

//商品信息
#import "WKDecorationSUKModel.h"

/*********** 阶段模型 *************/
@interface WKDecorationStageModel : NSObject

@property (nonatomic, copy  ) NSString *ID;
/** 阶段名称 */
@property (nonatomic, copy  ) NSString *name;
/** 阶段价格 */
@property (nonatomic, copy  ) NSString *amount;
/** 阶段状态 1:待付款,补登 2:补登审核 3:已支付 4:已关闭 默认0:未激活 */
@property (nonatomic, assign) NSInteger status;
/** 支付时间 */
@property (nonatomic, copy  ) NSString *payDate;

@end

@interface WKDecorationOrderListModel: NSObject
/** 订单主键 */
@property (nonatomic, copy  ) NSString *ID;
/** 订单号 */
@property (nonatomic, copy  ) NSString *orderNum;
/** 订单创建时间 */
@property (nonatomic, copy  ) NSString *createDate;
/** 商品名称 */
@property (nonatomic, copy  ) NSString *productName;
/** 1:待付款 2:已关闭 3:受理中 4:装修中,待付款 5:已完成 */
@property (nonatomic, assign) NSInteger status;
/** 商品信息 */
@property (nonatomic, strong) WKDecorationSUKModel *skuDetails;
/** 订单阶段列表 */
@property (nonatomic, strong) NSArray<WKDecorationStageModel *> *paymentList;

#pragma mark - 订单详情时后台返回的额外参数
/** 是否有申请过发票 */
@property (nonatomic, assign) BOOL invoice;
/** 是否退款中 */
@property (nonatomic, assign) BOOL refund;
/** 合同图片 */
@property (nonatomic, copy  ) NSString *contractImgUrl;

#pragma mark - 本地添加的辅助参数
/** 主标题 */
@property (nonatomic, copy  ) NSString *orderTitle;
/** 当前活跃的订单阶段 */
@property (nonatomic, strong) WKDecorationStageModel *activityStageInfo;
/** 商品名称 */
@property (nonatomic, strong) NSAttributedString *skuProductNameAttributeString;


@property (nonatomic, copy  ) NSString *payTime;

@property (nonatomic, copy  ) NSString *finishTime;

@end
