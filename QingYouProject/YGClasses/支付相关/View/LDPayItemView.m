//
//  LDPayItemView.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/12.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDPayItemView.h"




@interface LDPayItemView ()
/** 选中的coverButton  */
@property (nonatomic,strong) UIButton * selectedCoverButton;
/** 右侧选中的Button  */
@property (nonatomic,strong) UIButton * selectedRightCoverButton;
@end

@implementation LDPayItemView

- (instancetype)showPayItemViewWithY:(CGFloat)Y{
 
    CGFloat headerH = 40;
    CGFloat itemH = 60;
    CGFloat leftImageWH = 40;
    self.frame = CGRectMake(0, Y, kScreenW, 220);
    
    self.backgroundColor = kRedColor;
    //支付方式背景View
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, headerH)];
    header.backgroundColor = LDEFPaddingColor;
    [self addSubview:header];
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding, 0, kScreenW - 2 * headerH, headerH)];
    lable.textColor = LD9ATextColor;
    lable.text = @"支付方式";
    lable.font = LD15Font;
    [header addSubview:lable];
    
    NSArray * imageArr = @[@"pay_alipay",@"pay-wechat",@"pay_offline"];
    NSArray * titleArr = @[@"支付宝支付",@"微信支付",@"线下支付"];
    if(self.titleArry.count ==0)
        self.titleArry = [NSMutableArray arrayWithArray:titleArr];
    else
        self.frame = CGRectMake(0, Y, kScreenW, 220 - itemH);
    
    //支付宝
    for (int i = 0; i < self.titleArry.count; i++) {
        
        UIView * aliPayView = [[UIView alloc] initWithFrame:CGRectMake(0, headerH + i *itemH , kScreenW, itemH)];
        
        aliPayView.backgroundColor = kWhiteColor;
        [self addSubview:aliPayView];
        
        //左侧图片
        UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LDHPadding, LDVPadding, leftImageWH, leftImageWH)];
        leftImageView.userInteractionEnabled = YES;
        leftImageView.layer.cornerRadius = 5;
        leftImageView.layer.masksToBounds = YES;
//        leftImageView.backgroundColor = LDRandomColor;
        leftImageView.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@", imageArr[i]]];
        [aliPayView addSubview:leftImageView];

        UILabel * payTypelable = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding + leftImageWH + LDHPadding, 0, kScreenW - 4 * LDHPadding - leftImageWH, itemH)];
        payTypelable.font = LD15Font;
        NSString * titleString = titleArr[i];
        payTypelable.text = titleString;
        [aliPayView addSubview:payTypelable];

        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:@"" selectedTitle:@"" normalTitleColor:nil selectedTitleColor:nil backGroundColor:nil normalBackGroundImageStr:@"nochoice_btn_gray" selectedBackGroundImageStr:@"choice_btn_green" titleFont:0];
        rightButton.tag = 200 + i;
        rightButton.frame = CGRectMake(kScreenW - LDHPadding - 2 * LDVPadding, (itemH - 2 * LDVPadding) / 2, 2 * LDVPadding, 2 * LDVPadding);
        [aliPayView addSubview:rightButton];

        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(LDHPadding, itemH - 1, kScreenW - LDHPadding, 1)];
        bottomLine.backgroundColor = LDEEPaddingColor;
        [aliPayView addSubview:bottomLine];

        UIButton * coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        coverButton.frame = CGRectMake(0, 0, kScreenW, itemH);
        coverButton.tag = 100 + i;
        
        [coverButton addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [aliPayView addSubview:coverButton];

        if (i == 0) {
            
            self.selectedCoverButton = coverButton;
            self.selectedCoverButton.selected = YES;
            self.selectedRightCoverButton = rightButton;
            self.selectedRightCoverButton.selected = YES;
            
        }
    }
    
    
    return self;
}


- (void)coverButtonClick:(UIButton *)coverButton{
    
    if (self.selectedCoverButton == coverButton) {
        return;
    }
    //取消原来选中状态
    self.selectedCoverButton.selected = !self.selectedCoverButton.selected;
    self.selectedRightCoverButton.selected = !self.selectedRightCoverButton.selected;
    
    NSInteger tag = coverButton.tag;
    
    //取出右侧button,变为选中状态
    UIButton * rightButton =  (UIButton *)[self viewWithTag:tag + 100];
    rightButton.selected = !rightButton.selected;
    
  
    if (self.delegate) {
        
        [self.delegate payItemViewDidSelectedWitchItem:tag - 100];

    }

    self.selectedCoverButton = coverButton;
    self.selectedRightCoverButton = rightButton;
}

@end
