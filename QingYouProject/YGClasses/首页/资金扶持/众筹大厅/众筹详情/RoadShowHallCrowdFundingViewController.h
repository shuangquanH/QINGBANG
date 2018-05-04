//
//  RoadShowHallCrowdFundingViewController.h
//  QingYouProject
//
//  Created by 王丹 on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "CrowdFundingHallModel.h"

@interface RoadShowHallCrowdFundingViewController : RootViewController
@property (nonatomic, strong) NSString             *projectID;
@property (nonatomic, strong) NSString             *pageType;
@property (nonatomic, assign) BOOL             IsSubscribed;

@end
