//
//  OfficePurchaseDetailModel.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SQBaseModel.h"

@interface OfficePurchaseDetailModel : SQBaseModel
///** 用户头像  */
//@property (nonatomic,strong) NSString * imageUrl;
///** 用户名称  */
//@property (nonatomic,strong) NSString * name;
///** 评论内容  */
//@property (nonatomic,strong) NSString * comment;
///** 图片URL数组  */
//@property (nonatomic,strong) NSArray * imagesArray;
///** 图片数组长度  */
//@property (nonatomic,assign) NSInteger countOfArr;
/** 用户头像  */
@property (nonatomic,strong) NSString * userImg;
/** 用户名称  */
@property (nonatomic,strong) NSString * userName;
/** 评论内容  */
@property (nonatomic,strong) NSString * context;
/** 图片URL数组  */
@property (nonatomic,strong) NSArray * imagesArray;
/** 图片数组长度  */
@property (nonatomic,assign) NSInteger countOfArr;
/** 评论日期  */
@property (nonatomic,strong) NSString * createDate;

@property (nonatomic,strong) NSString * imgs;



@property (nonatomic,assign) NSString *userAutograph;

@property (nonatomic,assign) NSString *userID;


@end
