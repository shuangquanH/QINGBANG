//
//  YZLAreaCacheTool.m
//  knight
//
//  Created by yzl on 17/5/24.
//  Copyright © 2017年 hongdongjie. All rights reserved.
//

#import "YZLAreaCacheTool.h"
#import "YZLAreaModel.h"
#import "JFAreaDataManager.h"

static NSArray *_AreaInstace;

#define Address_Data_Path [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"app_address_data"]

@implementation YZLAreaCacheTool

+ (void)getAreaDataCompleted:(void (^)(NSArray<YZLAreaModel *> *))completed {
    void (^ completedCopy)(NSArray<YZLAreaModel *> *) = [completed copy];
    if (_AreaInstace) {
        completedCopy(_AreaInstace);
        return;
    }
    
    //创建数据库
    [[JFAreaDataManager shareInstance] areaSqliteDBData];
    //读取本地数据
    [[JFAreaDataManager shareInstance] getAllProvince:^(NSMutableArray *dataArray) {
        if (!dataArray.count) {
            NSLog(@"读取所有省失败");
            return;
        }
        dispatch_group_t group = dispatch_group_create();
        
        NSMutableArray *realProv = [NSMutableArray array];
        for (NSString *prov in dataArray) {
            dispatch_group_enter(group);
            [[JFAreaDataManager shareInstance] getCityWithProvinceName:prov cities:^(NSMutableArray *cityArray) {
                YZLAreaModel *provModel = [YZLAreaModel new];
                provModel.name = prov;
                provModel.sons = [NSMutableArray array];
                
                for (NSString *city in cityArray) {
                    YZLAreaModel *cityModel = [YZLAreaModel new];
                    cityModel.name = city;
                    [provModel.sons addObject:cityModel];
                }
                [realProv addObject:provModel];
                dispatch_group_leave(group);
            }];
        }
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            _AreaInstace = realProv;
            completedCopy(realProv);
        });
    }];
}

+ (NSArray<YZLAreaModel *> *)getAreaData {
    if (!_AreaInstace) {
        NSArray *provinceDicArr;
        if([[NSFileManager defaultManager] fileExistsAtPath:Address_Data_Path]){//沙盒中存在
            NSData *resData = [NSData dataWithContentsOfFile:Address_Data_Path];
            provinceDicArr = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:nil];
        } else {
            NSError *error;
            NSString *jsonStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"addressJson" ofType:@"txt"] encoding:-2147482062 error:&error];
            if (error) {
                NSLog(@"地址文件读出错误--%@", [error localizedDescription]);
            }
            NSData *resData = [[NSData alloc] initWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
            [resData writeToFile:Address_Data_Path atomically:NO];
            provinceDicArr = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:nil];
        }
        _AreaInstace = [YZLAreaModel mj_objectArrayWithKeyValuesArray:nil];
    }
    return _AreaInstace;
}

+ (void)setAreaData:(id)AreaData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [AreaData writeToFile:Address_Data_Path atomically:YES];
        _AreaInstace = [YZLAreaModel mj_objectArrayWithKeyValuesArray:AreaData];
    });
}


+ (void)reloadAreaData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _AreaInstace = nil;
        [self getAreaData];
    });
}

+ (void)querySelectAreaIDWithDict:(NSDictionary *)dict completed:(void (^)(NSDictionary *))complted {
    YZLAreaModel *provinceInfo = dict[@"province"];
    YZLAreaModel *cityInfo = dict[@"city"];
    [[JFAreaDataManager shareInstance] getCityIDWithCityName:cityInfo.name cityID:^(NSString *cityId) {
        cityInfo.ID = [cityId longLongValue];
        complted(@{@"province": provinceInfo,
                   @"city": cityInfo});
    }];
}

@end
