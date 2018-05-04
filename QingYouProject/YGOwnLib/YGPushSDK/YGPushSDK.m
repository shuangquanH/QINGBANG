//
//  YGPushSDK.m
//  ApnsPushTest
//
//  Created by zhangkaifeng on 16/6/1.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGPushSDK.h"
#import "AFNetworking.h"
#import "YGConnectionService.h"
#import "AESCrypt.h"

@implementation YGPushSDK

static YGPushSDK *sharedManagerInstance = nil;
+ (YGPushSDK *)sharedManagerWithUserid:(NSString *)userid options:(void(^)(NSError *error))completeBlock
{
    if (!sharedManagerInstance)
    {
        sharedManagerInstance = [[self alloc]init];
    }
    sharedManagerInstance.userid = userid;
    sharedManagerInstance.completeBlock = completeBlock;
    [sharedManagerInstance loadDataFromServer];
    return sharedManagerInstance;
}

- (void)loadDataFromServer
{
    if (YGSingletonMarco.deviceToken == nil)
    {
        return;
    }
    
    NSDictionary *parame = @{
            @"token":YGSingletonMarco.deviceToken,
            @"userid":_userid
    };
    NSLog(@"%@",parame);
    [YGNetService YGPOST:@"AddToken" parameters:parame showLoadingView:NO scrollView:nil success:^(id responseObject)
    {
        if (_completeBlock)
        {
            _completeBlock(nil);
        }
    } failure:^(NSError *error)
    {
        if (_completeBlock)
        {
            _completeBlock(error);
        }
    }];
}

// 注册 APNS
+ (void)registerRemoteNotification
{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
                    UIUserNotificationTypeSound |
                    UIUserNotificationTypeBadge
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

+(void)registerSDKWithUserId:(NSString *)userId options:(void(^)(NSError *error))completeBlock
{
    [YGPushSDK sharedManagerWithUserid:userId options:completeBlock];
}

+ (void)unbindSDKWithUserId:(NSString *)userId
{
  
    NSDictionary *parame = @{
                             @"token":YGSingletonMarco.deviceToken,
                             @"userid":userId
                             };
    [YGNetService YGPOST:@"DeleteToken" parameters:parame showLoadingView:NO scrollView:nil success:^(id responseObject)
    {

    } failure:nil];
}
@end
