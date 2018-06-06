//
//  WKInvoiceModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKInvoiceModel : NSObject
/** 是否默认 */
@property (nonatomic, assign) BOOL isDefault;
/** 是否个人 */
@property (nonatomic, assign) BOOL is_personal;
/** 企业地址 */
@property (nonatomic, copy  ) NSString *companyAddress;
/** 开户银行 */
@property (nonatomic, copy  ) NSString *companyBank;
/** 银行账户 */
@property (nonatomic, copy  ) NSString *companyBankAccount;
/** 电话号码 */
@property (nonatomic, copy  ) NSString *companyPhone;
/** 抬头名称 */
@property (nonatomic, copy  ) NSString *invoiceName;
/*  税号  **/
@property (nonatomic, copy  ) NSString *invoiceDutyNum;
/** 抬头id */
@property (nonatomic, copy  ) NSString *invoice_id;

@end
