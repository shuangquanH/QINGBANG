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
        self.backgroundColor = kCOLOR_RGB(210, 211, 212);
    }
    return self;
}

- (void)click_button:(UIButton *)sender {
    if (self.serviceBlock) {
        self.serviceBlock(sender.tag);
    }
}

- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {
    _contactServiceBtn = [UIButton buttonWithTitle:@"联系客服" titleFont:KSCAL(38) titleColor:kCOLOR_333];
    _contactServiceBtn.backgroundColor = [UIColor whiteColor];
    [_contactServiceBtn setTitleColor:KCOLOR_MAIN forState:UIControlStateSelected];
    _contactServiceBtn.tag = 0;
    [_contactServiceBtn addTarget:self action:@selector(click_button:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_contactServiceBtn];

    if (orderInfo.orderState == 5) {//订单完成，展示售后
        _applySaleBtn = [UIButton buttonWithTitle:@"申请售后" titleFont:KSCAL(38) titleColor:kCOLOR_333];
        [_applySaleBtn setTitleColor:KCOLOR_MAIN forState:UIControlStateSelected];
        _applySaleBtn.tag = 1;
        _applySaleBtn.backgroundColor = [UIColor whiteColor];
        [_applySaleBtn addTarget:self action:@selector(click_button:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_applySaleBtn];
        
        [_contactServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.top.mas_equalTo(KSCAL(10.0));
        }];
        
        [_applySaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(KSCAL(10.0));
        }];
        
        [@[_contactServiceBtn, _applySaleBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1.0 leadSpacing:0 tailSpacing:0];
    }
    else {
        [_contactServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(KSCAL(10), 0, 0, 0));
        }];
    }
}

- (CGSize)viewSize {
    return CGSizeMake(kScreenW, KSCAL(98));
}

@end
