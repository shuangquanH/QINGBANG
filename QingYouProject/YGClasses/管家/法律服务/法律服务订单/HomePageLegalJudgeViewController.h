//
//  HomePageLegalJudgeViewController.h
//  QingYouProject
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol HomePageLegalJudgeViewControllerDelegate <NSObject>//协议
- (void)netManagerJudgeViewControllerJudgeBtnWithRow:(int) row;//协议方法

@end

@interface HomePageLegalJudgeViewController : RootViewController
@property (nonatomic, strong) NSString * serviceID;
@property (nonatomic, strong) NSString * orderID;

@property (nonatomic, assign) int row;
@property (nonatomic, assign) id <HomePageLegalJudgeViewControllerDelegate>delegate;
@end
