//
//  LDVerticalButton.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/9/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDVerticalButton.h"



@implementation LDVerticalButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.ld_y = 0;
    self.imageView.ld_centerX = self.ld_width * 0.5;
    
    self.titleLabel.ld_x = 0;
    self.titleLabel.ld_y = self.imageView.ld_bottom;
    self.titleLabel.ld_height = self.ld_height - self.titleLabel.ld_y;
    self.titleLabel.ld_width = self.ld_width;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = LDFont(12);
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self setTitleColor:[kBlackColor colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
}
- (void)setHighlighted:(BOOL)highlighted
{ // 只要重写了这个方法，按钮就无法进入highlighted状态
    
}
@end
