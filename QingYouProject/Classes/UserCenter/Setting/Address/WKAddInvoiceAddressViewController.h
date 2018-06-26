//
//  WKAddInvoiceAddressViewController.h
//  QingYouProject
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "WKInvoiceAddressModel.h"

@interface WKAddInvoiceAddressViewController : RootViewController

@property (nonatomic, strong) WKInvoiceAddressModel *editAddress;

//地址回调，当添加地址时回调参数为空
@property (nonatomic, copy  ) void (^ addressHandler)(WKInvoiceAddressModel *model);

@end
