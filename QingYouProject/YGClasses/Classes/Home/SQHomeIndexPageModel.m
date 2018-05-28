//
//  SQHomeIndexPageModel.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/28.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQHomeIndexPageModel.h"

@implementation SQHomeBannerModel

@end
@implementation SQHomeFuncsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"funcsSize":@"size"};
}

// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSDictionary *sizeDic = dic[@"size"];
    if (!sizeDic[@"width"]||!sizeDic[@"height"]) {
        return NO;
    }
    CGFloat widthFloat = [sizeDic[@"width"] floatValue];
    CGFloat heightFloat = [sizeDic[@"height"] floatValue];
    
    _funcsSize = CGSizeMake(widthFloat, heightFloat);
    return YES;
}
@end


@implementation SQHomeHeadsModel

@end

@implementation SQHomeIndexPageModel
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"banners" : SQHomeBannerModel.class,
             @"funcs" : SQHomeFuncsModel.class,
             @"heads" : SQHomeHeadsModel.class };
}


@end
