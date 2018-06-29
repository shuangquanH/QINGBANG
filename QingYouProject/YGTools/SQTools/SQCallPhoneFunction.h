//
//  SQCallPhoneFunction.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/28.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQCallPhoneFunction : NSObject

/** 拨打客服电话（直接拨打）  */
+ (void)callServicePhone;

/** 拨打客服电话（带弹出框）  */
+ (void)callServicePhoneWithPopver;

/** 拨打电话  (直接拨打)*/
+ (void)callWithPhoem:(NSString *)phone;

/** 拨打电话（带弹出框）  */
+ (void)callWithPhoem:(NSString *)phone withPopverTitle:(NSString *)title;


@end
