//
//  RushPurchaseProductModel.h
//  QingYouProject
//
//  Created by 王丹 on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RushPurchaseProductModel : NSObject
/*
 "oldPrice": 456456.46,  // 旧价格
 "newPrice": 12312313.57, //现价
 "coverUrl":  //封面图片
 "falshSaleSizesSales": 0, //已售数量
 "percentage": "0.00%",  //百分比
 "name": "大脑负",  //商品名
 "type": "1"  // 1 马上抢 2 已结束 0 提醒我
 “reminding” 0 未添加提醒  1 已添加提醒
 subtitle // 副标题
 
 */
@property (nonatomic, copy) NSString        *oldPrice;
@property (nonatomic, copy) NSString        *newprice;
@property (nonatomic, copy) NSString        *falshSaleSizesSales;
@property (nonatomic, copy) NSString        *percentage;
@property (nonatomic, copy) NSString        *name;
@property (nonatomic, copy) NSString        *type;

@property (nonatomic, copy) NSString        *coverUrl;
@property (nonatomic, copy) NSString        *reminding;
@property (nonatomic, copy) NSString        *subTitle;
@property (nonatomic, copy) NSString        *commodityId;

//详情页面
@property (nonatomic, copy) NSString        *id;
@property (nonatomic, copy) NSString        *startDate;
@property (nonatomic, copy) NSString        *endDate;
@property (nonatomic, copy) NSString        *description;//商品详情
@property (nonatomic, copy) NSString        *falshSaleSizeName;//规格
@property (nonatomic, copy) NSString        *falshSaleSizeId; //规格ID
@property (nonatomic, copy) NSArray        *img;//轮播图
@property (nonatomic, copy) NSArray        *lable;//标签
@property (nonatomic, copy) NSString        *prompting;//显示文字
@property (nonatomic, copy) NSString        *falshSaleSizesSum;//库存
@property (nonatomic, copy) NSString        *share;//分享
@property (nonatomic, copy) NSString        *collection;//收藏 0 否  1 是
@property (nonatomic, copy) NSString        *remindingSum;//收藏 0 否  1 是
@property (nonatomic, copy) NSString        *code;//收藏 0 否  1 是


@end
