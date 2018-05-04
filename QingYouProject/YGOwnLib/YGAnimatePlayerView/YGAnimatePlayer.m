//
//  YGAnimatePlayer.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 2016/10/12.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGAnimatePlayer.h"
#import "YGAnimatePlayerOperation.h"

@implementation YGAnimatePlayer

-(void)animateWithType:(int)type superView:(UIView *)superView
{
    [self.queue addOperation:[YGAnimatePlayerOperation animationWithType:type superView:superView]];
}

-(NSOperationQueue *)queue
{
    if (!_queue)
    {
        _queue = [[NSOperationQueue alloc]init];
        _queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}

@end
