//
//  SQGetWeatherTool.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/27.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQGetWeatherTool.h"

#define KGETWEATHERINFOAPI @"https://www.sojson.com/open/api/weather/json.shtml"


@implementation SQGetWeatherTool

+ (void)getTemAndWeatherWithCity:(NSString *)city success:(void(^)(NSString *tem, NSString *weather))success {
    
    [self getWeatherInfoWithCity:city success:^(NSDictionary *info) {
        NSString    *temp = [NSString stringWithFormat:@"%@", info[@"wendu"]];
        NSArray     *forecast = [NSArray arrayWithArray:info[@"forecast"]];
        NSDictionary *todyForecast = [NSDictionary dictionaryWithDictionary:forecast.firstObject];
        NSString    *weather = [NSString stringWithFormat:@"%@", todyForecast[@"type"]];
        success(temp, weather);
    }];

}


+ (void)getWeatherInfoWithCity:(NSString *)city success:(void(^)(NSDictionary *info))success {
//    [YGAppTool showToastWithText:@"正在获取天气信息..."];
    NSString *apistr = [NSString stringWithFormat:KGETWEATHERINFOAPI];
    NSDictionary    *cityParam = @{@"city":city};
    [[AFHTTPSessionManager manager] GET:apistr parameters:cityParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] isEqual:@200]) {
            success(responseObject[@"data"]);
        } else {
            [YGAppTool showToastWithText:@"获取天气信息失败!"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [YGAppTool showToastWithText:@"获取天气信息失败!"];
    }];
}

@end
