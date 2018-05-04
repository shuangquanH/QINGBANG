//
//  SubscribeDetailViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/11/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "CrowdFundingHallModel.h"

@interface SubscribeDetailViewController : RootViewController
@property (nonatomic, copy) NSString             *projectID;
@property (nonatomic, assign) int               statusType; //1 代付款 2我的项目续期投资
@end
