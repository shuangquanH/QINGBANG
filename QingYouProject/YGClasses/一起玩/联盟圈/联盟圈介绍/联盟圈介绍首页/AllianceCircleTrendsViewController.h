//
//  AllianceCircleTrendsViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol AllianceCircleTrendsViewControllerDelegate <NSObject>

- (void)scrollViewDidScrollWithHeight:(CGFloat)offset;

@end
@interface AllianceCircleTrendsViewController : RootViewController
@property (nonatomic, assign) CGRect            controllerFrame;
@property (nonatomic, assign) id<AllianceCircleTrendsViewControllerDelegate>allianceCircleTrendsViewControllerDelegate;
@property (nonatomic, copy) NSString            *allianceID;
@property (nonatomic, copy) NSString            *isMember;

@end
