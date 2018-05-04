//
//  ApplySetupViewController.h
//  QingYouProject
//
//  Created by zhaoao on 2017/11/15.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol ApplySetupViewControllerDelegate <NSObject>

-(void)passSelectArray:(NSArray *)selectArray andSelectTimeString:(NSString *)timeString;

@end

@interface ApplySetupViewController : RootViewController

@property(nonatomic,strong) id <ApplySetupViewControllerDelegate> delegate;
@property(nonatomic,strong)NSString *endTimeString;//活动结束时间
@property(nonatomic,strong)NSString *selectEndTimeString;//报名结束时间
@property(nonatomic,strong)NSMutableArray *selectArray;//报名选项数组


@end
