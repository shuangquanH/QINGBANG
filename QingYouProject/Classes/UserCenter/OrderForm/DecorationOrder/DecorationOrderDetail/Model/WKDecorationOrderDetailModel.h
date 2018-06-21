//
//  SQDecorationDetailModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  订单详情模型

#import <Foundation/Foundation.h>
//地址信息
#import "WKDecorationAddressModel.h"
//商品信息
#import "WKDecorationSUKModel.h"
//订单列表信息
#import "WKDecorationOrderModel.h"

@interface WKDecorationOrderDetailModel: NSObject

@property (nonatomic, copy  ) NSString *ID;

@property (nonatomic, copy  ) NSString *orderNum;

@property (nonatomic, copy  ) NSString *createDate;

@property (nonatomic, copy  ) NSString *addressId;

@property (nonatomic, copy  ) NSString *deposit;

@property (nonatomic, copy  ) NSString *price;

@property (nonatomic, copy  ) NSString *createTime;

@property (nonatomic, copy  ) NSString *updateDate;

@property (nonatomic, copy  ) NSString *remarks;

/** 1:待付款 2:已关闭 3:受理中 4:装修中,待付款 5:已完成 */
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) WKDecorationSUKModel *skuDetails;

@property (nonatomic, strong) WKDecorationOrderModel *orderDetails;

@property (nonatomic, strong) WKDecorationAddressModel *addressInfo;

@property (nonatomic, strong) NSArray<WKDecorationStageModel *> *paymentList;

#pragma mark - 本地添加的辅助参数
@property (nonatomic, copy  ) NSString *orderTitle;

@property (nonatomic, strong) WKDecorationStageModel *activityStageInfo;



/** 是否可退款 */
@property (nonatomic, assign) BOOL canRefund;
/** 是否退款中 */
@property (nonatomic, assign) BOOL isInRefund;

@property (nonatomic, copy  ) NSString *payTime;

@property (nonatomic, copy  ) NSString *finishTime;

@property (nonatomic, copy  ) NSString *contractImages;
//报价单下载地址
@property (nonatomic, copy  ) NSString *quotationUrl;
//是否有申请过发票
@property (nonatomic, assign) BOOL isInRepairApply;


@end
