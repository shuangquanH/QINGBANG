//
//  WaitPaidViewController.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
@protocol WaitPaidViewControllerDelegate <NSObject>//协议
- (void)waitPaidViewControllerWithCancalRow:(int)row;//协议方法
@end

@interface WaitPaidViewController : RootViewController
@property (nonatomic, strong) NSString *OrderID;
@property (nonatomic, assign) int row;
@property (nonatomic, assign) id <WaitPaidViewControllerDelegate>delegate;
@end
