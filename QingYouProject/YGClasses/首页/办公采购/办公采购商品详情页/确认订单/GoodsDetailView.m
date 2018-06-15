//
//  GoodsDetailView.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "GoodsDetailView.h"

@interface GoodsDetailView ()

/** 商品图片  */
@property (nonatomic,strong) UIImageView * goodsImageView;
/** 商品名  */
@property (nonatomic,strong) UILabel * goodsNamelabel;
/** 商品单价  */
@property (nonatomic,strong) UILabel * goodsPrice;
/** 商品数量  */
@property (nonatomic,strong) UILabel * goodsCount;
/** 商品规格  */
@property (nonatomic,strong) UILabel * goodsRule;
@end

@implementation GoodsDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //图片
        self.goodsImageView = [UIImageView new];
        self.goodsImageView.layer.cornerRadius = 5;
        self.goodsImageView.clipsToBounds = YES;
        [self addSubview:self.goodsImageView];
        [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(LDHPadding);
            make.top.offset(LDVPadding);
            make.width.height.offset(80);
        }];
        //商品价格
        self.goodsPrice = [UILabel ld_labelWithTextColor:kBlackColor textAlignment:NSTextAlignmentRight font:LDFont(12) numberOfLines:1];
        [self addSubview:self.goodsPrice];
        [self.goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-LDHPadding);
            make.top.equalTo(self.goodsImageView).offset(LDVPadding / 2);
        }];
        
        //商品名称
        self.goodsNamelabel = [UILabel ld_labelWithTextColor:kBlackColor textAlignment:NSTextAlignmentLeft font:LDFont(14) numberOfLines:2];
        [self addSubview:self.goodsNamelabel];
        [self.goodsNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsImageView.mas_right).offset(LDHPadding);
            make.right.equalTo(self.goodsPrice.mas_left).offset(-5);
            make.top.equalTo(self.goodsPrice);
        }];
        //商品数量
        self.goodsCount = [UILabel ld_labelWithTextColor:LD9ATextColor textAlignment:NSTextAlignmentRight font:LDFont(12) numberOfLines:1];
        [self addSubview:self.goodsCount];
        [self.goodsCount mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.offset(-LDHPadding);
            make.bottom.equalTo(self.goodsImageView).offset(-LDVPadding - 4);
        }];
        //商品规格
        self.goodsRule = [UILabel ld_labelWithTextColor:LD9ATextColor textAlignment:NSTextAlignmentLeft font:LDFont(12) numberOfLines:2];
        [self addSubview:self.goodsRule];
        [self.goodsRule mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsNamelabel);
            make.right.equalTo(self.goodsCount.mas_left).offset(-5);
            make.top.equalTo(self.goodsCount);
        }];
        
    }
    return self;
}

- (void)reloadDataWithImage:(NSString *)imageString name:(NSString *)name rule:(NSString *)rule price:(NSString *)price count:(NSString *)count{
    //图片
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:YGDefaultImgSquare];
    //商品名字
    self.goodsNamelabel.text = name;
    //规格
    self.goodsRule.text = rule;

    //数量
    self.goodsCount.text = count;
        
    //价格
    NSString * realPrice = [NSString stringWithFormat:@"￥%@",price];
    self.goodsPrice.text = realPrice;
    
}
- (void)pushPurchaseReloadDataWithImage:(NSString *)imageString name:(NSString *)name price:(NSString *)price count:(NSString *)count{
    //图片
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:YGDefaultImgSquare];
    //商品名字
    self.goodsNamelabel.text = name;
    //规格
    self.goodsRule.text = price;
    self.goodsRule.textColor = colorWithDeepGray;
    //数量
    self.goodsCount.text = count;
    
}

@end
