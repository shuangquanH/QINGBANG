//
//  OfficePurchSureOrderModel.h
//  QingYouProject
//
//  Created by apple on 2017/11/3.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDBaseModel.h"

@interface OfficePurchSureOrderModel : LDBaseModel
@property (nonatomic,strong) NSString * point;
@property (nonatomic,strong) NSDictionary * commodity;
@property (nonatomic,strong) NSString * pointPrice;
@property (nonatomic,strong) NSDictionary * address;

@end
