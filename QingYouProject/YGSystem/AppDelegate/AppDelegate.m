//
//  AppDelegate.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/7/27.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "UMMobClick/MobClick.h"
#import "IQKeyboardManager.h"
#import "YGPushSDK.h"
#import "YGTabBarController.h"
#import "EBForeNotification.h"

#import <Pingpp.h>
#import <ZMCreditSDK/ALCreditService.h>
#import "SerchAdvertisesViewController.h"

@interface AppDelegate ()
{
    NSMutableDictionary *_localUserInfo;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    /**
     *  UMengShareSDK
     */
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:APPKEY_UMENG];
    //设置微信AppId、appSecret，分享url
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:APPKEY_UMENG_WXAPPID appSecret:APPKEY_UMENG_WXAPPSECRET redirectURL:APPKEY_UMENG_WXURL];
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:APPKEY_UMENG_QQAPPID  appSecret:nil redirectURL:APPKEY_UMENG_QQURL];
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:APPKEY_UMENG_SINAAPPID  appSecret:nil redirectURL:APPKEY_UMENG_SINAURL];
    /**
     *  UMeng统计
     */
    UMConfigInstance.appKey = APPKEY_UMENG;
    [MobClick setAppVersion:[YGAppTool getAppVersion]];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [Pingpp setAppId:@"app_SezXjTTSSevD9iPu"];
    [Pingpp setDebugMode:YES];

    /**
     *  IQKeyBoardManager
     */
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = YES;
    manager.toolbarManageBehaviour = IQAutoToolbarByPosition;
    manager.toolbarTintColor = colorWithMainColor;

//    [[manager disabledDistanceHandlingClasses] addObject:[SerchAdvertisesViewController class]];
//    [[manager disabledToolbarClasses] addObject:[SerchAdvertisesViewController class]];
//    [[manager disabledTouchResignedClasses] addObject:[SerchAdvertisesViewController class]];

    /**
     *  推送
     */
    [YGPushSDK registerRemoteNotification];
    _localUserInfo = [[NSMutableDictionary alloc] init];
    _pushState = ReceivePushStateNone;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickPushAction) name:EBBannerViewDidClick object:nil];
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey])
    {
        _pushState = ReceivePushStateDeadClickPush;
    }
    
    //芝麻信用
    [[ALCreditService sharedService] resgisterApp];

    /**
     *  配置mj
     */
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 @"descript" : @"description"
                 };
    }];
    
    /**
     *  初始化进入
     */
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = colorWithYGWhite;
    [_window makeKeyAndVisible];

    
    /**
     *  判断登录过没
     */
    if ([[NSFileManager defaultManager]fileExistsAtPath:USERFILEPATH])
    {
        YGSingletonMarco.user = [NSKeyedUnarchiver unarchiveObjectWithFile:USERFILEPATH];
        NSLog(@"--------------------%@---------%@---------------",YGSingletonMarco.user.userId,YGSingletonMarco.user.phone);
        YGSingletonMarco.user.userid = YGSingletonMarco.user.userId;
    }
    
    
    
    YGTabBarController *tabbar = [[YGTabBarController alloc]init];
    _window.rootViewController = tabbar;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applyroadShowDir = [NSString stringWithFormat:@"%@/Documents/applyroadShow/",NSHomeDirectory()];
    BOOL isDir =NO;
    BOOL existed = [fileManager fileExistsAtPath:applyroadShowDir isDirectory:&isDir];
    if ([fileManager fileExistsAtPath:[applyroadShowDir stringByAppendingPathComponent:@"1.mp4"] isDirectory:&isDir]) {
        [fileManager removeItemAtPath:[applyroadShowDir stringByAppendingPathComponent:@"1.mp4"] error:nil];

    }
    if(!(isDir ==YES && existed == YES)){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        NSLog(@"first run");
        [fileManager createDirectoryAtPath:applyroadShowDir withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSUserDefaults standardUserDefaults]setValue:applyroadShowDir forKey:@"kMP4FilePath"];
    }
    
    sleep(1);
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    
//    这样可以拿到返回来的字符串 进行转字符串

//再将里面的params 和 sign进行截取  截取方法如下：然后再将截取后的字符串传给后台即可

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

    
    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        NSString *state;
        if ([result isEqualToString:@"success"])
        {
            state = @"1";
            // ...
            
        }else if ([result isEqualToString:@"cancel"])
        {
            state = @"0";
        }
        else if([result isEqualToString:@"fail"])
        {
            state = @"0";
            NSLog(@"PingppError: code=%lu msg=%@", error.code, [error getMsg]);
            
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"paySuccess" object:nil userInfo:@{@"successOrNot":state}];
        
        
    }];
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        NSString *state;
        if ([result isEqualToString:@"success"])
        {
            state = @"1";
            // ...
            
        }else if ([result isEqualToString:@"cancel"])
        {
            state = @"0";
        }
        else if([result isEqualToString:@"fail"])
        {
            state = @"0";
            NSLog(@"PingppError: code=%lu msg=%@", error.code, [error getMsg]);
            
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"paySuccess" object:nil userInfo:@{@"successOrNot":state}];
        
        
    }];
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    YGSingletonMarco.deviceToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *userId;
    if (YGSingletonMarco.user)
    {
        userId = YGSingletonMarco.user.userId;
        [YGPushSDK registerSDKWithUserId:userId options:^(NSError *error)
        {
            if (!error)
            {
                NSLog(@"send token succeed");
            }
        }];
    }
}


//前台收到推送，后台收到推送点击，死了收到推送点击
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [_localUserInfo removeAllObjects];
    [_localUserInfo addEntriesFromDictionary:userInfo[@"aps"]];

    //死了进来点推送
    if (_pushState != ReceivePushStateDeadClickPush)
    {
        //前台收到未点击
        if (application.applicationState == UIApplicationStateActive)
        {
            _pushState = ReceivePushStateForeground;
            BOOL isiOS10 = NO;
            NSString *version = [UIDevice currentDevice].systemVersion;
            NSArray *versionArray = [version componentsSeparatedByString:@"."];
            if([versionArray[0] intValue] > 9)
            {
                isiOS10 = YES;
            }
            [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:isiOS10];
            completionHandler(UIBackgroundFetchResultNewData);
            _pushState = ReceivePushStateNone;
        }
            //后台和锁屏收到点击
        else
        {
            _pushState = ReceivePushStateBackgroundClickPush;
//            [self clickPushAction];

        }
    }

    NSLog(@"receive push : %@", _localUserInfo);
}

- (void)clickPushAction
{
    UITabBarController *tabBarController = (UITabBarController *) _window.rootViewController;
    UINavigationController *nowNavigationController = tabBarController.viewControllers[tabBarController.selectedIndex];
    UIViewController *topViewController = nowNavigationController.viewControllers[nowNavigationController.viewControllers.count - 1];
    if (topViewController.presentedViewController)
    {
        [topViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }

    switch ([_localUserInfo[@"type"] integerValue])
    {
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

/*
 * 把我放到首页
 */
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//
//    if(YGAppDelegate.pushState == ReceivePushStateDeadClickPush)
//    {
//        [YGAppDelegate clickPushAction];
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [YGPushSDK badageChangeWithBadgeNum:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
