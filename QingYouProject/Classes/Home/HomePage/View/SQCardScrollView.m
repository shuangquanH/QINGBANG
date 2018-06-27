//
//  SQCardScrollView.m
//  SQAPPSTART
//
//  Created by qwuser on 2018/5/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SQCardScrollView.h"

@implementation SQCardScrollView

- (void)setItemArr:(NSArray *)itemarr
         alongAxis:(SQSAxisType)axistype
           spacing:(CGFloat)space
         leadSpace:(CGFloat)lead
         tailSpace:(CGFloat)tail
          itemSize:(CGSize) itemsize {
    
    UIView  *contentview = [[UIView alloc] init];
    contentview.backgroundColor = colorWithTable;
    
    [self addSubview:contentview];
    
    [contentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.equalTo(self);
    }];
    
    
    for (UIView *view in itemarr) {
        [contentview addSubview:view];
    }
    MASAxisType type = (axistype==SQSAxisTypeVertical)?MASAxisTypeVertical:MASAxisTypeHorizontal;
    [itemarr mas_distributeViewsAlongAxis:type withFixedSpacing:space leadSpacing:lead tailSpacing:tail];
    [itemarr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentview);
        make.size.mas_equalTo(itemsize);
    }];
    
    [self setShowsHorizontalScrollIndicator:NO];
    
}

@end
