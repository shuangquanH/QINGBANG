//
//  SQDecorationHomeModel.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationHomeModel.h"

@implementation SQDecorationStyleModel
@end


@implementation SQDecorationHomeModel


// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"banners" : SQDecorationStyleModel.class,
             @"contents" : SQDecorationStyleModel.class};
}


@end
