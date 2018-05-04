//
//  MyDecorationOrderModel.h
//  QingYouProject
//
//  Created by zhaoao on 2017/11/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDecorationOrderModel : NSObject

@property(nonatomic,strong)NSString *createDate;//创建时间
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *orderNum;//订单号
@property(nonatomic,strong)NSString *status;//支付状态 0待付款 1付款中 2已付款


@end
