//
//  HomePageLegalServiceIntroduceViewController.h
//  QingYouProject
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "RootViewController.h"


@protocol HomePageLegalServiceIntroduceViewControllerDelegate <NSObject>

- (void)scrollViewDidScrollWithHeight:(CGFloat)offset;

@end
@interface HomePageLegalServiceIntroduceViewController : RootViewController
@property (nonatomic, assign) CGRect            controllerFrame;
@property (nonatomic, strong) NSString *serviceID;

@property (nonatomic, assign) id<HomePageLegalServiceIntroduceViewControllerDelegate>netIntroduceViewControllerDelegate;
@end
