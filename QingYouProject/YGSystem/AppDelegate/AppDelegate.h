//
//  AppDelegate.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/7/27.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ReceivePushState)
{
    ReceivePushStateNone,
    ReceivePushStateDeadClickPush,
    ReceivePushStateBackgroundClickPush,
    ReceivePushStateForeground,
};

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) ReceivePushState pushState;
- (void)clickPushAction;


@end

