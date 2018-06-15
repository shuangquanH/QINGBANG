//
//  OfficePurchaseRefundViewController.h
//  QingYouProject
//
//  Created by apple on 2017/11/16.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
@class AllOfficePurchaseDetailModel;

@protocol OfficePurchaseRefundViewControllerDelegate <NSObject>//协议
- (void)officePurchaseRefundViewControllerWithCommintRow:(int)row;//协议方法
@end

@interface OfficePurchaseRefundViewController : RootViewController
@property (nonatomic, strong) AllOfficePurchaseDetailModel *model;
@property (nonatomic, assign) id <OfficePurchaseRefundViewControllerDelegate>delegate;
@property (nonatomic, assign) int row;
@property (nonatomic, strong) NSString * isPush;

@end
