//
//  SQTicketApplyListViewController.h
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  发票抬头列表/发票抬头管理列表

#import "RootViewController.h"

@class WKInvoiceModel;

@interface SQTicketApplyListViewController : RootViewController
//选择发票回调
@property (nonatomic, copy) void (^ selectInvoiceBlock)(WKInvoiceModel *invoiceInfo);
//发票管理发生数据刷新时的回调
@property (nonatomic, copy) void (^ managerRefresh)(NSArray<WKInvoiceModel *> *invoiceList);

@property (nonatomic, copy  ) void (^ invoiceListReback)(NSArray<WKInvoiceModel *> *invoiceList);


@property (nonatomic, copy) NSString *defaultInvoiceId;

- (instancetype)initWithIsTicketApplyManager:(BOOL)isTicketApplyManager;

@end
