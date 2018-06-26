//
//  WKDecorationRefundDetailViewController.h
//  QingYouProject
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@class WKDecorationOrderDetailModel;

@interface WKDecorationRefundDetailViewController : RootViewController

@property (nonatomic, strong) WKDecorationOrderDetailModel *orderDetailInfo;
//退款详情回调
@property (nonatomic, copy  ) void (^ refundReback)(void);

@end
