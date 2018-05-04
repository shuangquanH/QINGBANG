//
//  YGUser.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/9.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGUser.h"
#import "MJExtension.h"

@implementation YGUser
@synthesize description;

//归档
MJExtensionCodingImplementation

-(NSString *)userId
{
    if(!_userId)
        return @"15840634602";
    return _userId;
}
@end
