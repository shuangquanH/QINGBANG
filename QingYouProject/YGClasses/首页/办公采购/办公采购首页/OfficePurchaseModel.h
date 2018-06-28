//
//  OfficePurchaseModel.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SQBaseModel.h"

@interface OfficePurchaseModel : SQBaseModel
/** 产品名称  */
@property (nonatomic,strong) NSString * commodityName;
/** 产品价格  */
@property (nonatomic,strong) NSString * commodityPrice;
@property (nonatomic,strong) NSString * commodityImg;
@property (nonatomic,strong) NSString * commodityID;

@end
