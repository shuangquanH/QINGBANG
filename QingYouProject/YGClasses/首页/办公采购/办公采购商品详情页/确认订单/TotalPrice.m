//
//  TotalPrice.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "TotalPrice.h"
#import "NSString+SQAttributeString.h"



@interface TotalPrice ()
/** 顶部线  */
@property (nonatomic,strong) UIView * lineTop;
/** 底部线  */
@property (nonatomic,strong) UIView * lineBottom;
/** leftLabel  */
@property (nonatomic,strong) UILabel * leftLabel;
/** rightLabel  */
@property (nonatomic,strong) UILabel * rightLabel;
@end


@implementation TotalPrice

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineTop = [[UIView alloc] initWithFrame:CGRectMake(LDHPadding, 0, self.width - 2 * LDHPadding, 0.5)];
        [self addSubview:self.lineTop];
        self.lineBottom = [[UIView alloc] initWithFrame:CGRectMake(LDHPadding, self.height - 0.5, self.width - 2 * LDHPadding, 0.5)];
        [self addSubview:self.lineBottom];
        
        //左侧文字
        
        self.leftLabel = [UILabel labelWithFont:13 textColor:kBlackColor textAlignment:NSTextAlignmentLeft];
        [self addSubview:self.leftLabel];
        
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(LDHPadding);
            make.top.equalTo(self.lineTop.mas_bottom);
            make.bottom.equalTo(self.lineBottom.mas_top);
        }];
        
        //右侧文字
        self.rightLabel = [UILabel labelWithFont:13 textColor:kBlackColor textAlignment:NSTextAlignmentRight];
        [self addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.mas_right).offset(LDHPadding);
            make.top.equalTo(self.lineTop.mas_bottom);
            make.bottom.equalTo(self.lineBottom.mas_top);
            make.right.offset(-LDHPadding);
        }];
    }
    return self;
}
- (void)reloadDataWithLeftText:(NSString *)leftText rightText:(NSString *)rightText lineTopColor:(UIColor *)lineTopColor lineBottomColor:(UIColor *)lineBottomColor{
    
    self.lineTop.backgroundColor = lineTopColor;
    self.lineBottom.backgroundColor = lineBottomColor;
    self.rightLabel.text = rightText;

    NSRange range = [rightText rangeOfString:@"("];
    self.rightLabel.attributedText = [rightText attributedStringFromNSString:rightText startLocation:range.location forwardFont:LDFont(15) backFont:LDFont(12) forwardColor:LDFFTextColor backColor:LD9ATextColor];
    
    //左侧标题
    self.leftLabel.text = leftText;
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.offset([UILabel calculateWidthWithString:leftText textFont:LDFont(13) numerOfLines:0].width);
    }];
    
    
}
@end
