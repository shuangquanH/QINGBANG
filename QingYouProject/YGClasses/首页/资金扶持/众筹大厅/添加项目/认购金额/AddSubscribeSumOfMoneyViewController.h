//
//  AddSubscribeSumOfMoneyViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "SubscribeSumOfMoneyModel.h"

@protocol AddSubscribeSumOfMoneyViewControllerDelegate <NSObject>

- (void)takeTypeValueBackWithModel:(SubscribeSumOfMoneyModel *)model;

@end
@interface AddSubscribeSumOfMoneyViewController : RootViewController

@property (nonatomic, assign) id<AddSubscribeSumOfMoneyViewControllerDelegate>delegate;

@end
