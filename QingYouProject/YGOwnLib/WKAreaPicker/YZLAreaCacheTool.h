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
+ (void)setAreaData:(id)AreaData;

+(void)reloadAreaData;
@end
