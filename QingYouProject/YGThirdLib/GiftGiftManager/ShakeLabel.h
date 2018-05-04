//
//  ShakeLabel.h
//  presentAnimation
//
//  Created by 张楷枫 on 16/7/14.
//  Copyright © 2016年 张楷枫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShakeLabel : UILabel
// 动画时间
@property (nonatomic,assign) NSTimeInterval duration;
// 描边颜色
@property (nonatomic,strong) UIColor *borderColor;

- (void)startAnimWithDuration:(NSTimeInterval)duration;
@end
