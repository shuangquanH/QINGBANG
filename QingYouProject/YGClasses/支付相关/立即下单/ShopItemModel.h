//
// Created by zhangkaifeng on 2017/9/25.
// Copyright (c) 2017 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShopItemModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *price; //价格
@property (nonatomic, copy) NSString *type;  //1地址咨询 2财务代记账
@property (nonatomic, copy) NSString *kind; //类别
@property (nonatomic, copy) NSString *year; //年限

@end