//
//  SubscribeSumOfMoneyViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "SubscribeSumOfMoneyModel.h"

@protocol SubscribeSumOfMoneyViewControllerViewControllerDelegate <NSObject>

- (void)takeTypeValueBackWithModels:(NSArray *)modelArray withRights:(NSString *)rights;

@end
@interface SubscribeSumOfMoneyViewController : RootViewController

@property (nonatomic, assign) id<SubscribeSumOfMoneyViewControllerViewControllerDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end
