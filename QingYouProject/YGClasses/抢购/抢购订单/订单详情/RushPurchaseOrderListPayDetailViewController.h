//
//  RushPurchaseOrderListViewController.h
//  QingYouProject
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol RushPurchaseOrderListPayDetailViewControllerDelegate <NSObject>//协议
- (void)RushPurchaseOrderListPayDetailViewControllerReloadTabelViewWithRow:(NSInteger)row;//协议方法

@end
@interface RushPurchaseOrderListPayDetailViewController : RootViewController
@property (nonatomic, strong) NSString        *falshsaleOrderId;
@property (nonatomic, assign) id<RushPurchaseOrderListPayDetailViewControllerDelegate>delegate;

@end
