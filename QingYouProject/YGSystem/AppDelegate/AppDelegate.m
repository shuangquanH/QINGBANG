//
//  AppDelegate.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/7/27.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGPushSDK.h"
#import "YGTabBarController.h"
#import "EBForeNotification.h"

#import <Pingpp.h>



#import "AppStartManager.h"

@interface AppDelegate ()
{
    NSMutableDictionary *_localUserInfo;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[AppStartManager shareManager] startApplication:application withOptions:launchOptions];

    /** 推送相关  */
    [YGPushSDK registerRemoteNotification];
    _localUserInfo = [[NSMutableDictionary alloc] init];
    _pushState = ReceivePushStateNone;
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        _pushState = ReceivePushStateDeadClickPush;
    }

    /** 初始化window  */
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = colorWithYGWhite;
    [_window makeKeyAndVisible];
    YGTabBarController *tabbar = [[YGTabBarController alloc]init];
    self.window.rootViewController = tabbar;
    
    
    sleep(1);
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    /** 这样可以拿到返回来的字符串 进行转字符串，再将里面的params 和 sign进行截取  截取方法如下：然后再将截取后的字符串传给后台即可  */
    NSArray *strarray = [[url absoluteString] componentsSeparatedByString:@"="];
    
    if (strarray.count > 1) {
        NSString *param = [strarray objectAtIndex:1];
        
        NSArray *paramSrr = [param componentsSeparatedByString:@"&"];
        
        NSString *params =[paramSrr firstObject];
        
        NSString *sign =[strarray lastObject];
        
        NSMutableDictionary *paraDic = @{}.mutableCopy;
        
        [paraDic setObject:params forKey:@"params"];
        
        [paraDic setObject:sign forKey:@"sign"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"alipayCertifySuccess" object:nil userInfo:paraDic];
    }

    [Pingpp handleOpenURL:url withCompletion:nil];
//    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
//        NSString *state;
//        if ([result isEqualToString:@"success"]) {
//
//            state = @"1";
//
//        }else if ([result isEqualToString:@"cancel"]) {
//
//            state = @"0";
//
//        }
//        else if([result isEqualToString:@"fail"]) {
//
//            state = @"0";
//            NSLog(@"PingppError: code=%lu msg=%@", error.code, [error getMsg]);
//
//        }
//
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"paySuccess" object:nil userInfo:@{@"successOrNot":state}];
//
//
//    }];
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [Pingpp handleOpenURL:url withCompletion:nil];
//    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
//        NSString *state;
//        if ([result isEqualToString:@"success"]) {
//            state = @"1";
//
//        } else if ([result isEqualToString:@"cancel"]) {
//            state = @"0";
//        } else if([result isEqualToString:@"fail"]) {
//            state = @"0";
//            NSLog(@"PingppError: code=%lu msg=%@", error.code, [error getMsg]);
//        }
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"paySuccess" object:nil userInfo:@{@"successOrNot":state}];
//    }];
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    YGSingletonMarco.deviceToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *userId;
    if (YGSingletonMarco.user) {
        userId = YGSingletonMarco.user.userId;
        [YGPushSDK registerSDKWithUserId:userId options:^(NSError *error) {
            if (!error) {
                NSLog(@"send token succeed");
            }
        }];
    }
}


//前台收到推送，后台收到推送点击，死了收到推送点击
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [_localUserInfo removeAllObjects];
    [_localUserInfo addEntriesFromDictionary:userInfo[@"aps"]];

    //死了进来点推送
    if (_pushState != ReceivePushStateDeadClickPush) {
        //前台收到未点击
        if (application.applicationState == UIApplicationStateActive) {
            _pushState = ReceivePushStateForeground;
            BOOL isiOS10 = NO;
            NSString *version = [UIDevice currentDevice].systemVersion;
            NSArray *versionArray = [version componentsSeparatedByString:@"."];
            if([versionArray[0] intValue] > 9) {
                isiOS10 = YES;
            }
            [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:isiOS10];
            completionHandler(UIBackgroundFetchResultNewData);
            _pushState = ReceivePushStateNone;
        } else {
            _pushState = ReceivePushStateBackgroundClickPush;
        }
    }
}

- (void)clickPushAction {
    UITabBarController *tabBarController = (UITabBarController *) _window.rootViewController;
    UINavigationController *nowNavigationController = tabBarController.viewControllers[tabBarController.selectedIndex];
    UIViewController *topViewController = nowNavigationController.viewControllers[nowNavigationController.viewControllers.count - 1];
    if (topViewController.presentedViewController) {
        [topViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }

    switch ([_localUserInfo[@"type"] integerValue]) {
        case 1:
        {

        }
            break;
        case 2:
        {

        }
            break;
        case 3:
        {

        }
            break;
        case 4:
        {

        }
            break;
        default:
            break;
    }
    _pushState = ReceivePushStateNone;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
