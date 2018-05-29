//
//  YGTabbar.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/9/12.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGTabbar.h"

@implementation YGTabbar

- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIControl *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)tabBarButtonClick:(UIControl *)tabBarButton {
    for (UIView *imageView in tabBarButton.subviews) {
        [imageView showQAnimate];
    }
}

@end
