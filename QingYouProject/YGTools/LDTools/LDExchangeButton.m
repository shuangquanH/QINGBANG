//
//  LDExchangeButton.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDExchangeButton.h"

@implementation LDExchangeButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.ld_x = 0;
    
    self.imageView.ld_x = self.titleLabel.frame.size.width + 5;
    
}
- (void)setHighlighted:(BOOL)highlighted
{ // 只要重写了这个方法，按钮就无法进入highlighted状态
    
}

@end
