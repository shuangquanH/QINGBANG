//
//  YZLAreaCacheTool.m
//  knight
//
//  Created by yzl on 17/5/24.
//  Copyright © 2017年 hongdongjie. All rights reserved.
//

#import "YZLAreaCacheTool.h"
#import "YZLAreaModel.h"

static NSArray *_AreaInstace;

#define Address_Data_Path [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"app_address_data"]

@implementation YZLAreaCacheTool

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
        _AreaInstace = [YZLAreaModel mj_objectArrayWithKeyValuesArray:provinceDicArr];
    }
    
    return _AreaInstace;
}

+ (void)setAreaData:(id)AreaData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [AreaData writeToFile:Address_Data_Path atomically:YES];
        _AreaInstace = [YZLAreaModel mj_objectArrayWithKeyValuesArray:AreaData];
    });
}


+ (void)reloadAreaData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _AreaInstace = nil;
        [self getAreaData];
    });
}

@end
