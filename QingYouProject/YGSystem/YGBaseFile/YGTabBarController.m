//
//  YGTabBarController.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/4.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGTabBarController.h"
#import "YGNavigationController.h"
#import "YGTabbar.h"
#import <AudioToolbox/AudioToolbox.h>

@interface YGTabBarController () <UITabBarControllerDelegate>

@end

@implementation YGTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}


-(void)configUI {
    self.delegate = self;
    YGTabbar *myTabBar = [[YGTabbar alloc] init];
    myTabBar.tintColor = KCOLOR_SELET;
    myTabBar.translucent = NO;
    myTabBar.layer.masksToBounds = NO;
    myTabBar.layer.shadowOffset = CGSizeMake(0, -3);
    myTabBar.layer.shadowRadius = 5;
    myTabBar.layer.shadowOpacity = 0.15;
    myTabBar.shadowImage = [UIImage imageNamed:@"tranimg"];
    myTabBar.backgroundImage = [UIImage imageNamed:@"tranimg"];
    
    [self setValue:myTabBar forKey:@"tabBar"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //取出plist里大数组
    NSString    *plistFile = [[NSBundle mainBundle]pathForResource:@"tabbar" ofType:@"plist"];
    NSArray *tabbarArray = [NSArray arrayWithContentsOfFile: plistFile];
    //装4个navi的数组
    NSMutableArray *viewControllersArray = [[NSMutableArray alloc] init];
    //循环取item数据
    for (NSDictionary *tabbarItemDic in tabbarArray) {
        UIImage *nomalImage = [[UIImage imageNamed:tabbarItemDic[@"normalImage"]]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage *selectedImage = [[UIImage imageNamed:tabbarItemDic[@"selectedImage"]]
                                  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem *tabbarItem = [[UITabBarItem alloc]initWithTitle:tabbarItemDic[@"title"]
                                                                image:nomalImage selectedImage:selectedImage];
        
        //根据字符串创建控制器
        Class controllerClass = NSClassFromString(tabbarItemDic[@"viewController"]);
        UIViewController *viewController = [[controllerClass alloc] init];
        viewController.tabBarItem = tabbarItem;
        
        YGNavigationController *navigationController = [[YGNavigationController alloc]initWithRootViewController:viewController];
        [viewControllersArray addObject:navigationController];
        
    }
    
    //把装navi的数组赋给tabbar的viewcontrollers
    self.viewControllers = viewControllersArray;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    AudioServicesPlaySystemSound(1104);
    if (viewController==self.viewControllers.lastObject) {
        [YGAlertView showAlertWithTitle:@"是否要拨打客服电话?"
                      buttonTitlesArray:@[@"YES", @"NO"]
                      buttonColorsArray:@[[UIColor blueColor],
                                          [UIColor redColor]] handler:nil];
        return NO;
    } else {
        return YES;
    }
}



//// 哪些页面支持自动转屏
//- (BOOL)shouldAutorotate
//{
//    
//    UINavigationController *nav = self.viewControllers[self.selectedIndex];
//    // MoviePlayerViewController 、ZFTableViewController 控制器支持自动转屏
//    if ([nav.topViewController isKindOfClass:[RecordViewController class]])
//    {
//        // 调用ZFPlayerSingleton单例记录播放状态是否锁定屏幕方向
//        return !ZFPlayerShared.isLockScreen;
//    }
//    return NO;
//}
//
//// viewcontroller支持哪些转屏方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    
//    UINavigationController *nav = self.viewControllers[self.selectedIndex];
//    if ([nav.topViewController isKindOfClass:[RecordViewController class]])
//    { // MoviePlayerViewController这个页面支持转屏方向
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    }
//    // 其他页面
//    return UIInterfaceOrientationMaskPortrait;
//}

@end
