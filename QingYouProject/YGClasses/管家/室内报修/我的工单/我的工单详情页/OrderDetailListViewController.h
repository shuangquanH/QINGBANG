//
//  OrderDetailListViewController.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol OrderDetailListViewControllerDelegate <NSObject>//协议
- (void)orderDetailListViewControllerDealedWithRow:(int)row;//协议方法
@end

@interface OrderDetailListViewController : RootViewController
@property (nonatomic, strong) NSString *IndoorId;
@property (nonatomic, assign) int state;//状态值
@property (nonatomic, strong) NSString *workNumber;
@property (nonatomic, strong) NSString *isPush;

@property (nonatomic, strong) NSString *noDeal;//未处理
@property (nonatomic, assign) int row;//未处理

@property (nonatomic, assign) id <OrderDetailListViewControllerDelegate>delegate;

@end
