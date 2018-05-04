//
//  IssueInvoiceTableViewCell.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceInfoManagerModel.h"

@protocol IssueInvoiceTableViewCellDelegate <NSObject>

//将textfield带回
- (void)IssueInvoiceTableViewCellTakeTextfield:(UITextField *)textfield;
//选择的发票类型
- (void)chooseTypeWithIndex:(int)index;

@end
@interface IssueInvoiceTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, strong) InvoiceInfoManagerModel            *model;
@property (nonatomic, assign) id<IssueInvoiceTableViewCellDelegate>delegate;
- (void)setModel:(InvoiceInfoManagerModel *)model withIsChange:(BOOL)isChange;
@end
