//
//  SQDecorationHomeModel.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  装修首页model

#import "SQBaseModel.h"


@interface SQDecorationStyleModel : SQBaseModel
//type:列表类型,1为商品,2为广告,3为纯展示  imgurl:图片  linkurl:跳转链接  goodsType:商品类型
@property (nonatomic, copy) NSString       *goodsType;
@property (nonatomic, copy) NSString       *imgurl;
@property (nonatomic, copy) NSString       *linkurl;
@property (nonatomic, copy) NSString       *type;

@end




@interface SQDecorationHomeModel : SQBaseModel

@property (nonatomic, strong) NSArray       *banners;
@property (nonatomic, strong) NSArray       *contents;


@end
