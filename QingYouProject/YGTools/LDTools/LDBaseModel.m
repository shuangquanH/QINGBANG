//
//  LDBaseModel.m
//  OC_Project2017
//
//  Created by LDSmallCat on 17/2/9.
//  Copyright © 2017年 曹来东. All rights reserved.
//

#import "LDBaseModel.h"



@implementation LDBaseModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    NSDictionary *dict = @{
                           
                           @"desc":@"description",
                           @"ID":@"id"
                        
                           };
    
    
    return dict;
    
}

//处理数据
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    //处理原始数据为null的字段
    if ([oldValue isKindOfClass:[NSNull class]])
    {
        if (property.type.isNumberType)
        {
            return 0;
        }
        else if (property.type.isBoolType)
        {
            return 0;
        }
        else if ([property.type.code isEqualToString:@"NSArray"])
        {
            return @[];
            
        }
//        else if ([property.type.code isEqualToString:@"NSMutableArray"]){
//        
//            return [NSMutableArray array];
//        }
        else
        {
            return @"";
            
            //return @"空字符串";
        }
    }
    //把没有的字段处理成空字符串
    if (!oldValue)
    {
        return @"";
        
        //return @"空字符串";
    }
    return oldValue;
}

//如果model中有属性是个数组 需要用到这个方法
+ (NSDictionary *)mj_objectClassInArray
{
    //说明array这个字段存放的是 SubModel 类型的对象
    NSDictionary *dict = @{@"array" :[self class]};
    return dict;
}
@end
