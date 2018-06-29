//
//  SQDecorationDetailModel.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/29.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQBaseModel.h"

@interface SQDecorationDetailModel : SQBaseModel

/** 定金  */
@property (nonatomic, copy) NSString       *earnest;
/** 分享图片  */
@property (nonatomic, copy) NSString       *imageUrl;
/** 商品属性  */
@property (nonatomic, copy) NSString       *properties;
/** 分享url  */
@property (nonatomic, copy) NSString       *shareUrl;
/** 商品名称  */
@property (nonatomic, copy) NSString       *title;
/** 总价  */
@property (nonatomic, copy) NSString       *totalprice;
/** 是否在销售  */
@property (nonatomic, copy) NSString       *isOnSale;
/** 商品详情高度  */
@property (nonatomic, assign) CGFloat       productInfoHeight;
/** 报价单高度  */
@property (nonatomic, assign) CGFloat       priceSheetHeight;
/** sku id  */
@property (nonatomic, copy) NSString       *productSkuId;


@end
