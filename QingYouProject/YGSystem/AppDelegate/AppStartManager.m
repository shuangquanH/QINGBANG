//
//  AppStartManager.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/4.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "AppStartManager.h"


#import "UMMobClick/MobClick.h"
#import "IQKeyboardManager.h"

#import <Pingpp.h>
#import <ZMCreditSDK/ALCreditService.h>


@implementation AppStartManager {
    NSMutableDictionary *_localUserInfo;
    
}

+ (instancetype)shareManager {
    static AppStartManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AppStartManager alloc] init];
    });
    return manager;
}

- (void)startApplication:(UIApplication *)appcation withOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    /** UMengShareSDK  */
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
    
    /** UMeng统计  */
    UMConfigInstance.appKey = APPKEY_UMENG;
    [MobClick setAppVersion:[YGAppTool getAppVersion]];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [Pingpp setAppId:@"app_SezXjTTSSevD9iPu"];
    [Pingpp setDebugMode:YES];
    
    /** IQKeyBoardManager  */
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = YES;
    manager.toolbarManageBehaviour = IQAutoToolbarByPosition;
    manager.toolbarTintColor = colorWithMainColor;
    
    //芝麻信用
    [[ALCreditService sharedService] resgisterApp];
    
    /** 配置mj  */
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 @"descript" : @"description"
                 };
    }];
    
    /** 判断登录过没  */
    if ([[NSFileManager defaultManager]fileExistsAtPath:USERFILEPATH]) {
        YGSingletonMarco.user = [NSKeyedUnarchiver unarchiveObjectWithFile:USERFILEPATH];
    }
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applyroadShowDir = [NSString stringWithFormat:@"%@/Documents/applyroadShow/",NSHomeDirectory()];
    BOOL isDir =NO;
    BOOL existed = [fileManager fileExistsAtPath:applyroadShowDir isDirectory:&isDir];
    if ([fileManager fileExistsAtPath:[applyroadShowDir stringByAppendingPathComponent:@"1.mp4"] isDirectory:&isDir]) {
        [fileManager removeItemAtPath:[applyroadShowDir stringByAppendingPathComponent:@"1.mp4"] error:nil];
        
    }
    if(!(isDir ==YES && existed == YES)){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        [fileManager createDirectoryAtPath:applyroadShowDir withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSUserDefaults standardUserDefaults]setValue:applyroadShowDir forKey:@"kMP4FilePath"];
    }
}



@end
