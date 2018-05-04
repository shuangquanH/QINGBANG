//
//  YGAnimatePlayer.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 2016/10/12.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGAnimatePlayer : NSObject

@property (nonatomic,strong) NSOperationQueue * queue;

-(void)animateWithType:(int)type superView:(UIView *)superView;

@end
