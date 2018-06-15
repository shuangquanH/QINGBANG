//
//  WKDecorationRepairViewController.h
//  QingYouProject
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  我要补登

#import "RootViewController.h"

@class WKDecorationOrderDetailModel;

@interface WKDecorationRepairViewController : RootViewController
//订单信息
@property (nonatomic, strong) WKDecorationOrderDetailModel *orderInfo;
//阶段索引
@property (nonatomic, assign) NSInteger stageIndex;
//补登成功回调
@property (nonatomic, copy  ) void (^ repairSuccess)(WKDecorationOrderDetailModel *orderInfo);

@end
