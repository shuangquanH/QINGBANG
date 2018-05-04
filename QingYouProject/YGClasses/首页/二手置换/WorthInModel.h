//
//  WorthInModel.h
//  QingYouProject
//
//  Created by zhaoao on 2017/12/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorthInModel : NSObject

@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *classify;//想换的商品分类
@property(nonatomic,strong)NSString *time;//时间
@property(nonatomic,strong)NSString *title;//商品名称
@property(nonatomic,strong)NSString *address;//地址
@property(nonatomic,strong)NSString *name;//用户名称
@property(nonatomic,strong)NSString *img;//用户头像
@property(nonatomic,strong)NSString *picList;//图片
@property(nonatomic,strong)NSString *colCounts;//收藏数
@property(nonatomic,strong)NSString *size;//评论数

@end
