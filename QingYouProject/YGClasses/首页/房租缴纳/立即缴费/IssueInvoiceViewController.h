//
//  IssueInvoiceViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "IssueInvoiceModel.h"

@protocol IssueInvoiceViewControllerDelegate <NSObject>

- (void)issueInvoiceViewControllerTakeNumber:(NSString *)number andTitle:(NSString *)title;

@end
@interface IssueInvoiceViewController : RootViewController
@property (nonatomic, assign) id<IssueInvoiceViewControllerDelegate>delegate;
@end
