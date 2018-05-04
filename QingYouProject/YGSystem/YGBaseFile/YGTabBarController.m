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

@interface YGTabBarController ()

@end

@implementation YGTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)viewDidLayoutSubviews{
         YGSingletonMarco.tabBarHeight = self.tabBar.frame.size.height;
    
}
-(void)configUI
{
    YGTabbar *myTabBar = [[YGTabbar alloc] init];
    [self setValue:myTabBar forKey:@"tabBar"];

    //取出plist里大数组
    NSArray *tabbarArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"tabbar" ofType:@"plist"]];
    //装4个navi的数组
    NSMutableArray *viewControllersArray = [[NSMutableArray alloc]init];
    
    self.tabBar.tintColor = colorWithMainColor;
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YGUIColorFromRGB(0x888, 1),NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:12.0f],NSFontAttributeName,nil]forState:UIControlStateNormal];
//    self.tabBar.barTintColor = colorWithBlack;
    
    
    self.tabBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tabBar.layer.masksToBounds = NO;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -3);
    self.tabBar.layer.shadowRadius = 5;
    self.tabBar.layer.shadowOpacity = 0.15;
    self.tabBar.shadowImage = [UIImage imageNamed:@"tranimg"];
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tranimg"];

    
    //循环取item数据
    for (NSDictionary *tabbarItemDic in tabbarArray)
    {
        UIImage *nomalImage = [[UIImage imageNamed:tabbarItemDic[@"normalImage"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectedImage = [[UIImage imageNamed:tabbarItemDic[@"selectedImage"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *tabbarItem = [[UITabBarItem alloc]initWithTitle:tabbarItemDic[@"title"] image:nomalImage selectedImage:selectedImage];
        
        UIViewController *viewController = [[NSClassFromString(tabbarItemDic[@"viewController"]) alloc] init];
        viewController.tabBarItem = tabbarItem;
        
        YGNavigationController *navigationController = [[YGNavigationController alloc]initWithRootViewController:viewController];
        [viewControllersArray addObject:navigationController];
        
    }
    //把装navi的数组赋给tabbar的viewcontrollers
    
    self.viewControllers = viewControllersArray;
    
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
