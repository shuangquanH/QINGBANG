//
//  MeetingPayingViewController.h
//  QingYouProject
//
//  Created by zhaoao on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

//支付界面
#import "RootViewController.h"

@interface MeetingPayingViewController : RootViewController

@property(nonatomic,strong)NSDictionary *orderDic;
@property(nonatomic,strong)NSString *pointString;//青币
@property(nonatomic,strong)NSString *offPriceString;//青币
@property(nonatomic,strong)NSString *isOrderoffPay;//是从订单界面传过来的

@end
