//
//  YGAnimatePlayerView.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 2016/10/12.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGAnimatePlayerView.h"



@implementation YGAnimatePlayerView
{
    UIImageView *_mainImageView;
}
- (instancetype)initWithAnimateArray:(NSArray *)animateArray superView:(UIView *)superView animateDuration:(float)animateDuration
{
    self = [super init];
    if (self)
    {
        _superView = superView;
        _animateArray = animateArray;
        _animateDuration = animateDuration;
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    self.frame = [UIScreen mainScreen].bounds;
    [_superView addSubview:self];
    [_superView sendSubviewToBack:self];
    
    _mainImageView = [[UIImageView alloc]initWithFrame:self.frame];
    _mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_mainImageView];
    
    
    _mainImageView.animationImages = _animateArray;
    _mainImageView.animationRepeatCount = 1;
    _mainImageView.animationDuration = _animateDuration;
    [_mainImageView startAnimating];
    
    [self performSelector:@selector(finishPlaying) withObject:nil afterDelay:_mainImageView.animationDuration];
}

-(void)finishPlaying
{
    [self removeFromSuperview];
    _completeBlock(YES);
}

-(void)animateWithCompleteBlock:(completeBlock)completed
{
    _completeBlock = completed;
}

@end
