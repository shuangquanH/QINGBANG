//
//  SQGetWeatherTool.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/27.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  获取天气工具

#import <Foundation/Foundation.h>

@interface SQGetWeatherTool : NSObject


/** 根据城市名称获取当前温度和天气  */
+ (void)getTemAndWeatherWithCity:(NSString *)city success:(void(^)(NSString *tem, NSString *weather))success;


/** 获取天气详情  */
+ (void)getWeatherInfoWithCity:(NSString *)city success:(void(^)(NSDictionary *info))success;

@end
