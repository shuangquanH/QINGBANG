//
//  SecondhandPeplaceCollectModel.h
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecondhandPeplaceCollectModel : NSObject
@property(nonatomic,strong)NSString *cid;//收藏
@property(nonatomic,strong)NSString *mid;//收藏

@property(nonatomic,strong)NSString *wantChange;//想换的商品分类
@property(nonatomic,strong)NSString *createDate;//时间
@property(nonatomic,strong)NSString *title;//商品名称
@property(nonatomic,strong)NSString *userName;//用户名称
@property(nonatomic,strong)NSString *userImg;//用户头像
@property(nonatomic,strong)NSArray *imgs;//图片
@property(nonatomic,strong)NSString *colCounts;//收藏数
@property(nonatomic,strong)NSString *size;//评论数
@property(nonatomic,strong)NSString *delFlag;//评论数

@end
