//
//  SQDecorationAddressModel.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQBaseModel.h"

@interface SQDecorationAddressModel : SQBaseModel

@property (nonatomic, copy) NSString       *address;
@property (nonatomic, copy) NSString       *city;
@property (nonatomic, copy) NSString       *dist;
@property (nonatomic, copy) NSString       *addressid;
@property (nonatomic, copy) NSString       *phone;
@property (nonatomic, copy) NSString       *defAddress;
@property (nonatomic, copy) NSString       *prov;
@property (nonatomic, copy) NSString       *name;

@end
