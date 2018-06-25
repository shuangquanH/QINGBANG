//
//  WKInvoiceAddressViewController.h
//  QingYouProject
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@class WKInvoiceAddressModel;

@interface WKInvoiceAddressViewController : RootViewController

@property (nonatomic, copy  ) void (^ addressSelecter)(WKInvoiceAddressModel *addressInfo);

@end
