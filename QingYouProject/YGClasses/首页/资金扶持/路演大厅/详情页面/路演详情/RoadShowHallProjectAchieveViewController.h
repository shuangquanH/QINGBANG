//
//  FundSupportProjectAchieveViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol RoadShowHallProjectAchieveViewControllerDelegate <NSObject>

- (void)scrollViewDidScrollWithHeight:(CGFloat)offset;

@end
@interface RoadShowHallProjectAchieveViewController : RootViewController
@property (nonatomic, assign) CGRect            controllerFrame;
@property (nonatomic, assign) id<RoadShowHallProjectAchieveViewControllerDelegate>roadShowHallProjectAchieveViewControllerDelegate;
@property (nonatomic, copy) NSString            *content;

@end
