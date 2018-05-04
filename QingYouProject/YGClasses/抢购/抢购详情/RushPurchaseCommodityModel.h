//
//  RushPurchaseCommodityModel.h
//  QingYouProject
//
//  Created by 王丹 on 2017/12/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RushPurchaseCommodityModel : NSObject
@property (nonatomic, copy) NSString        *id;
@property (nonatomic, copy) NSString        *oldPrice;
@property (nonatomic, copy) NSString        *stock;
@property (nonatomic, copy) NSString        *newprice;
@property (nonatomic, copy) NSString        *name;
@property (nonatomic, copy) NSString        *img;
@property (nonatomic, assign) BOOL        select;
@property (nonatomic, copy) NSString        *number;

@end
