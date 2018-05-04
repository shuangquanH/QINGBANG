//
//  RushPurchaseOrderRefundViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/12/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "RushPurchaseOrderListModel.h"


@protocol RushPurchaseOrderRefundViewControllerDelegate <NSObject>//协议
- (void)RushPurchaseOrderRefundViewControllerWithCommintRow:(int)row;//协议方法
@end

@interface RushPurchaseOrderRefundViewController : RootViewController
@property (nonatomic, strong) RushPurchaseOrderListModel *model;
@property (nonatomic, assign) id <RushPurchaseOrderRefundViewControllerDelegate>delegate;
@property (nonatomic, assign) int row;
@property (nonatomic, strong) NSString *OrderID;
@property (nonatomic, strong) NSString * isPush;
@end
