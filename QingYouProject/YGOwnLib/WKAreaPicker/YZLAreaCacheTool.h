//
//  YZLAreaCacheTool.h
//  knight
//
//  Created by yzl on 17/5/24.
//  Copyright © 2017年 hongdongjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YZLAreaModel;
@interface YZLAreaCacheTool : NSObject


+ (NSArray<YZLAreaModel *> *)getAreaData;
+ (void)getAreaDataCompleted:(void(^)(NSArray<YZLAreaModel *> *))completed;
+ (void)setAreaData:(id)AreaData;

+ (void)reloadAreaData;

+ (void)querySelectAreaIDWithDict:(NSDictionary *)dict completed:(void (^) (NSDictionary *dict))complted;

@end
