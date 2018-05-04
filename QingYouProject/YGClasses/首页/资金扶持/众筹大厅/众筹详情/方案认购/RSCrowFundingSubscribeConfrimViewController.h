//
//  RSCrowFundingSubscribeConfrimViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "RSCorwFundingSubscribeModel.h"

@interface RSCrowFundingSubscribeConfrimViewController : RootViewController
@property (nonatomic, strong) RSCorwFundingSubscribeModel *model;
@property (nonatomic, strong) NSString             *projectID;
@property (nonatomic, strong) NSString             *coolTimeDescription;

@end
