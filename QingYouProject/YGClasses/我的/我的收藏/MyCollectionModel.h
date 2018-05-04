//
//  MyCollectionModel.h
//  QingYouProject
//
//  Created by zhaoao on 2017/12/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCollectionModel : NSObject

//公共
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *img;

//资金扶持
@property(nonatomic,strong)NSString *picture;
@property(nonatomic,strong)NSString *projectName;

//限时抢购
@property(nonatomic,strong)NSString *commodityImg;
@property(nonatomic,strong)NSString *commodityName;
@property(nonatomic,strong)NSString *commodityId;

//新鲜事
@property(nonatomic,strong)NSString *belongId;


@property(nonatomic,strong)NSString *official;

@property(nonatomic,strong)NSString *projectState;

@end
