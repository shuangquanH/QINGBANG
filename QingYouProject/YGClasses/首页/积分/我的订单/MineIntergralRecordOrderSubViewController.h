//
//  MineIntergralRecordOrderSubViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@interface MineIntergralRecordOrderSubViewController : RootViewController
@property (nonatomic, assign) CGRect            controllerFrame;
@property (nonatomic, copy) NSString            *controllerType;

@property(nonatomic,strong)UITableView *tableView;
@end
