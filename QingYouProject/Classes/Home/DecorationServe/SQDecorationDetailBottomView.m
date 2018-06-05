//
//  SQDecorationDetailBottomView.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationDetailBottomView.h"
#import "UIButton+SQImagePosition.h"

@implementation SQDecorationDetailBottomView {
    UIButton    *collectBtn;
    UIButton    *contactBtn;
    UIButton    *payButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = colorWithMainColor;
        
        collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
        collectBtn.titleLabel.font = KFONT(22);
        [collectBtn setImage:[UIImage imageNamed:@"collect_icon_black"] forState:UIControlStateNormal];
        [self addSubview:collectBtn];
        collectBtn.layer.borderWidth = 1;
        collectBtn.layer.borderColor = kGrayColor.CGColor;
        
        
        contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [contactBtn setTitle:@"咨询" forState:UIControlStateNormal];
        contactBtn.titleLabel.font = KFONT(22);
        [contactBtn setImage:[UIImage imageNamed:@"service_black"] forState:UIControlStateNormal];
        [self addSubview:contactBtn];
        contactBtn.layer.borderWidth = 1;
        contactBtn.layer.borderColor = kGrayColor.CGColor;
        
        [collectBtn sq_setImagePosition:SQImagePositionBottom spacing:0];
        [contactBtn sq_setImagePosition:SQImagePositionBottom spacing:0];
        
        
        payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [payButton setTitle:@"支付定金" forState:UIControlStateNormal];
        [self addSubview:payButton];
        payButton.layer.borderWidth = 1;
        payButton.layer.borderColor = kGrayColor.CGColor;
        
        [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.height.equalTo(self);
            make.width.equalTo(collectBtn.mas_height);
        }];
        
        [contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(collectBtn.mas_right);
            make.top.height.width.equalTo(collectBtn);
        }];
        [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contactBtn.mas_right);
            make.right.equalTo(self);
            make.top.height.equalTo(contactBtn);
        }];
        
        
        [collectBtn addTarget:self action:@selector(collectionAction) forControlEvents:UIControlEventTouchUpInside];
        [contactBtn addTarget:self action:@selector(contactAction) forControlEvents:UIControlEventTouchUpInside];
        [payButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)collectionAction {
    if (self.delegate) {
        [self.delegate clickedCollectionBtn];
    }
}
- (void)contactAction {
    if (self.delegate) {
        [self.delegate clickedContactButton];
    }
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
