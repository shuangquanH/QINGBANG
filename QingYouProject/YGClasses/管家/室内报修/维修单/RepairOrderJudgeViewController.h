//
//  RepairOrderJudgeViewController.h
//  QingYouProject
//
//  Created by apple on 2017/11/9.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol RepairOrderJudgeViewControllerDelegate <NSObject>

- (void)judgeRow:(int )row;

@end

@interface RepairOrderJudgeViewController : RootViewController
@property (nonatomic, strong) NSString * workNumber;
@property (nonatomic, assign) int  row;

@property (nonatomic, assign) id <RepairOrderJudgeViewControllerDelegate>delegate;
@end

