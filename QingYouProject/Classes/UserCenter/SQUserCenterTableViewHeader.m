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
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    _iconImageView = [UIImageView new];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.layer.cornerRadius = KSCAL(80);
    _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconImageView.layer.borderWidth = 1.5;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.userInteractionEnabled = YES;
    [_iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_icon)]];
    [self addSubview:_iconImageView];
    
    _nameLab = [UILabel labelWithFont:KSCAL(32) textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [self addSubview:_nameLab];
    
    _signLab = [UILabel labelWithFont:KSCAL(24) textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [self addSubview:_signLab];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0).priorityHigh();
        make.top.mas_equalTo(KSCAL(38));
        make.width.height.mas_equalTo(KSCAL(160));
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_iconImageView);
        make.left.mas_equalTo(KSCAL(60));
        make.top.equalTo(_iconImageView.mas_bottom).offset(KSCAL(16));
    }];
    
    [_signLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_iconImageView);
        make.left.mas_equalTo(KSCAL(60));
        make.top.equalTo(_nameLab.mas_bottom).offset(KSCAL(22));
    }];
}

- (void)tap_icon {
    if (self.tapToPersonalInfo) {
        self.tapToPersonalInfo();
    }
}

- (void)configUserInfo:(YGUser *)user {
    if (!user) {
        [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0).priorityHigh();
            make.width.height.mas_equalTo(KSCAL(160));
        }];
    } else {
        [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0).priorityHigh();
            make.top.mas_equalTo(KSCAL(38));
            make.width.height.mas_equalTo(KSCAL(160));
        }];
    }
    _nameLab.text = user.userName;
    _signLab.text = user.description;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:user.userImg] placeholderImage:[UIImage imageNamed:@"defaultavatar"]];
}

@end
