//
//  AllianceCircleActivityViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol AllianceCircleActivityViewControllerDelegate <NSObject>

- (void)scrollViewDidScrollWithHeight:(CGFloat)offset;

@end

@interface AllianceCircleActivityViewController : RootViewController
@property (nonatomic, assign) CGRect            controllerFrame;
@property (nonatomic, assign) id<AllianceCircleActivityViewControllerDelegate>allianceCircleActivityViewControllerDelegate;
@property (nonatomic, copy) NSString            *allianceID;

@end
