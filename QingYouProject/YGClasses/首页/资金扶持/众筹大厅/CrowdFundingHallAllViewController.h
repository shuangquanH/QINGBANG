//
//  CrowdFundingHallAllViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "CrowdFundingAddProjectChooseTypeModel.h"

@interface CrowdFundingHallAllViewController : RootViewController
@property (nonatomic, strong) CrowdFundingAddProjectChooseTypeModel            *model;
- (void)reloadDataWithState:(NSString *)stateString;
@end
