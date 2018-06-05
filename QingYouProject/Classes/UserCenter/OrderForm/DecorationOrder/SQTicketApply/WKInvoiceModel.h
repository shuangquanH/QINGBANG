//
//  WKInvoiceModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKInvoiceModel : NSObject
/** 是否可退款 */
@property (nonatomic, assign) BOOL isDefault;
/** 是否退款中 */
@property (nonatomic, assign) BOOL is_personal;
/** 装修产品描述 */
@property (nonatomic, copy  ) NSString *companyAddress;
/** 产品名称 */
@property (nonatomic, copy  ) NSString *companyBank;
/** 产品图片 */
@property (nonatomic, copy  ) NSString *companyBankAccount;
/** 订金金额 */
@property (nonatomic, copy  ) NSString *companyPhone;
/** 订金状态 1:已付款 2:待付款 */
@property (nonatomic, copy  ) NSString *invoiceName;
/*  预估价  **/
@property (nonatomic, copy  ) NSString *invoiceDutyNum;
/** 阶段1价格 */
@property (nonatomic, copy  ) NSString *invoice_id;

@end
