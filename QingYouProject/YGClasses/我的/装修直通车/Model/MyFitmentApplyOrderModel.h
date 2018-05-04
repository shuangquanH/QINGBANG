//
//  MyFitmentApplyOrderModel.h
//  QingYouProject
//
//  Created by zhaoao on 2017/11/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFitmentApplyOrderModel : NSObject

@property(nonatomic,strong)NSString *createDate;//创建时间
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *name;//设计名字
@property(nonatomic,strong)NSString *orderNum;//订单号
@property(nonatomic,strong)NSString *phone;//0效果申请 1自定义预算 此处是一个标示 接下里的请求需要用到
@property(nonatomic,strong)NSString *status;//申请状态
@property(nonatomic,strong)NSString *createTime;//创建日期
@property(nonatomic,strong)NSString *acceptTime;//受理日期
@property(nonatomic,strong)NSString *quotedTime;//报价日期
@property(nonatomic,strong)NSString *finishTime;//达成合作日期

@end
