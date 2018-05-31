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
    self.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBar.barTintColor = kBlackColor;
    
    UIColor * color = [UIColor whiteColor];
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:color forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = dict;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count>0) {    
        viewController.hidesBottomBarWhenPushed = YES;
        // 左边返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 40, 40);
        backButton.backgroundColor = [UIColor clearColor];
        [backButton setImage:[UIImage imageNamed:@"popup_back_gray"] forState:UIControlStateNormal];
        backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        backButton.imageView.clipsToBounds = YES;
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [backButton addTarget:viewController action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [viewController.navigationItem setLeftBarButtonItem:leftItem];
    }
    
    
    [super pushViewController:viewController animated:animated];
}

@end
