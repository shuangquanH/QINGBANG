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
    UIImageView *_leftImageView;
    UIImageView *_rightImageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _leftImageView = [UIImageView new];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_leftImageView];
        
        _rightImageView = [UIImageView new];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_rightImageView];
        
        _stateLab = [UILabel labelWithFont:KSCAL(38) textColor:kCOLOR_666];
        [self addSubview:_stateLab];
        
        [_stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        
        [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_stateLab);
            make.right.equalTo(_stateLab.mas_left);
            make.width.height.mas_equalTo(KSCAL(50));
        }];
        
        [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_stateLab);
            make.left.equalTo(_stateLab.mas_right);
            make.width.height.mas_equalTo(KSCAL(50));
        }];
        
        _leftImageView.backgroundColor = KCOLOR_MAIN;
        _rightImageView.backgroundColor = KCOLOR_MAIN;
    }
    return self;
}


- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {
    _stateLab.text = orderInfo.orderTitle;
}

- (CGSize)viewSize {
    return CGSizeMake(kScreenW, KSCAL(110));
}

@end
