//
//  YGNavigationController.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/2.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGNavigationController.h"

@interface YGNavigationController ()

@end

@implementation YGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = colorWithYGWhite;
    self.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.navigationBar.shadowImage = [UIImage imageNamed:@"tranimg"];
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"tranimg"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    //说明是第二级以上
    if (self.viewControllers.count >= 1)
    {
        if (self.viewControllers.count == 1)
        {
            viewController.hidesBottomBarWhenPushed = YES;
        }
        
        // 左边返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 40, 40);
        backButton.backgroundColor = [UIColor clearColor];
        [backButton setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        backButton.imageView.clipsToBounds = YES;
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        [backButton addTarget:viewController action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [viewController.navigationItem setLeftBarButtonItem:leftItem];
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
