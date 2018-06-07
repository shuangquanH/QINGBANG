//
//  SQDecorationDetailStagesView.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationDetailStagesView.h"

@implementation SQDecorationDetailStagesView
{
    UIView *_line;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _line = [UIView new];
        _line.backgroundColor = colorWithLine;
        [self addSubview:_line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _line.frame = CGRectMake(0, self.height-1, self.width, 1);
}

- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {
    
}

- (CGSize)viewSize {
    return CGSizeMake(kScreenW, 60);
}

@end
