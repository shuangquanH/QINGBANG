//
//  YGAnimatePlayerOperation.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 2016/10/12.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGAnimatePlayerView.h"

@interface YGAnimatePlayerOperation : NSOperation

+(instancetype)animationWithType:(int)type superView:(UIView *)superView;

@property (nonatomic,assign) int type;
@property (nonatomic,strong) UIView * superView;

@end
