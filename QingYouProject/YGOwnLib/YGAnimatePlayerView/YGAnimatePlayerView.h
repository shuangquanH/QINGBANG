//
//  YGAnimatePlayerView.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 2016/10/12.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completeBlock)(BOOL finished);

@interface YGAnimatePlayerView : UIView

@property (nonatomic,strong) NSArray * animateArray;
@property (nonatomic,strong) UIView * superView;
@property (nonatomic,assign) float animateDuration;
@property (nonatomic,copy) void(^completeBlock)(BOOL finished);

- (instancetype)initWithAnimateArray:(NSArray *)animateArray superView:(UIView *)superView animateDuration:(float)animateDuration;

- (void)animateWithCompleteBlock:(completeBlock)completed;

@end
