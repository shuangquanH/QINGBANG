//
//  SQDecorationDetailStateHeadView.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationDetailStateHeadView.h"
#import "UILabel+SQAttribut.h"

@implementation SQDecorationDetailStateHeadView
{
    UILabel *_stateLab;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _stateLab = [UILabel labelWithFont:KSCAL(38) textColor:kCOLOR_666];
        [self addSubview:_stateLab];
        
        [_stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)configOrderInfo:(WKDecorationOrderDetailModel *)orderInfo {
    _stateLab.text = orderInfo.orderTitle;
    [_stateLab appendImage:[UIImage imageNamed:@"orderdetails_left_header"] withType:SQAppendImageInLeft];
    [_stateLab appendImage:[UIImage imageNamed:@"orderdetails_right_header"] withType:SQAppendImageInRight];
}

- (CGSize)viewSize {
    return CGSizeMake(kScreenW, KSCAL(110));
}

@end
