//
//  YGSingleton.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/2.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "NSString+SQJudge.h"

@implementation YGSingleton
{
    NSInteger  _totalTime;
}

+ (YGSingleton *)sharedManager
{
    static YGSingleton *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
    {
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
- (NSString *)servicePhoneNumber {
    BOOL isblank = [_servicePhoneNumber isBlankString];
    if (isblank||!_servicePhoneNumber) {
        return @"0571-87221111";
    } else {
        return _servicePhoneNumber;
    }
}
- (void)startTimerWithTime:(NSInteger)time;
{
    if(_totalTime == 0)
    {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        _totalTime = time;
        [self timerStart:timer];
    }
}

- (void)timerStart:(NSTimer *)timer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_TIMER_COUNT_DOWN object:nil userInfo:@{NC_TIMER_COUNT_DOWN:@(_totalTime)}];
    _totalTime --;
    if(_totalTime == 0) {
        [timer invalidate];
        timer = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_TIMER_FINISH object:nil userInfo:@{}];
    }
}


- (void)archiveUser {
    // 归档
    [[NSFileManager defaultManager] removeItemAtPath:USERFILEPATH error:nil];
    [NSKeyedArchiver archiveRootObject:self.user toFile:USERFILEPATH];
    [[NSUserDefaults standardUserDefaults] setObject:self.user.phone forKey:@"phone"];
}

- (void)deleteUser
{
    [[NSFileManager defaultManager] removeItemAtPath:USERFILEPATH error:nil];
    self.user = nil;
}

@end
