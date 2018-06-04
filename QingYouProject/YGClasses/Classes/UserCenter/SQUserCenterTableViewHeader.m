//
//  SQUserCenterTableViewHeader.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/16.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQUserCenterTableViewHeader.h"

@implementation SQUserCenterTableViewHeader
{
    UIImageView *_iconImageView;
    UILabel *_nameLab;
    UILabel *_signLab;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = colorWithMainColor;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    _iconImageView = [UIImageView new];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.layer.cornerRadius = 40;
    _iconImageView.layer.masksToBounds = YES;
    [self addSubview:_iconImageView];
    
    _nameLab = [UILabel labelWithFont:15.0 textColor:[UIColor whiteColor]];
    [self addSubview:_nameLab];
    
    _signLab = [UILabel labelWithFont:14.0 textColor:[UIColor whiteColor]];
    [self addSubview:_signLab];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(80);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_iconImageView.mas_right).offset(10);
        make.bottom.equalTo(self->_iconImageView.mas_centerY).offset(-4);
    }];
    
    [_signLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_nameLab);
        make.top.equalTo(self->_iconImageView.mas_centerY).offset(4);
    }];
}

- (void)configUserInfo:(YGUser *)user {
    _nameLab.text = user.userName;
    _signLab.text = user.description;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:user.userImg] placeholderImage:[UIImage imageNamed:@"defaultavatar"]];
}

@end
