//
//  SQChooseDecorationAddressView.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQChooseDecorationAddressView.h"
#import "UIButton+SQImagePosition.h"

@implementation SQChooseDecorationAddressView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        UIButton    *addAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addAddressButton addTarget:self action:@selector(taped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addAddressButton];
        [addAddressButton setTitle:@"新建地址" forState:UIControlStateNormal];
        [addAddressButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        [addAddressButton setImage:[UIImage imageNamed:@"unfold_btn_gray"] forState:UIControlStateNormal];
        [addAddressButton sq_setImagePosition:SQImagePositionRight spacing:KSCAL(33)];
        
        [addAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.top.equalTo(self).offset(KSCAL(40));
            make.bottom.equalTo(self).offset(-KSCAL(40));
        }];
        
    }
    return self;
}

- (void)setModel:(SQDecorationAddressModel *)model {
    _model = model;
    
}

- (void)taped {
    if (self.model) {
        //修改
        [self.delegate tapedAddressWithType:YES];
    } else {
        //新建
        [self.delegate tapedAddressWithType:NO];
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
