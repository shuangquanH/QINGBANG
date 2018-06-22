//
//  YGSingleton.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/2.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootViewController.h"

@class YGUser;

@interface YGSingleton : NSObject

//token
@property (nonatomic,strong) NSString * deviceToken;

@property (nonatomic, copy) NSString       *apiAddress;

//当前user
@property (nonatomic,strong) YGUser * user;

@property (nonatomic,strong) RootViewController * roadShowHallAddVideoViewController;

@property (nonatomic,strong) RootViewController * roadShowHallAddImageViewController;

//单例
+ (YGSingleton *)sharedManager;

//归档用户模型
- (void)archiveUser;

//退出登录删除用户模型
- (void)deleteUser;


//开始倒计时
- (void)startTimerWithTime:(NSInteger)time;
@end
