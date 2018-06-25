//
//  WKInvoiceModel.m
//  QingYouProject
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKInvoiceModel.h"

@implementation WKInvoiceModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id", @"isDefault": @"default"};
}
@end
