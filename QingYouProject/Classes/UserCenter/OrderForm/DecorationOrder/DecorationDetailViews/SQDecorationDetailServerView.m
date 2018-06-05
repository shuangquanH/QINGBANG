//
//  SQDecorationDetailServerView.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationDetailServerView.h"

@implementation SQDecorationDetailServerView
{
    UIButton *_contactServiceBtn;
    UIButton *_applySaleBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupSubviews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupSubviews {
    _contactServiceBtn = [UIButton new];
    _contactServiceBtn.tag = 0;
    [_contactServiceBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [_contactServiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_contactServiceBtn addTarget:self action:@selector(click_button:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_contactServiceBtn];
    
    _applySaleBtn = [UIButton new];
    _applySaleBtn.tag = 1;
    [_applySaleBtn setTitle:@"申请售后" forState:UIControlStateNormal];
    [_applySaleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_applySaleBtn addTarget:self action:@selector(click_button:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_applySaleBtn];
    
    [_contactServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
    }];
    
    [_applySaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.mas_equalTo(0);
    }];
    
    [@[_contactServiceBtn, _applySaleBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (void)click_button:(UIButton *)sender {
    if (self.serviceBlock) {
        self.serviceBlock(sender.tag);
    }
}

- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {
    
}

- (CGSize)viewSize {
    return CGSizeMake(kScreenW, 44);
}

@end
