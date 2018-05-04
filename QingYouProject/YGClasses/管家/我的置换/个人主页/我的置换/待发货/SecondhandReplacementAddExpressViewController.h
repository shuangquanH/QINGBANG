//
//  SecondhandReplacementAddExpressViewController.h
//  QingYouProject
//
//  Created by apple on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
@protocol SecondhandReplacementAddExpressViewControllerDelegate <NSObject>//协议
-(void)secondhandReplacementAddExpressViewControllerDelegateReturnReloadViewWithRow:(NSInteger )row;
@end
@interface SecondhandReplacementAddExpressViewController : RootViewController
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, assign) id <SecondhandReplacementAddExpressViewControllerDelegate>delegate;
@property (nonatomic, assign) NSInteger row;
@end
