//
//  ChooseGoodsChildView.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ChooseGoodsChildView.h"





@interface ChooseGoodsChildView ()
/** 选中Button  */
@property (nonatomic,strong) UIButton * selectButton;
/** 背景View  */
@property (nonatomic,strong) UIView * backView;
/** titleLabel  */
@property (nonatomic,strong) UILabel * titleLabel;
/** 内容View  */
@property (nonatomic,strong) UIView * contentView;
/** 标题  */
@property (nonatomic,strong) NSString * title;
/** 选项数组  */
@property (nonatomic,strong) NSMutableArray * contentArray;
@end


@implementation ChooseGoodsChildView

-(instancetype)initWithTitle:(NSString *)title contentArray:(NSArray *)contentArray andFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.title = title;
        self.contentArray = [contentArray mutableCopy];
        
        //背景View
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
        [self addSubview:self.backView];
        
        //标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding, LDVPadding / 2, kScreenW, 25)];
        self.titleLabel.font = LDFont(15);
        [self.backView addSubview:self.titleLabel];
        
        //选项内容背景View
        CGFloat contentViewY = CGRectGetMaxY(self.titleLabel.frame);
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, contentViewY, kScreenW, 4 * LDVPadding)];
        
        [self.backView addSubview:self.contentView];
        
        
        self.backgroundColor = LDEFPaddingColor;
        self.backView.backgroundColor = kWhiteColor;
        self.contentView.backgroundColor = kWhiteColor;

        
        [self setupUI];
     

    }
    return self;
    
    
}
- (void)setupUI{
   
    
    float contentViewRowW = 0;//contentView一行中多个选项Button 和 padding 的总宽度
    float contentViewH = 0;//contentView多个选项Button 和 padding 的总高度
    int rowCount = 0;//记录这是contentView第几行

    for (int i = 0; i < self.contentArray.count; i++) {
        NSString * tagNameString = self.contentArray[i];
        //创建 选项Button
        UIButton * tagButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:tagNameString selectedTitle:tagNameString normalTitleColor:LD9ATextColor selectedTitleColor:LDMainColor backGroundColor:kWhiteColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:13];
        tagButton.layer.cornerRadius = 5;
        tagButton.layer.masksToBounds = YES;
        tagButton.layer.borderColor = LD9ATextColor.CGColor;
        tagButton.layer.borderWidth = 1;
        [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        //计算选项Button Size
        NSDictionary * dict = [NSDictionary dictionaryWithObject:LDFont(13) forKey:NSFontAttributeName];
        CGSize tagButtonSize = [tagNameString sizeWithAttributes:dict];
        tagButton.width = tagButtonSize.width + 15;
        tagButton.height = tagButtonSize.height + 12;

        //计算选项Button X Y
        //如果该Button的宽度 + 上一个 button的宽度大于屏幕宽 = 换行

        if (i == 0) {//只有一个选项,超出屏幕不处理
            
            tagButton.x = LDHPadding;
            contentViewRowW += CGRectGetMaxX(tagButton.frame);

        }else{//多个选项

            contentViewRowW += CGRectGetMaxX(tagButton.frame) + LDHPadding;

            if (contentViewRowW > kScreenW) {
                
                rowCount ++;
                tagButton.x = LDHPadding;
                contentViewRowW = CGRectGetMaxX(tagButton.frame);

            }else {
                
                tagButton.x += contentViewRowW - tagButton.width;
            }
        }
        
        tagButton.y += rowCount * (tagButton.height + LDVPadding) + LDVPadding;
        
        contentViewH = CGRectGetMaxY(tagButton.frame) + LDVPadding;
        
        [self.contentView addSubview:tagButton];
        
        tagButton.tag = 100 + i;
        if (i == 0) {
            
            self.selectButton = tagButton;
            self.selectButton.selected = YES;
        }
    
    }
    
    self.contentView.height = contentViewH;
    self.backView.height = self.contentView.height + CGRectGetMaxY(self.titleLabel.frame);
    self.height = self.backView.height + 0.5;
    
    [self reloadData];
//    self.backgroundColor = kYellowColor;
//    self.backView.backgroundColor = kRedColor;
//    self.contentView.backgroundColor = kGrayColor;
    
    
   
}

- (void)reloadData{
    self.titleLabel.text = self.title;
    
    
}
- (void)tagButtonClick:(UIButton *)tagButton{
    if (tagButton == self.selectButton) {
        return;
    }
    //取消原来选中
    self.selectButton.selected = !self.selectButton.selected;
    self.selectButton.layer.borderColor = LD9ATextColor.CGColor;
    //选中当前
    tagButton.selected = !tagButton.selected;
    tagButton.layer.borderColor = LDMainColor.CGColor;
    self.selectButton = tagButton;
    NSNumber * buttonTag = [NSNumber numberWithInt:(int)tagButton.tag];
    NSNumber * buttonFatherViewTag = [NSNumber numberWithInt:(int)self.tag];
    NSArray * arr = @[buttonTag,buttonFatherViewTag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:arr];
}

@end























