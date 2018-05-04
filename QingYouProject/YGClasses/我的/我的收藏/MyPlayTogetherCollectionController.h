//
//  MyPlayTogetherCollectionController.h
//  QingYouProject
//
//  Created by zhaoao on 2017/12/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@interface MyPlayTogetherCollectionController : RootViewController

@property(nonatomic,strong)NSString *pageType;//0:活动 1:联盟

@property (nonatomic, assign) CGRect            controllerFrame;

@property(nonatomic,strong)UITableView *tableView;

@end
