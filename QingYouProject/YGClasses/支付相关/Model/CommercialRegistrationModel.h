//
// Created by zhangkaifeng on 2017/9/29.
// Copyright (c) 2017 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommercialRegistrationModel : NSObject

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderTitle;
@property (nonatomic, copy) NSString *orderDate;
@property (nonatomic, copy) NSString *orderName;
@property (nonatomic, copy) NSString *orderPhone;
@property (nonatomic, copy) NSString *orderKind;
@property (nonatomic, copy) NSString *orderPay;
@property (nonatomic, copy) NSString *orderProcessDate;

@end