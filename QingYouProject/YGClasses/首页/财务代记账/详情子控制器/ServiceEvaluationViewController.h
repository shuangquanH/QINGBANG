//
//  ServiceEvaluationViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol ServiceEvaluationViewControllerDelegate <NSObject>

- (void)scrollViewDidScrollWithHeight:(CGFloat)offset;

@end
@interface ServiceEvaluationViewController : RootViewController
@property (nonatomic, assign) CGRect            controllerFrame;
@property (nonatomic, copy) NSString        *superVCType; //上级页面是财务代记账还是网路管家
@property (nonatomic, copy) NSString           *serviceID;

@property (nonatomic, assign) id<ServiceEvaluationViewControllerDelegate>serviceEvaluationViewControllerDelegate;

@end
