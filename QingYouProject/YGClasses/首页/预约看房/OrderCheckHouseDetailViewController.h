//
//  OrderCheckHouseDetailViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/11/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@interface OrderCheckHouseDetailViewController : RootViewController
@property (nonatomic, copy) NSString        *orderId;
@property (nonatomic, copy) NSString        *sourceId;
@property (nonatomic, assign) BOOL        cancle;

@end
