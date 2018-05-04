//
//  MyInvestDetailViewController.h
//  QingYouProject
//
//  Created by 王丹 on 2017/11/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "CrowdFundingHallModel.h"

@interface MyInvestDetailViewController : RootViewController
@property (nonatomic, copy) NSString             *projectID;
@property (nonatomic, assign) int               statusType;

@end
