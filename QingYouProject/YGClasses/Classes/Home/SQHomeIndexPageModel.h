//
//  SQHomeIndexPageModel.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/28.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  首页模块model

#import <Foundation/Foundation.h>

@interface SQHomeBannerModel : NSObject

@property (nonatomic, copy) NSString       *banner_target;
@property (nonatomic, copy) NSString       *banner_target_params;
@property (nonatomic, copy) NSString       *banner_image_url;


@end

@interface SQHomeFuncsModel : NSObject
@property (nonatomic, copy) NSString       *banner_target;
@property (nonatomic, copy) NSString       *banner_target_params;
@property (nonatomic, copy) NSString       *banner_image_url;
@property (nonatomic, assign) CGSize       funcsSize;


@end

@interface SQHomeHeadsModel : NSObject

@property (nonatomic, copy) NSString       *banner_target;
@property (nonatomic, copy) NSString       *banner_target_params;
@property (nonatomic, copy) NSString       *banner_image_url;

@end


@interface SQHomeIndexPageModel : NSObject

@property (nonatomic, strong) NSArray       *banners;
@property (nonatomic, strong) NSArray       *funcs;
@property (nonatomic, strong) NSArray       *heads;


@end
