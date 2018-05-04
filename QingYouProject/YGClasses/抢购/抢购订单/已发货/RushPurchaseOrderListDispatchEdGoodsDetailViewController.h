//
//  RushPurchaseOrderListDispatchEdGoodsDetailViewController.h
//  QingYouProject
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol RushPurchaseOrderListDispatchEdGoodsDetailViewControllerDelegate <NSObject>//协议
- (void)RushPurchaseOrderListDispatchEdGoodsDetailViewControllerReloadTabelViewWithRow:(NSInteger)row;//协议方法

@end
@interface RushPurchaseOrderListDispatchEdGoodsDetailViewController : RootViewController
@property (nonatomic,assign) NSInteger status;
@property (nonatomic, strong) NSString *OrderID;
@property (nonatomic, assign) id<RushPurchaseOrderListDispatchEdGoodsDetailViewControllerDelegate>delegate;

@end
