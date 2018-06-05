//
//  SQDecorationDetailStateHeadView.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationDetailStateHeadView.h"

@implementation SQDecorationDetailStateHeadView
{
    UILabel *_stateLab;
    UIView *_line;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _line = [UIView new];
        _line.backgroundColor = colorWithLine;
        [self addSubview:_line];
        
        _stateLab = [UILabel labelWithFont:17.0 textColor:[UIColor blackColor]];
        [self addSubview:_stateLab];
        [_stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.left.mas_equalTo(15);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _line.frame = CGRectMake(0, self.height-1, self.width, 1);
}

- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {
    _stateLab.text = orderInfo.orderTitle;
}
- (CGSize)viewSize {
    return CGSizeMake(kScreenW, 55);
}

@end
