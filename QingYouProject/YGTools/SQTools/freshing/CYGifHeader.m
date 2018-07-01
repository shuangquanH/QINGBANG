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
    [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {//20*25
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    
    // 设置下拉的时候的图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=10; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_animation_load_%zd", i]];//60张
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    
    //设置刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=10; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_animation_load_%zd", i]];//3张
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    
    // 设置刷新完毕状态的动画图片
    NSMutableArray *endfreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=10; i++) {
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
