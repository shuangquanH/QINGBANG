//
//  YZLHomeAreaModel.m
//  knight
//
//  Created by yzl on 17/2/16.
//  Copyright © 2017年 hongdongjie. All rights reserved.
//

#import "YZLAreaModel.h"

@implementation YZLAreaModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"sons": @"YZLAreaModel"};
}

- (NSMutableArray<YZLAreaModel *> *)sons {
    if (!_sons) {
        _sons = [NSMutableArray array];
    }
    return _sons;
}
- (instancetype)init {
    if (self == [super init]) {
        _ID = -1;
    }
    return self;
}

@end
