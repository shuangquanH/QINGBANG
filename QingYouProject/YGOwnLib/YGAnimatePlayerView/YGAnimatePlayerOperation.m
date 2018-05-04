//
//  YGAnimatePlayerOperation.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 2016/10/12.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGAnimatePlayerOperation.h"
#import "YGAnimatePlayerView.h"

@implementation YGAnimatePlayerOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

+(instancetype)animationWithType:(int)type superView:(UIView *)superView
{
    YGAnimatePlayerOperation *operation = [[YGAnimatePlayerOperation alloc]initWithType:type superView:superView];
    return operation;
}

- (instancetype)initWithType:(int)type superView:(UIView *)superView
{
    self = [super init];
    if (self) {
        
        _type = type;
        _executing = NO;
        _finished  = NO;
        _superView = superView;
    }
    return self;
}

-(void)start
{
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        NSArray *animationArray;
        float duration;
        if (_type == 0)
        {
            animationArray = @[[UIImage imageNamed:@"benye_beijingtu"]];
            duration = 1;
        }
        else
        {
            animationArray = @[[UIImage imageNamed:@"lubo_xuanzhongdingbudianzan"]];
            duration = 2;
        }
        YGAnimatePlayerView *playerView = [[YGAnimatePlayerView alloc]initWithAnimateArray:animationArray superView:_superView animateDuration:duration];
        [playerView animateWithCompleteBlock:^(BOOL finished) {
            self.finished = finished;
        }];
    }];

    
}

#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}
- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

@end
