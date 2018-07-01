//
//  WKDecorationOrderDetailModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>
//地址信息
#import "WKInvoiceAddressModel.h"
//订单信息
#import "WKDecorationOrderListModel.h"

@interface WKDecorationOrderDetailModel : NSObject

@property (nonatomic, strong) WKDecorationOrderListModel *orderInfo;

@property (nonatomic, strong) WKInvoiceAddressModel *addressInfo;

@end
