//
//  RushPurchaseOrderListWaitToGoodsDetailViewController.h
//  QingYouProject
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol RushPurchaseOrderListWaitToGoodsDetailViewControllerDelegate <NSObject>//协议
- (void)RushPurchaseOrderListWaitToGoodsDetailViewControllerReloadTabelViewWithRow:(NSInteger)row;//协议方法

@end
@interface RushPurchaseOrderListWaitToGoodsDetailViewController : RootViewController
@property (nonatomic,assign) NSInteger status;
@property (nonatomic, strong) NSString *OrderID;
@property (nonatomic, assign) id<RushPurchaseOrderListWaitToGoodsDetailViewControllerDelegate>delegate;

@end
