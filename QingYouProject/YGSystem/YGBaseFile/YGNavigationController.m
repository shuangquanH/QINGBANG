//
//  YGNavigationController.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/2.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGNavigationController.h"

@interface YGNavigationController () <UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray       *showDefaultStatusBarControllerArr;

@end

@implementation YGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBar.barTintColor = kCOLOR_333;
    
    UIColor * color = [UIColor whiteColor];
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:color forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = dict;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSString *controlClass = NSStringFromClass([viewController class]);
    if ([self.showDefaultStatusBarControllerArr containsObject:controlClass]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count>0) {// 左边返回按钮
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 40, 40);
        backButton.backgroundColor = [UIColor clearColor];
        [backButton setImage:[UIImage imageNamed:@"home_back_icon"] forState:UIControlStateNormal];
        backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        backButton.imageView.clipsToBounds = YES;
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [backButton addTarget:self action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [viewController.navigationItem setLeftBarButtonItem:leftItem];
    }
    [super pushViewController:viewController animated:animated];
}
- (NSArray *)showDefaultStatusBarControllerArr {
    if (!_showDefaultStatusBarControllerArr) {
        _showDefaultStatusBarControllerArr = @[@"OfficePurchaseDetailViewController", @"SQChooseGardenVC"];
    }
    return _showDefaultStatusBarControllerArr;
}

@end
