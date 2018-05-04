//
//  RoadShowHallAllViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "CrowdFundingAddProjectChooseTypeModel.h"

@interface RoadShowHallAllViewController : RootViewController
@property (nonatomic, strong) CrowdFundingAddProjectChooseTypeModel            *model;
@property (nonatomic, strong) UITableView *tableView;
@end
