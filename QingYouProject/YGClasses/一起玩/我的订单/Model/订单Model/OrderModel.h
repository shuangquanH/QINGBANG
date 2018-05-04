//
//  OrderModel.h
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderGoodsModel.h"

@interface OrderModel : NSObject
@property (nonatomic, copy) NSString * activityBeginTime;//图片
@property (nonatomic, copy) NSString * price;//图片
@property (nonatomic, copy) NSString * orderID;//id
@property (nonatomic, copy) NSString * count;//数量
@property (nonatomic, copy) NSString * activityEndTime;//图片
@property (nonatomic, copy) NSString * activityImg;//图片
@property (nonatomic, copy) NSString * type;//状态 (0待付款,1待参与,已完成,退款)
@property (nonatomic, copy) NSString * activityAddress;
@property (nonatomic, copy) NSString * cost;//总价
@property (nonatomic, copy) NSString * activityName;//标题
@property (nonatomic, copy) NSString * allianceName;
@property (nonatomic, copy) NSString * allianceImg;
@property (nonatomic, copy) NSString * alliancePhone;


//@property (nonatomic, strong) NSMutableArray<OrderGoodsModel *> * orderGoodsList;//商品的列表

@property (nonatomic, copy) NSString * number;//
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * userPhone;//总价
@property (nonatomic, copy) NSString * createDate;//标题
@end
