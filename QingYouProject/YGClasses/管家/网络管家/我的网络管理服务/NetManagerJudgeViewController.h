//
//  NetManagerJudgeViewController.h
//  QingYouProject
//
//  Created by apple on 2017/11/10.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
@protocol NetManagerJudgeViewControllerDelegate <NSObject>//协议
- (void)netManagerJudgeViewControllerJudgeBtnWithRow:(int) row;//协议方法

@end

@interface NetManagerJudgeViewController : RootViewController
@property (nonatomic, strong) NSString * serviceID;
@property (nonatomic, strong) NSString * orderID;

@property (nonatomic, assign) int row;
@property (nonatomic, assign) id <NetManagerJudgeViewControllerDelegate>delegate;
@end
