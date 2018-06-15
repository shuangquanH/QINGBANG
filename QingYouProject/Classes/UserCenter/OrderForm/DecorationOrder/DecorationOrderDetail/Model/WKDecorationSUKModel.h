//
//  WKDecorationSUKModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/15.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  商品信息模型

#import <Foundation/Foundation.h>

/*********** 商品属性模型 *************/
@interface WKDecorationPropertyModel: NSObject

@property (nonatomic, copy  ) NSString *propertyName;

@property (nonatomic, copy  ) NSString *propertyValue;

@end

/*********** 商品信息模型 *************/
@interface WKDecorationSUKModel : NSObject

@property (nonatomic, copy  ) NSString *ID;

@property (nonatomic, copy  ) NSString *productId;

@property (nonatomic, copy  ) NSString *skuQuotationSheet;

@property (nonatomic, copy  ) NSString *updateBy;

@property (nonatomic, copy  ) NSString *createDate;

@property (nonatomic, copy  ) NSString *skuPrice;

@property (nonatomic, assign) BOOL     deleted;

@property (nonatomic, copy  ) NSString *updateDate;

@property (nonatomic, strong) NSArray<WKDecorationPropertyModel *> *skuAttrList;

@property (nonatomic, copy  ) NSString *skuImgUrl;

@property (nonatomic, copy  ) NSString *remarks;

@property (nonatomic, copy  ) NSString *skuDesc;

@property (nonatomic, copy  ) NSString *createBy;

@end
