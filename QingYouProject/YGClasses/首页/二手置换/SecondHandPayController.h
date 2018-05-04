//
//  SecondHandPayController.h
//  QingYouProject
//
//  Created by zhaoao on 2017/12/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@interface SecondHandPayController : RootViewController

@property(nonatomic,strong)NSString *payType;//1 青币换    2 以钱换

@property(nonatomic,strong)NSString *idString;//商品id

@property(nonatomic,strong)NSString *orderNumberString;//订单id

@property(nonatomic,strong)NSString *replaceIdString;//互动id

@end
