//
//  PayConfirmViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "BillDetailModel.h"

@interface PayConfirmViewController : RootViewController

@property (nonatomic, strong) BillDetailModel            *model;

@property (nonatomic, copy) NSString            *type;

@property (nonatomic, copy) NSString            *isIssueInvoice;

@end
