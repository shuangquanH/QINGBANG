//
//  AllOfficePurchaseModel.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SQBaseModel.h"

@interface AllOfficePurchaseModel : SQBaseModel
/** 订单类型 : 待付款,待发货,已发货,交易成功,退款中,退款成功,退款失败 */
//@property (nonatomic,assign) int cellType;
/** 订单号  */
@property (nonatomic,strong) NSString * orderNumber;
/** 订单状态  */
@property (nonatomic,strong) NSString * orderStatus;

@property (nonatomic,strong) NSString * orderID;
@property (nonatomic,strong) NSString * commodityImg;
@property (nonatomic,strong) NSString * freight;
@property (nonatomic,strong) NSString * commodityValueName;
@property (nonatomic,strong) NSString * commodityCount;
@property (nonatomic,strong) NSString * commodityPrice;
@property (nonatomic,strong) NSString * commodityName;
@property (nonatomic,strong) NSString * type;
@property (nonatomic,strong) NSString * totalPrice;
@property (nonatomic,strong) NSString * commodityID;


@end
