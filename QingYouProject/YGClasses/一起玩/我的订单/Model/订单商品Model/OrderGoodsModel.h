//
//  OrderGoodsModel.h
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderGoodsModel : NSObject

@property (nonatomic, copy) NSString * orderGoodsImg;//图片
@property (nonatomic, copy) NSString * orderGoodsTitle;//名称
@property (nonatomic, copy) NSString * orderDate;//时间
@property (nonatomic, copy) NSString * orderAddress;//地点
@property (nonatomic, copy) NSString * orderPayType;//类型  (0:免费票  1:定金)
@property (nonatomic, copy) NSString * orderGoodsNum;//数量
@property (nonatomic, copy) NSString * orderGoodsPrice;//钱数

@end
