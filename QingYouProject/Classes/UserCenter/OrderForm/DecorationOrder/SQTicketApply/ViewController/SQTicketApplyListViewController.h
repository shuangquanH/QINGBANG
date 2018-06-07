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

@property (nonatomic, copy) void (^ selectInvoiceBlock)(WKInvoiceModel *invoiceInfo);

- (instancetype)initWithIsTicketApplyManager:(BOOL)isTicketApplyManager;

@end
