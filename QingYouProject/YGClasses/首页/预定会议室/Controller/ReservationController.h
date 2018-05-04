//
//  ReservationController.h
//  QingYouProject
//
//  Created by zhaoao on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@interface ReservationController : RootViewController

@property(nonatomic,strong)NSString *unitPriceString;//价格/小时
@property(nonatomic,copy)NSString *dateString; //选择的日期
@property(nonatomic,strong)NSString *idString;

@end
