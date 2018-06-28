//
//  IntegralView.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "IntegralView.h"
#import "NSString+SQAttributeString.h"




@interface IntegralView ()
/** 左侧标语  */
@property (nonatomic,strong) UILabel * leftTitleLabel;
/** 内容  */
@property (nonatomic,strong) UILabel * detailTitleLabel;
/** 顶部线  */
@property (nonatomic,strong) UIView * lineTop;
/** 底部线  */
@property (nonatomic,strong) UIView * lineBottom;

@end

@implementation IntegralView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.leftTitleLabel = [UILabel labelWithFont:14 textColor:kBlackColor textAlignment:NSTextAlignmentLeft];
        [self addSubview:self.leftTitleLabel];
        
        self.detailTitleLabel = [UILabel labelWithFont:12 textColor:kBlackColor textAlignment:NSTextAlignmentLeft];
        [self addSubview:self.detailTitleLabel];
        
        self.lineTop = [[UIView alloc] initWithFrame:CGRectMake(LDHPadding, 0, self.width - 2 * LDHPadding, 0.5)];
        [self addSubview:self.lineTop];
        self.lineBottom = [[UIView alloc] initWithFrame:CGRectMake(LDHPadding, self.height - 0.5, self.width - 2 * LDHPadding, 0.5)];
        [self addSubview:self.lineBottom];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:@"nochoice_btn_gray" selectedImage:@"choice_btn_green" normalTitle:nil selectedTitle:nil normalTitleColor:nil selectedTitleColor:nil backGroundColor:kWhiteColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:0];
        [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.rightButton];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-LDHPadding);
            make.centerY.offset(0);
            make.width.height.offset(25);
        }];
        
        [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(LDHPadding);
            make.top.equalTo(self.lineTop.mas_bottom);
            make.bottom.equalTo(self.lineBottom.mas_top);
        }];
        
        [self.detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTitleLabel.mas_right).offset(LDHPadding);
            make.centerY.offset(0);
            make.right.equalTo(self.rightButton.mas_left).offset(-5);
        }];
    }
    return self;
}
#pragma mark - 点击事件
- (void)rightButtonClick:(UIButton *)rightButton{
    
    rightButton.selected = !rightButton.selected;
    
    [self.delegate integralViewRightButtonDidClick:rightButton];
}
#pragma mark - 刷新数据
- (void)reloadDataWithLetfTitle:(NSString *)leftTitle detailTitle:(NSString *)detailTitle lineTopColor:(UIColor *)lineTopColor lineBottomColor:(UIColor *)lineBottomColor{
    
    self.lineTop.backgroundColor = lineTopColor;
    self.lineBottom.backgroundColor = lineBottomColor;
    
    self.leftTitleLabel.text = leftTitle;
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset([UILabel calculateWidthWithString:leftTitle textFont:LDFont(14) numerOfLines:1].width);
    }];
    
    
    NSRange range = [detailTitle rangeOfString:@"￥"];
    
    self.detailTitleLabel.attributedText = [detailTitle attributedStringFromNSString:detailTitle startLocation:range.location forwardFont:LDFont(12) backFont:LDFont(12) forwardColor:LD9ATextColor backColor:LDFFTextColor];
   
}
@end
