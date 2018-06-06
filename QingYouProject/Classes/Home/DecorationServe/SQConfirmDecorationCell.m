//
//  SQConfirmDecorationCell.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQConfirmDecorationCell.h"

#define KSPACE 20

@implementation SQConfirmDecorationCell {
    UIImageView *orderImage;
    UILabel *orderTitle;
    UILabel *orderDesc;
    UILabel *orderPrice;
    
    UILabel *payForPrice;//定金
    
    UILabel *totalPrice;//共计
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        orderImage = [[UIImageView alloc] init];
        orderImage.backgroundColor = [UIColor orangeColor];
        orderImage.contentMode = UIViewContentModeScaleAspectFill;
        orderImage.clipsToBounds = YES;
        [self addSubview:orderImage];
        
        orderTitle = [[UILabel alloc] init];
        orderTitle.font = KFONT(28.0);
        orderTitle.textColor = KCOLOR(@"666666");
        orderTitle.numberOfLines = 2;
        [self addSubview:orderTitle];
        
        orderDesc = [[UILabel alloc] init];
        orderDesc.font = KFONT(28.0);
        orderDesc.textColor = KCOLOR(@"666666");
        orderDesc.numberOfLines = 1;
        [self addSubview:orderDesc];
        
        orderPrice = [[UILabel alloc] init];
        orderPrice.font = KFONT(28.0);
        orderPrice.textColor = KCOLOR(@"333333");
        [self addSubview:orderPrice];
        
        
        
        [orderImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(KSPACE);
            make.top.equalTo(self).offset(KSPACE);
            make.width.mas_equalTo(KSCAL(240));
            make.height.mas_equalTo(KSCAL(180));
        }];
        
        [orderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(orderImage.mas_right).offset(KSCAL(KSPACE));
            make.top.equalTo(orderImage);
            make.right.equalTo(self).offset(-KSCAL(30));
        }];
        
        [orderDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(orderTitle);
            make.top.equalTo(orderTitle.mas_baseline).offset(KSCAL(KSPACE));
        }];
        
        [orderPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(orderTitle);
            make.bottom.equalTo(orderImage.mas_bottom);
        }];
        
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = kGrayColor;
        [self addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(KSPACE);
            make.right.equalTo(self).offset(-KSPACE);
            make.top.equalTo(orderImage.mas_bottom).offset(KSPACE);
            make.height.mas_equalTo(0.5);
        }];
        
        payForPrice = [[UILabel alloc] init];
        [self addSubview:payForPrice];
        payForPrice.text = @"定金:10元";
        payForPrice.textAlignment = NSTextAlignmentCenter;
        [payForPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(topLine);
            make.top.equalTo(topLine.mas_bottom);
            make.height.mas_equalTo(KSCAL(88));
        }];
        
        UIView *centerLine = [[UIView alloc] init];
        centerLine.backgroundColor = kGrayColor;
        [self addSubview:centerLine];
        [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(KSPACE);
            make.right.equalTo(self).offset(-KSPACE);
            make.top.equalTo(payForPrice.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        
        UILabel *beizhuLabel = [[UILabel alloc] init];
        [self addSubview:beizhuLabel];
        beizhuLabel.text = @"备注留言:";
        beizhuLabel.font = KFONT(28);
        beizhuLabel.textColor = kGrayColor;
        
        
        [beizhuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(KSPACE);
            make.top.equalTo(centerLine.mas_bottom);
            make.height.mas_equalTo(KSCAL(88));
        }];
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = kGrayColor;
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(KSPACE);
            make.right.equalTo(self).offset(-KSPACE);
            make.top.equalTo(beizhuLabel.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        totalPrice  = [[UILabel alloc] init];
        totalPrice.textAlignment = NSTextAlignmentCenter;
        [self addSubview:totalPrice];
        totalPrice.text = @"共计:10元";
        [totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(bottomLine.mas_bottom);
            make.height.mas_equalTo(KSCAL(88));
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        
    }
    return self;
}

@end


@implementation SQConfirmDecorationPayLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        
        
        UILabel *zhifubao = [[UILabel alloc] init];
        [self addSubview:zhifubao];
        zhifubao.text = @"支付宝支付";
        [zhifubao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(KSPACE);
            make.height.mas_equalTo(KSCAL(88));
        }];
        UIView  *topLine = [[UIView alloc] init];
        topLine.backgroundColor = kGrayColor;
        [self addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KSPACE);
            make.top.equalTo(zhifubao.mas_bottom);
            make.height.mas_equalTo(0.5);
            make.right.equalTo(self).offset(-KSPACE);
        }];
        UIButton    *zfbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [zfbBtn setImage:[UIImage imageNamed:@"snapup_customerservice_expression"] forState:UIControlStateNormal];
        [zfbBtn setImage:[UIImage imageNamed:@"snapup_customerservice_expression"] forState:UIControlStateSelected];
        [self addSubview:zfbBtn];
        [zfbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-KSPACE);
            make.centerY.equalTo(zhifubao);
            make.width.height.mas_equalTo(KSCAL(28));
        }];
        
        
        
        
        UILabel *weixin = [[UILabel alloc] init];
        [self addSubview:weixin];
        weixin.text = @"微信支付";
        [weixin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(zhifubao.mas_bottom);
            make.left.mas_equalTo(KSPACE);
            make.height.mas_equalTo(KSCAL(88));
        }];
        
        UIView  *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = kGrayColor;
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KSPACE);
            make.top.equalTo(weixin.mas_bottom);
            make.height.mas_equalTo(0.5);
            make.right.equalTo(self).offset(-KSPACE);
        }];
        
        UIButton    *wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [wxBtn setImage:[UIImage imageNamed:@"snapup_customerservice_expression"] forState:UIControlStateNormal];
        [wxBtn setImage:[UIImage imageNamed:@"snapup_customerservice_expression"] forState:UIControlStateSelected];
        [self addSubview:wxBtn];
        [wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-KSPACE);
            make.centerY.equalTo(weixin);
            make.width.height.mas_equalTo(KSCAL(28));
        }];
        
        
        
        
        
        UILabel *zhifudingjin = [[UILabel alloc] init];
        [self addSubview:zhifudingjin];
        zhifudingjin.text = @"支付定金:10元";
        [zhifudingjin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weixin.mas_bottom);
            make.left.mas_equalTo(KSPACE);
            make.height.mas_equalTo(KSCAL(88));
            make.bottom.equalTo(self);
        }];
        
        
        
        
        
        
        
        
        
    }
    return self;
}

@end





