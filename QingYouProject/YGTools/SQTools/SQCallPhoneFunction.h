//
//  SQCallPhoneFunction.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/28.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQCallPhoneFunction : NSObject

/** 拨打客服电话  */
+ (void)callServicePhone;

/** 拨打电话  */
+ (void)callWithPhoem:(NSString *)phone;
@end
