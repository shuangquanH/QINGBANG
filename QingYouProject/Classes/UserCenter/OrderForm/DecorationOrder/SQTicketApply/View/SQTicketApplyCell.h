//
//  SQTicketApplyCell.h
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKInvoiceModel;

@interface SQTicketApplyCell : UITableViewCell

- (void)configInvoiceInfo:(WKInvoiceModel *)invoiceInfo;

@end
