//
//  OrderCheckHouseModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/11/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderCheckHouseModel : NSObject
@property (nonatomic, copy) NSString            *id;
@property (nonatomic, copy) NSString            *name;
@property (nonatomic, copy) NSString            *proportion; //面积
@property (nonatomic, copy) NSString            *floor;
@property (nonatomic, copy) NSString            *remarks;//装修类型
@property (nonatomic, copy) NSString            *price; //月租
@property (nonatomic, copy) NSString            *imgs; //图片

@property (nonatomic, copy) NSString            *payway; //面积
@property (nonatomic, copy) NSString            *contacts;
@property (nonatomic, copy) NSString            *contact;//装修类型
@property (nonatomic, copy) NSString            *description; //月租
//我的预约单
@property (nonatomic, copy) NSString            *img; //图片
@property (nonatomic, copy) NSString            *time; //时间
@property (nonatomic, copy) NSString            *belongId; //时间
@property (nonatomic, copy) NSString            *url; //时间


@end
