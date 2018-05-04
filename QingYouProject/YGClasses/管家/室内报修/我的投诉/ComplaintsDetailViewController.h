//
//  ComplaintsDetailViewController.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
@protocol ComplaintsDetailViewControllerDelegate <NSObject>//协议
- (void)ComplaintsDetailViewControllerDelegateDeletewithrow:(int)row;//协议方法
@end

@interface ComplaintsDetailViewController : RootViewController
@property (nonatomic,strong) NSString * complainId;
@property (nonatomic, strong) NSString * isPush;
@property (nonatomic, assign) int  row;

@property (nonatomic, assign) id <ComplaintsDetailViewControllerDelegate>delegate;
@end
