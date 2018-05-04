//
//  LDVIPButton.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/10.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDVIPButton.h"

@interface LDVIPButton ()

@end

@implementation LDVIPButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle frame:(CGRect)rect{
    
    LDVIPButton * button = [LDVIPButton buttonWithType:buttonType];
    button.backgroundColor = kWhiteColor;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = LD9ATextColor.CGColor;
    button.layer.borderWidth = 1;
    button.frame = rect;
    UILabel * leftLable = [UILabel new];

    leftLable.font = LDFont(14);
    [button addSubview:leftLable];
    [leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.top.bottom.offset(0);
    }];

    UILabel * rightLable = [UILabel new];
    rightLable.font = LDFont(14);
    [button addSubview:rightLable];
    rightLable.textAlignment = NSTextAlignmentRight;
    [rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-LDHPadding);
        make.top.bottom.offset(0);
    }];
    
    button.leftLabel = leftLable;
    button.rightLable = rightLable;
    leftLable.text = leftTitle;
    rightLable.text = rightTitle;
    leftLable.highlightedTextColor = LDMainColor;
    leftLable.textColor = LD9ATextColor;
    rightLable.highlightedTextColor = LDMainColor;
    rightLable.textColor = LD9ATextColor;
    return button;
    
}

- (void)setSelected:(BOOL)selected{

    self.layer.borderColor = selected ? LDMainColor.CGColor : LD9ATextColor.CGColor;

    self.leftLabel.highlighted = selected;

    self.rightLable.highlighted = selected;

}
@end
