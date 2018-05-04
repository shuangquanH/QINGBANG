//
//  YGPushSDK.h
//  ApnsPushTest
//
//  Created by zhangkaifeng on 16/6/1.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGPushSDK : NSObject

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, copy) void (^completeBlock)(NSError *error);

/**
 *  注册sdk方法
 *
 *  @param userId 取到的deviceToken
 *  @param completeBlock 完成注册回调
 */
+ (void)registerSDKWithUserId:(NSString *)userId options:(void (^)(NSError *error))completeBlock;

/**
 *  变更badge到本地和服务器方法
 *
 *  @param badgeNum   要变更的badge数
 */
+ (void)badageChangeWithBadgeNum:(int)badgeNum;

/**
 *  注册通知方法
 */
+ (void)registerRemoteNotification;

/**
 * 解绑sdk方法
 * @param userId
 */
+ (void)unbindSDKWithUserId:(NSString *)userId;

@end
