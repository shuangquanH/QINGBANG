//
//  CYGifHeader.m
//  CYDemo
//
//  Created by Fly on 16/7/1.
//  Copyright © 2016年 Fly. All rights reserved.
//

#import "CYGifHeader.h"

@implementation CYGifHeader

- (void)prepare
{
    [super prepare];
    
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=32; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_animation_load_%zd", i]];//60张
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_animation_load_%zd", i]];//3张
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *endfreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_animation_load_%zd", i]];//3张
        [refreshingImages addObject:image];
    }
    [self setImages:endfreshingImages forState:MJRefreshStateRefreshing];
}

//- (void)placeSubviews {
//    [super placeSubviews];
//    self.gifView.contentMode = UIViewContentModeScaleToFill;
//}



@end
