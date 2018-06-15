//
//  SQDecorationDetailModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  订单详情模型

#import <Foundation/Foundation.h>

#import "ManageMailPostModel.h"
#import "WKDecorationSUKModel.h"
#import "WKDecorationOrderModel.h"


@interface WKDecorationOrderDetailModel: NSObject

@property (nonatomic, copy  ) NSString *ID;

@property (nonatomic, copy  ) NSString *orderNum;

@property (nonatomic, copy  ) NSString *deposit;

@property (nonatomic, copy  ) NSString *typeId;

@property (nonatomic, copy  ) NSString *createDate;

@property (nonatomic, copy  ) NSString *updateBy;

@property (nonatomic, copy  ) NSString *addressId;

@property (nonatomic, copy  ) NSString *price;

@property (nonatomic, copy  ) NSString *createTime;

@property (nonatomic, assign) BOOL     deleted;

@property (nonatomic, copy  ) NSString *memberId;

@property (nonatomic, copy  ) NSString *updateDate;

@property (nonatomic, copy  ) NSString *remarks;

@property (nonatomic, copy  ) NSString *createBy;
/** 1:待付款 2:已关闭 3:受理中 4:装修中,待付款 5:已完成 */
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy  ) NSString *orderTitle;

@property (nonatomic, strong) WKDecorationSUKModel *skuDetails;

@property (nonatomic, strong) WKDecorationOrderModel *orderDetails;

@property (nonatomic, strong) ManageMailPostModel *address_info;


/** 是否可退款 */
@property (nonatomic, assign) BOOL canRefund;
/** 是否退款中 */
@property (nonatomic, assign) BOOL isInRefund;
/** 装修产品属性 */
@property (nonatomic, strong) NSArray<WKDecorationPropertyModel *> *decorateProperty_list;
/** 产品名称 */
@property (nonatomic, copy  ) NSString *decorateName;
/** 产品图片 */
@property (nonatomic, copy  ) NSString *decorate_icon;
/*  预估价  **/
@property (nonatomic, copy  ) NSString *estimate;

@property (nonatomic, copy  ) NSString *payTime;

@property (nonatomic, copy  ) NSString *finishTime;

@property (nonatomic, copy  ) NSString *contractImages;
//报价单下载地址
@property (nonatomic, copy  ) NSString *quotationUrl;
//是否有申请过发票
@property (nonatomic, assign) BOOL isInRepairApply;

@property (nonatomic, strong) NSArray<WKDecorationStageModel *> *stage_list;
//商品描述
@property (nonatomic, strong) NSAttributedString *decorationDescAttributeString;



@end
