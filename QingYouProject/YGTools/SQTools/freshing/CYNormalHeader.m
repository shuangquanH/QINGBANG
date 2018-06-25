//
//  CYNormalHeader.m
//  学图
//
//  Created by Fly on 2017/3/14.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import "CYNormalHeader.h"

@implementation CYNormalHeader


- (void)prepare {
    [super prepare];
    self.lastUpdatedTimeLabel.hidden = YES;
//    self.stateLabel.hidden = YES;
    self.arrowView.alpha = 0.6;
    self.stateLabel.alpha = 0.6;
    
    [self setTitle:@"再拉一下就刷新啦~" forState:MJRefreshStateIdle];
    [self setTitle:@"松手就可以刷新啦@_@~" forState:MJRefreshStatePulling];
    [self setTitle:@"已经在刷新啦~^_^~" forState:MJRefreshStateRefreshing];

    
    
    
}

@end
