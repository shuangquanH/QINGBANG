//
//  OrderListModel.h
//  QingYouProject
//
//  Created by zhaoao on 2017/11/2.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListModel : NSObject

@property(nonatomic,strong)NSString *addressPhone;
@property(nonatomic,strong)NSString *orderID;
@property(nonatomic,strong)NSString *adsName;//广告名称
@property(nonatomic,strong)NSString *remarks;
@property(nonatomic,strong)NSString *endDate;//结束审核时间
@property(nonatomic,strong)NSString *number; //订单编号
@property(nonatomic,strong)NSString *beginDate;//开始审核时间
@property(nonatomic,strong)NSString *createDate;
@property(nonatomic,strong)NSString *companyName;
@property(nonatomic,strong)NSString *addressName;

@end
