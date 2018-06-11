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
    
    UIView *_contactServiceTriangleView;
    UIView *_applySaleTriangleView;
    
    CAShapeLayer *_contactServiceLayer;
    CAShapeLayer *_applySaleLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = kCOLOR_RGB(210, 211, 212);
    }
    return self;
}

- (void)click_button:(UIButton *)sender {
    if (self.serviceBlock) {
        
        if (sender == _applySaleBtn) {
            if (_applySaleTriangleView.hidden) {
                _applySaleTriangleView.hidden = NO;
                _contactServiceTriangleView.hidden = YES;
                [_contactServiceBtn setTitleColor:kCOLOR_666 forState:UIControlStateNormal];
                [sender setTitleColor:KCOLOR_MAIN forState:UIControlStateNormal];
            }
        }
        else {
            if (_contactServiceTriangleView.hidden) {
                _applySaleTriangleView.hidden = YES;
                _contactServiceTriangleView.hidden = NO;
                [_applySaleBtn setTitleColor:kCOLOR_666 forState:UIControlStateNormal];
                [sender setTitleColor:KCOLOR_MAIN forState:UIControlStateNormal];
            }
        }
        self.serviceBlock(sender.tag);
    }
}



- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {
    if (!_contactServiceBtn) {
        _contactServiceBtn = [UIButton buttonWithTitle:@"联系客服" titleFont:KSCAL(38) titleColor:kCOLOR_333];
        _contactServiceBtn.backgroundColor = [UIColor whiteColor];
        [_contactServiceBtn setTitleColor:KCOLOR_MAIN forState:UIControlStateSelected];
        _contactServiceBtn.tag = 0;
        [_contactServiceBtn addTarget:self action:@selector(click_button:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_contactServiceBtn];
        
        _contactServiceTriangleView = [UIView new];
        _contactServiceTriangleView.backgroundColor = KCOLOR_MAIN;
        _contactServiceLayer = [CAShapeLayer layer];
        _contactServiceTriangleView.layer.mask = _contactServiceLayer;
        [self addSubview:_contactServiceTriangleView];
    }
    

    if (orderInfo.orderState == 5) {//订单完成，展示售后
        
        if (!_applySaleBtn) {
            _applySaleBtn = [UIButton buttonWithTitle:@"申请售后" titleFont:KSCAL(38) titleColor:kCOLOR_333];
            [_applySaleBtn setTitleColor:KCOLOR_MAIN forState:UIControlStateSelected];
            _applySaleBtn.tag = 1;
            _applySaleBtn.backgroundColor = [UIColor whiteColor];
            [_applySaleBtn addTarget:self action:@selector(click_button:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_applySaleBtn];
            
            _applySaleTriangleView = [UIView new];
            _applySaleTriangleView.backgroundColor = KCOLOR_MAIN;
            _applySaleLayer = [CAShapeLayer layer];
            _applySaleTriangleView.layer.mask = _applySaleLayer;
            [self addSubview:_applySaleTriangleView];
        }
        
        _applySaleTriangleView.hidden = YES;
        _applySaleBtn.hidden = NO;
        
        [_contactServiceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.top.mas_equalTo(KSCAL(10.0));
        }];
        
        [_applySaleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(KSCAL(10.0));
        }];
        
        [@[_contactServiceBtn, _applySaleBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1.0 leadSpacing:0 tailSpacing:0];
        
        [_applySaleTriangleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.equalTo(_applySaleBtn);
            make.height.mas_equalTo(KSCAL(20));
        }];
        
        [_contactServiceTriangleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.equalTo(_contactServiceBtn);
            make.height.mas_equalTo(KSCAL(20));
        }];
        
        CGFloat itemW = (kScreenW - 1) / 2.0;
        UIBezierPath *contactPath = [UIBezierPath bezierPath];
        [contactPath moveToPoint:CGPointZero];
        [contactPath addLineToPoint:CGPointMake(itemW, 0)];
        [contactPath addLineToPoint:CGPointMake(itemW, KSCAL(10))];
        [contactPath addLineToPoint:CGPointMake(itemW / 2.0 + KSCAL(8), KSCAL(10))];
        [contactPath addLineToPoint:CGPointMake(itemW / 2.0, KSCAL(20))];
        [contactPath addLineToPoint:CGPointMake(itemW / 2.0 - KSCAL(8), KSCAL(10))];
        [contactPath addLineToPoint:CGPointMake(0, KSCAL(10))];
        [contactPath addLineToPoint:CGPointZero];
        _contactServiceLayer.path = contactPath.CGPath;
        _applySaleLayer.path      = contactPath.CGPath;
        _contactServiceTriangleView.layer.mask = _contactServiceLayer;

    }
    else {
        _applySaleBtn.hidden = YES;
        _applySaleTriangleView.hidden = YES;
        
        [_contactServiceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(KSCAL(10), 0, 0, 0));
        }];
        
        [_contactServiceTriangleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.equalTo(_contactServiceBtn);
            make.height.mas_equalTo(KSCAL(20));
        }];
        
        CGFloat itemW = kScreenW;
        UIBezierPath *contactPath = [UIBezierPath bezierPath];
        [contactPath moveToPoint:CGPointZero];
        [contactPath addLineToPoint:CGPointMake(itemW, 0)];
        [contactPath addLineToPoint:CGPointMake(itemW, KSCAL(10))];
        [contactPath addLineToPoint:CGPointMake(itemW / 2.0 + KSCAL(8), KSCAL(10))];
        [contactPath addLineToPoint:CGPointMake(itemW / 2.0, KSCAL(20))];
        [contactPath addLineToPoint:CGPointMake(itemW / 2.0 - KSCAL(8), KSCAL(10))];
        [contactPath addLineToPoint:CGPointMake(0, KSCAL(10))];
        [contactPath addLineToPoint:CGPointZero];
        _contactServiceLayer.path = contactPath.CGPath;
        _contactServiceTriangleView.layer.mask = _contactServiceLayer;
    }
    
    _contactServiceTriangleView.hidden = NO;
    _contactServiceBtn.hidden = NO;
    [_contactServiceBtn setTitleColor:KCOLOR_MAIN forState:UIControlStateNormal];
}

- (CGSize)viewSize {
    return CGSizeMake(kScreenW, KSCAL(98));
}

@end
