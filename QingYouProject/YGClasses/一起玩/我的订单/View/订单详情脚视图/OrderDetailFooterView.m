//
//  OrderDetailFooterView.m
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/4.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderDetailFooterView.h"

@implementation OrderDetailFooterView
{
    UILabel * _personLabel;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = colorWithYGWhite;
        self.frame = CGRectMake(0, 1, YGScreenWidth, 40);
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
        line.backgroundColor = colorWithTable;
        [self addSubview:line];
        
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    UILabel * label = [[UILabel alloc] init];
    label.text = @"报名人信息";
    label.textColor = colorWithBlack;
    label.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(12.5);
    }];
    
    _personLabel = [[UILabel alloc] init];
    _personLabel.textColor = colorWithBlack;
    _personLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [self addSubview:_personLabel];
    [_personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12.5);
    }];
}

- (void)setPerson:(NSString *)person
{
    _person = person;
    _personLabel.text = person;
}
@end
