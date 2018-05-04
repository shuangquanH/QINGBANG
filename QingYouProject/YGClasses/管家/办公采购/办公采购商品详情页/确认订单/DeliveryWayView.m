//
//  DeliveryWayView.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "DeliveryWayView.h"


@interface DeliveryWayView ()
/** 左侧标语  */
@property (nonatomic,strong) UILabel * leftTitleLabel;
/** 右侧内容  */
@property (nonatomic,strong) UILabel * rightTitleLabel;
/** 顶部线  */
@property (nonatomic,strong) UIView * lineTop;
/** 底部线  */
@property (nonatomic,strong) UIView * lineBottom;
@end

@implementation DeliveryWayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.leftTitleLabel = [UILabel ld_labelWithTextColor:kBlackColor textAlignment:NSTextAlignmentLeft font:LDFont(14) numberOfLines:0];
        [self addSubview:self.leftTitleLabel];
        
        self.rightTitleLabel = [UILabel ld_labelWithTextColor:kBlackColor textAlignment:NSTextAlignmentRight font:LDFont(14) numberOfLines:0];
        [self addSubview:self.rightTitleLabel];
        
        self.lineTop = [[UIView alloc] initWithFrame:CGRectMake(LDHPadding, 0, self.ld_width - 2 * LDHPadding, 0.5)];
        [self addSubview:self.lineTop];
        self.lineBottom = [[UIView alloc] initWithFrame:CGRectMake(LDHPadding, self.ld_height - 0.5, self.ld_width - 2 * LDHPadding, 0.5)];
        [self addSubview:self.lineBottom];
        
        
        [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(LDHPadding);
            make.top.equalTo(self.lineTop.mas_bottom);
            make.bottom.equalTo(self.lineBottom.mas_top);
        }];
        
        [self.rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-LDHPadding);
            make.top.equalTo(self.lineTop.mas_bottom);
            make.bottom.equalTo(self.lineBottom.mas_top);
            make.left.equalTo(self.leftTitleLabel.mas_right);
        }];
        
    }
    return self;
}
#pragma mark - 左右两侧文字颜色相同
- (void)reloadDataWithLetfTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle lineTopColor:(UIColor *)lineTopColor lineBottomColor:(UIColor *)lineBottomColor{
    
    
    self.rightTitleLabel.text = rightTitle;
    self.leftTitleLabel.text = leftTitle;
    
    self.lineTop.backgroundColor = lineTopColor;
    self.lineBottom.backgroundColor = lineBottomColor;
    
   
}

#pragma mark - 可定制左右两侧文字颜色
- (void)reloadDataWithLetfTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle leftColor:(UIColor *)leftColor rightColor:(UIColor *)rightColor{
    
    //    self.rightTitleLabel.font = LDFont(12);
    //    self.leftTitleLabel.font = LDFont(12);
    
    
   
    self.rightTitleLabel.textColor = rightColor;
    self.leftTitleLabel.textColor = leftColor;
    
    self.lineTop.backgroundColor = kClearColor;
    self.lineBottom.backgroundColor = kClearColor;
    self.rightTitleLabel.text = rightTitle;
    self.leftTitleLabel.text = leftTitle;

    
}

/** 富文本 */
- (void)reloadDataWithAttributedTextLetfTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle lineTopColor:(UIColor *)lineTopColor lineBottomColor:(UIColor *)lineBottomColor{
    
    NSRange range = [rightTitle rangeOfString:@"("];
    self.leftTitleLabel.text = leftTitle;

  
    
    self.lineTop.backgroundColor = kClearColor;
    self.lineBottom.backgroundColor = kClearColor;
    
    self.rightTitleLabel.attributedText = [rightTitle ld_attributedStringFromNSString:rightTitle startLocation:range.location forwardFont:LDFont(14) backFont:LDFont(14) forwardColor:kBlackColor backColor:LD9ATextColor];
    
}

@end
