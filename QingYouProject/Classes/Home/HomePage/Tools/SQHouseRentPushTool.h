//
//  SQHouseRentPushTool.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/22.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootViewController.h"


@interface SQHouseRentPushTool : NSObject

/** 根据targetType进行页面跳转  */
+ (void)pushControllerWithType:(NSString    *)target controller:(RootViewController *)vc;

+ (void)pushControllerWithType:(NSString    *)target param:(NSString *)param controller:(RootViewController *)vc;

/** 跳转到水电缴费  */
+ (void)pushToHouseRentWithController:(RootViewController *)vc;



@end
