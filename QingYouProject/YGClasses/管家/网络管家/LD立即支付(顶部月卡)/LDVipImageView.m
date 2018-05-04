//
//  LDVipImageView.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/12.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDVipImageView.h"


@interface LDVipImageView()
/** rightCardType  */
@property (nonatomic,strong) UIButton * rightCardTypeButton;
/** CardPrice  */
@property (nonatomic,strong) UILabel * cardPriceLabel;

@end

@implementation LDVipImageView

+ (instancetype)vipImageViewWithCardType:(NSString *)cardType andPrice:(NSString *)cardPrice frame:(CGRect)rect{
    
    LDVipImageView * vipImageView = [[LDVipImageView alloc] initWithFrame:rect];
  
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:vipImageView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    
    CAShapeLayer * layer = [[CAShapeLayer alloc] init];
    
    layer.frame = vipImageView.bounds;
    layer.path = path.CGPath;
    vipImageView.layer.mask = layer;
    
    vipImageView.rightCardTypeButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:@"月卡" selectedTitle:nil normalTitleColor:kWhiteColor selectedTitleColor:kWhiteColor backGroundColor:LDRGBColor(49, 46, 48) normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:12];
    
    [vipImageView addSubview:vipImageView.rightCardTypeButton];
    vipImageView.rightCardTypeButton.layer.cornerRadius = LDVPadding ;
    vipImageView.rightCardTypeButton.layer.masksToBounds = YES;
    [vipImageView.rightCardTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(LDVPadding);
        make.right.offset(-LDHPadding);
        make.height.offset(2 * LDVPadding);
        make.width.offset(5 * LDVPadding);
    }];
    
    vipImageView.cardPriceLabel = [UILabel new];
    vipImageView.cardPriceLabel.attributedText = [cardPrice ld_attributedStringFromNSString:cardPrice startLocation:1 forwardFont:[UIFont systemFontOfSize:10] backFont:[UIFont systemFontOfSize:14] forwardColor:[UIColor whiteColor] backColor:[UIColor whiteColor]];
    [vipImageView addSubview:vipImageView.cardPriceLabel];
    [vipImageView.cardPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(- 2 * LDVPadding);
        make.bottom.offset(- 2 * LDVPadding);
    }];
    
    
    return vipImageView;
}

@end
