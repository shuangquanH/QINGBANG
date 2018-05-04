//
//  CommentModel.h
//  QingYouProject
//
//  Created by zhaoao on 2017/11/29.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SonCommentModel;

@interface CommentModel : NSObject

@property(nonatomic,strong)NSString *content;//评论
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *userName;//用户名称
@property(nonatomic,strong)NSString *count;//点赞数量
@property(nonatomic,strong)NSString *userImg;//用户头像
@property(nonatomic,strong)NSString *state;//点赞状态
@property (nonatomic,strong)NSArray <SonCommentModel *>*list;

@end

@interface SonCommentModel : NSObject

@property(nonatomic,strong)NSString *ID;//评论id
@property(nonatomic,strong)NSString *content;//评论内容
@property(nonatomic,strong)NSString *name;//后名称
@property(nonatomic,strong)NSString *userName;//前名称

@end
