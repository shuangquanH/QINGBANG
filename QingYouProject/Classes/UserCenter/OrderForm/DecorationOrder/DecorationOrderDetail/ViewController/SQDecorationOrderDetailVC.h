//
//  SQDecorationOrderDetailVC.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/18.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  订单详情

#import "RootViewController.h"

@class WKDecorationOrderDetailModel;

@interface SQDecorationOrderDetailVC : RootViewController

@property (nonatomic, strong) WKDecorationOrderDetailModel *orderListInfo;

@property (nonatomic, copy  ) void (^ orderRefreshBlock)(WKDecorationOrderDetailModel *orderInfo);

@end
