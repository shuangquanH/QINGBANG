//
//  SQHomeIndexPageModel.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/28.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  首页模块model

#import <Foundation/Foundation.h>


/** 轮播图或者首页定制功能model  */
@interface SQHomeBannerModel : NSObject
@property (nonatomic, copy) NSString       *banner_target;
@property (nonatomic, copy) NSString       *banner_target_params;
@property (nonatomic, copy) NSString       *banner_image_url;
@end

/** 首页头部功能按钮model  */
@interface SQHomeHeadsModel : NSObject
@property (nonatomic, copy) NSString       *funcs_target;
@property (nonatomic, copy) NSString       *funcs_target_params;
@property (nonatomic, copy) NSString       *funcs_image_url;
@property (nonatomic, copy) NSString       *funcs_image_url_sel;
@end

/** 首页功能按钮model  */
@interface SQHomeFuncsModel : NSObject
@property (nonatomic, copy) NSString       *funcs_target;
@property (nonatomic, copy) NSString       *funcs_target_params;
@property (nonatomic, copy) NSString       *funcs_image_url;
@property (nonatomic, assign) CGSize       funcsSize;
@end

/** 首页model  */
@interface SQHomeIndexPageModel : SQBaseModel
@property (nonatomic, strong) NSArray       *banners;
@property (nonatomic, strong) NSArray       *funcs;
@property (nonatomic, strong) NSArray       *heads;
@property (nonatomic, copy) NSString       *bgimg_url;
@end

/** 首页定制功能model  */
@interface SQHomeCustomModel : SQBaseModel
@property (nonatomic, strong) NSArray       *banners;
@end
