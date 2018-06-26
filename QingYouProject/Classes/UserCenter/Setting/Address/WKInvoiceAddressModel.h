//
//  WKInvoiceAddressModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKInvoiceAddressModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *provName;
@property (nonatomic, strong) NSString *ID;
/** 地址详情 */
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, assign) BOOL isdef;
@property (nonatomic, assign) long long cityId;

@end
