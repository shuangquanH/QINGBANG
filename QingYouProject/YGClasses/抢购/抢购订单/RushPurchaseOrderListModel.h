//
//  RushPurchaseOrderListModel.h
//  QingYouProject
//
//  Created by 王丹 on 2017/12/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RushPurchaseOrderListModel : NSObject
@property (nonatomic, copy) NSString        *commoditySizeName;
@property (nonatomic, copy) NSString        *commodityImg;
@property (nonatomic, copy) NSString        *commodityNum;
@property (nonatomic, copy) NSString        *freight;//运费
@property (nonatomic, copy) NSString        *orderNum;
@property (nonatomic, copy) NSString        *unitPrice;
@property (nonatomic, copy) NSString        *commodityName;
@property (nonatomic, copy) NSString        *refundsType; //0 未进行退款 1 退款中 2 退款成功 3 退款失败

@property (nonatomic, copy) NSString        *type;//0 待支付 1 待发货 2 已发货 3 交易成功
@property (nonatomic, copy) NSString        *totalPrice;


@property (nonatomic, copy) NSString        *phone; //手机号
@property (nonatomic, copy) NSString        *consignee; //收获人
@property (nonatomic, copy) NSString        *shippingDate;//发货时间
@property (nonatomic, copy) NSString        *integralPrice;//青币抵用的人民币
@property (nonatomic, copy) NSString        *goodsDate;//确认收货时间
@property (nonatomic, copy) NSString        *integralNum;//青币数量
@property (nonatomic, copy) NSString        *address; //收货地址
@property (nonatomic, copy) NSString        *payDate;//支付时间
@property (nonatomic, copy) NSString        *useIntegral; //0未使用青币 1 使用青币
@property (nonatomic, copy) NSString        *createDate;//下单时间
@property (nonatomic, copy) NSString        *courierOrder;//快递单号
@property (nonatomic, copy) NSString        *courierName;//快递名称
@property (nonatomic, copy) NSString        *img;

@property (nonatomic, copy) NSString        *startDate;//确认收货时间
@property (nonatomic, copy) NSString        *endDate;//确认收货时间
@property (nonatomic, copy) NSString        *name; //收获人
@property (nonatomic, copy) NSString        *id; //收获人
@property (nonatomic, copy) NSString        *addressId; //收货地址
@property (nonatomic,  assign) float    pointToMony; //1青币抵扣金钱数量
@property (nonatomic, assign) float        point; //青币数量
@property (nonatomic, assign) float          getPoint; //支付成功获得的青币数量
@property (nonatomic, copy) NSString        *refundDate; //收获人



@property (nonatomic, copy) NSString        *falshsaleOrderId; //收货地址


@end
