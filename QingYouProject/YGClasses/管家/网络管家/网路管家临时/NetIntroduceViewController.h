//
//  NetIntroduceViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/9/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol netIntroduceViewControllerDelegate <NSObject>

- (void)scrollViewDidScrollWithHeight:(CGFloat)offset;

@end
@interface NetIntroduceViewController : RootViewController
@property (nonatomic, assign) CGRect            controllerFrame;
@property (nonatomic, strong) NSString *serviceID;

@property (nonatomic, assign) id<netIntroduceViewControllerDelegate>netIntroduceViewControllerDelegate;
@end
