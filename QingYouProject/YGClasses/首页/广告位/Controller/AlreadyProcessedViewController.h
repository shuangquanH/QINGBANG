//
//  AlreadyProcessedViewController.h
//  QingYouProject
//
//  Created by zhaoao on 2017/9/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSUInteger, AlreadyProcessedType) {
    AlreadyProcessedTypeWait = 0,
    AlreadyProcessedTypeIng = 1,
    AlreadyProcessedTypeEd = 2,
};

@interface AlreadyProcessedViewController : RootViewController

@property (nonatomic, assign) AlreadyProcessedType pageType;

@property(nonatomic,strong)NSString *typeString;//订单状态（1待处理，2处理中，3已处理）

@end
