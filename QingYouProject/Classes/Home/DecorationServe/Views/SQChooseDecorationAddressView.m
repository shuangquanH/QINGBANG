//
//  SQChooseDecorationAddressView.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQChooseDecorationAddressView.h"
#import "UIButton+SQImagePosition.h"
#import "NSMutableAttributedString+AppendImage.h"


#define KSPACE 20

@implementation SQChooseDecorationAddressView {
    UILabel    *addAddressButton;
    
    UILabel *nameLabel;
    UILabel *phoneLabel;
    UILabel *cityLabel;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = KCOLOR_WHITE;
        addAddressButton = [UILabel labelWithFont:KSCAL(32) textColor:kCOLOR_333];
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:@"新建地址 "];
        [attstr appendImage:[UIImage imageNamed:@"go_gray"] withType:SQAppendImageInRight];
        addAddressButton.attributedText = attstr;
        addAddressButton.userInteractionEnabled = YES;
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.font = KFONT(28);
        nameLabel.textColor = kCOLOR_999;
        
        phoneLabel = [[UILabel alloc] init];
        phoneLabel.font = KFONT(28);
        phoneLabel.textColor = kCOLOR_999;
        
        cityLabel = [[UILabel alloc] init];
        cityLabel.font = KFONT(28);
        cityLabel.textColor = kCOLOR_999;
    }
    return self;
}

- (void)setModel:(WKInvoiceAddressModel *)model {
    _model = model;
    if (model.ID) {
        [addAddressButton removeFromSuperview];
        [self addSubview:nameLabel];
        [self addSubview:phoneLabel];
        [self addSubview:cityLabel];
        
        nameLabel.text = model.name;
        phoneLabel.text = model.phone;
        cityLabel.text = [NSString stringWithFormat:@"%@ %@ %@", model.provName, model.cityName, model.detail];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KSPACE);
            make.top.mas_equalTo(KSPACE);
        }];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel);
            make.left.equalTo(nameLabel.mas_right).offset(KSPACE);
        }];
        
        [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom).offset(KSPACE);
            make.bottom.equalTo(self).offset(-KSPACE);
        }];
    } else {
        [nameLabel removeFromSuperview];
        [phoneLabel removeFromSuperview];
        [cityLabel removeFromSuperview];
        [self addSubview:addAddressButton];
        
        [addAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.top.equalTo(self).offset(KSPACE);
            make.bottom.equalTo(self).offset(-KSPACE);
        }];
    }

    [self layoutIfNeeded];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
