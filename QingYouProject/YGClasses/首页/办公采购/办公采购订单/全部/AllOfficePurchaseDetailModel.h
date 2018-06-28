//
//  AllOfficePurchaseDetailModel.h
//  QingYouProject
//
//  Created by apple on 2017/11/7.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SQBaseModel.h"

@interface AllOfficePurchaseDetailModel : SQBaseModel

@property (nonatomic,strong) NSString * orderID;
@property (nonatomic,strong) NSString * orderDate;
@property (nonatomic,strong) NSString * deliverDate;
@property (nonatomic,strong) NSString * commodityPrice;
@property (nonatomic,strong) NSString * commodityCount;
@property (nonatomic,strong) NSString * refundSuccessDate;
@property (nonatomic,strong) NSString * commodityName;
@property (nonatomic,strong) NSString * confirmDate;
@property (nonatomic,strong) NSString * type;

@property (nonatomic,strong) NSString * userAddress;
@property (nonatomic,strong) NSString * refundDate;
@property (nonatomic,strong) NSString * commodityValue;
@property (nonatomic,strong) NSString * expressNumber;
@property (nonatomic,strong) NSString * commodityImg;
@property (nonatomic,strong) NSString * orderNumber;

@property (nonatomic,strong) NSString * freight;
@property (nonatomic,strong) NSString * expressName;
@property (nonatomic,strong) NSString * userName;
@property (nonatomic,strong) NSString * payDate;
@property (nonatomic,strong) NSString * userPhone;

@property (nonatomic,strong) NSString * commodityID;
@property (nonatomic,strong) NSString * totalPrice;

@property (nonatomic,strong) NSString * pointPrice;
@property (nonatomic,strong) NSString * point;

@end
