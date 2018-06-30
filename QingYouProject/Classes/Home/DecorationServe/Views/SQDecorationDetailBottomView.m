//
//  SQDecorationDetailBottomView.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationDetailBottomView.h"
#import "UIButton+SQImagePosition.h"
#import "SQCallPhoneFunction.h"

@implementation SQDecorationDetailBottomView {
//    UIButton    *collectBtn;
    UIButton    *contactBtn;
    SQBaseImageView *rightLine;
    UIButton    *payButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KCOLOR_MAIN;
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, -3);
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.15;
        
        
//        collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
//        collectBtn.titleLabel.font = KFONT(20);
//        collectBtn.titleLabel.textColor = kGrayColor;
//        [collectBtn setImage:[UIImage imageNamed:@"Details_page_tab__icon1"] forState:UIControlStateNormal];
//        [collectBtn setImage:[UIImage imageNamed:@"Details_page_tab__icon1_down"] forState:UIControlStateSelected];
//        [self addSubview:collectBtn];
//        [collectBtn setTitleColor:kGrayColor forState:UIControlStateNormal];
//        [collectBtn sq_setImagePosition:SQImagePositionTop spacing:2];
        
        
        contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [contactBtn setTitle:@"咨询" forState:UIControlStateNormal];
        contactBtn.titleLabel.font = KFONT(20);
        [contactBtn setTitleColor:KCOLOR_WHITE forState:UIControlStateNormal];
        [contactBtn setImage:[UIImage imageNamed:@"Details_page_tab__icon2"] forState:UIControlStateNormal];
        [self addSubview:contactBtn];
        
        [contactBtn sq_setImagePosition:SQImagePositionTop spacing:2];
        
        
        
//        SQBaseImageView *lefLine = [[SQBaseImageView alloc] init];
//        lefLine.image = [UIImage imageNamed:@"tab_line"];
//        [self addSubview:lefLine];
//        [lefLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(collectBtn.mas_right);
//            make.centerY.equalTo(collectBtn);
//        }];

        payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        payButton.userInteractionEnabled = NO;
        [payButton setTitle:@"立即预定" forState:UIControlStateNormal];
        [payButton setTitleColor:KCOLOR_WHITE forState:UIControlStateNormal];
        payButton.titleLabel.font = KFONT(30);
        [self addSubview:payButton];
        
        rightLine = [[SQBaseImageView alloc] init];
        rightLine.image = [UIImage imageNamed:@"tab_line"];
        [self addSubview:rightLine];
        
//        [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(KSCAL(20));
//            make.left.equalTo(self);
//            make.height.equalTo(self).offset(KSCAL(-20));
//            make.width.mas_equalTo(KSCAL(0));
//        }];
        
        
        [contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.top.mas_equalTo(6);
        }];

        [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(0);
        }];
        [@[contactBtn, payButton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0.0 leadSpacing:0 tailSpacing:0];

        
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.top.mas_equalTo(KSCAL(8));
            make.width.mas_equalTo(0.5);
        }];
        
//        [collectBtn addTarget:self action:@selector(collectionAction) forControlEvents:UIControlEventTouchUpInside];
        [contactBtn addTarget:self action:@selector(contactAction) forControlEvents:UIControlEventTouchUpInside];
        [payButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
- (void)setDetailModel:(SQDecorationDetailModel *)detailModel  {
    _detailModel = detailModel;
    if ([detailModel.isOnSale isEqualToString:@"yes"]) {
        rightLine.hidden = NO;
        payButton.backgroundColor = KCOLOR_MAIN;
        [payButton setTitle:@"立即预定" forState:UIControlStateNormal];
        payButton.userInteractionEnabled = YES;
    } else {
        rightLine.hidden = YES;
        payButton.backgroundColor = kCOLOR_999;
        [payButton setTitle:@"(已下架)立即预定" forState:UIControlStateNormal];
        payButton.userInteractionEnabled = NO;
    }
}
- (void)collectionAction {
//    if (self.delegate) {
//        [self.delegate clickedCollectionBtn];
//    }
}
- (void)contactAction {
    [SQCallPhoneFunction callServicePhoneWithPopver];
//    if (self.delegate) {
//        [self.delegate clickedContactButton];
//    }
}
- (void)payAction {
    if (self.delegate) {
        [self.delegate clickedPayButton];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
