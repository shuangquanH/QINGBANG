//
//  ChooseGoodsFatherView.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ChooseGoodsFatherView.h"
#import "ChooseGoodsChildView.h"
#import "NSString+SQAttributeString.h"



@interface ChooseGoodsFatherView ()
/** 移除遮盖Button  */
@property (nonatomic,strong) UIButton * coverButton;
/** 遮盖视图  */
@property (nonatomic,strong) UIView * coverView;
/** 头部视图  */
@property (nonatomic,strong) UIView * headerBackView;
/** 商品图片  */
@property (nonatomic,strong) UIImageView * goodsImageView;
/** 商品名称  */
@property (nonatomic,strong) UILabel * goodsNameLabel;
/** 商品标题  */
@property (nonatomic,strong) UILabel * goodsTitleLabel;
/** 商品价格  */
@property (nonatomic,strong) UILabel * goodsPriceLabel;
/** 底部scrollowView  */
@property (nonatomic,strong) UIScrollView * bottomScrollView;
/** scrollowView容器试图  */
@property (nonatomic,strong) UIView * bottomScrollViewContentView;
/** 最后一个选择视图  */
@property (nonatomic,strong) ChooseGoodsChildView * child;
/** 底部确认视图  */
@property (nonatomic,strong) UIView * bottomView;
/** 记录 === 规格视图  */
@property (nonatomic,strong) UIView * lastView;
/** 商品数量视图  */
@property (nonatomic,strong) UIView * goodsCountView;
/** 商品数量加  */
@property (nonatomic,strong) UIButton * addbutton;
/** 商品数量减  */
@property (nonatomic,strong) UIButton * subtractionButton;

/** 单价  */
@property (nonatomic,strong) NSString * price;
/** 规格种类 数组  */
@property (nonatomic,strong) NSArray * titleArray;
/** 每个规格下对应的具体分类  */
@property (nonatomic,strong) NSArray * tagArray;
@end


@implementation ChooseGoodsFatherView
#pragma mark - 刷新商品信息,价格 名称,图片等信息
- (void)reloadHeaderDataPrice:(NSString *)price Image:(NSString *)imageName detailTitle:(NSString *)detailTitle{
    
////    self.goodsNameLabel.text = @"";
//    [self.goodsNameLabel sizeToFit];
//
//     [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:YGDefaultImgAvatar];
    
    //修改数量
    NSString * countString = self.goodsCountTextField.text;
    NSInteger countInteger = [countString integerValue];
    
    self.price = price;   
    NSString * goodsPrice = [NSString stringWithFormat:@"￥%.2f",[self.price floatValue] * countInteger];
    self.goodsPriceLabel.attributedText = [goodsPrice attributedStringFromNSString:goodsPrice startLocation:1 forwardFont:LDFont(13) backFont:LDFont(15) forwardColor:kRedColor backColor:kRedColor];
//    self.goodsTitleLabel.text = detailTitle;

}

#pragma mark - 刷新 商品规格 数据
- (void)reloadChooseGoodsFatherView:(NSArray *)titleArray tagArray:(NSArray *)tagArray withCommodityModel:(OfficePurchaseDetailCommodityModel *)Commoditymodel{
    
//    self.goodsNameLabel.text = @"";
//    [self.goodsNameLabel sizeToFit];
    
    self.goodsTitleLabel.text = Commoditymodel.commodityName;

    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:Commoditymodel.commodityImgs] placeholderImage:YGDefaultImgFour_Three];

//    [self reloadHeaderDataPrice:Commoditymodel.commodityPrice Image:@"" detailTitle:@""];
    
    self.titleArray = [titleArray copy];
    self.tagArray = [tagArray copy];
    
    for (int i = 0; i < self.titleArray.count; i++) {
        
        NSString * str = self.titleArray[i];
        
        NSArray * contentArray = self.tagArray[i];
        
        ChooseGoodsChildView * child = [[ChooseGoodsChildView alloc] initWithTitle:str contentArray:contentArray andFrame:CGRectMake(0, 0, kScreenW, 0)];
        child.tag = 100 + i;
        [self.bottomScrollViewContentView addSubview:child];
        
        [child mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(child.frame.size.height);
            if (self.lastView) {
                
                make.top.mas_equalTo(self.lastView.mas_bottom);

            }else {
                make.top.mas_equalTo(self.bottomScrollViewContentView.mas_top);
                
            }
        }];
        
        self.lastView = child;
    }
    
    [self.bottomScrollViewContentView addSubview:self.goodsCountView];
    [self.goodsCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.lastView.mas_bottom);
        make.bottom.equalTo(self.bottomScrollViewContentView);
        make.height.offset(50);
    }];
    
}
#pragma mark - 数量减 1 操作
- (void)subtractionButtonClick:(UIButton *)subtractionButton{
    
//    [YGAppTool showToastWithText:@"减"];
    NSString * countString = self.goodsCountTextField.text;
    NSInteger countInteger = [countString integerValue];
    if (countInteger == 1) {
    }else{
        //修改价格 和 数量
        [self changePriceAdd:NO];
    }
}
#pragma mark - 数量加 1 操作

- (void)changePriceAdd:(BOOL)isAdd{
    
    //修改价格
    NSString * subString = [self.goodsPriceLabel.text substringFromIndex:1];
    CGFloat price = [subString floatValue];
    
    //修改数量
    NSString * countString = self.goodsCountTextField.text;
    NSInteger countInteger = [countString integerValue];
    
    if (isAdd) {
        price = price + [self.price floatValue];

        countInteger += 1;

    }else{
        countInteger -= 1;
        
        price = price - [self.price floatValue];
    }
    NSString * goodsPrice = [NSString stringWithFormat:@"￥%.2f",price];
    self.goodsPriceLabel.attributedText = [goodsPrice attributedStringFromNSString:goodsPrice startLocation:1 forwardFont:LDFont(13) backFont:LDFont(15) forwardColor:kRedColor backColor:kRedColor];
 
    
    self.goodsCountTextField.text = [NSString stringWithFormat:@"%ld",(long)countInteger];
}
#pragma mark - 数量加 1 操作
- (void)addButtonClick:(UIButton *)addButton{
    
//    [YGAppTool showToastWithText:@"加"];
    
    //修改价格 和 数量
    [self changePriceAdd:YES];

}
#pragma mark - 商品数量视图
- (UIView *)goodsCountView{
    
    if (!_goodsCountView) {
        _goodsCountView = [UIView new];
        
        self.addbutton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:@"popup_plus_btn" selectedImage:@"popup_plus_btn" normalTitle:nil selectedTitle:nil normalTitleColor:nil selectedTitleColor:nil backGroundColor:nil normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:0];
        [self.addbutton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.subtractionButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:@"popup_subtract_btn" selectedImage:@"popup_subtract_btn" normalTitle:nil selectedTitle:nil normalTitleColor:nil selectedTitleColor:nil backGroundColor:nil normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:0];
        
        [self.subtractionButton addTarget:self action:@selector(subtractionButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        self.goodsCountTextField = [UITextField new];
        self.goodsCountTextField.textAlignment = NSTextAlignmentCenter;
        self.goodsCountTextField.text = @"1";
        self.goodsCountTextField.font = LDFont(13);
        self.goodsCountTextField.userInteractionEnabled = NO;
        
        [_goodsCountView addSubview:self.addbutton];
        [_goodsCountView addSubview:self.subtractionButton];
        [_goodsCountView addSubview:self.goodsCountTextField];
        
        [self.addbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(- LDHPadding);
            make.centerY.offset(0);
            make.width.height.offset(30);
        }];
        [self.subtractionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.addbutton.mas_left).offset(-10 * LDHPadding);
            make.centerY.offset(0);
            make.width.height.offset(30);
        }];
        
        [self.goodsCountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subtractionButton.mas_right).offset(5);
            make.right.equalTo(self.addbutton.mas_left).offset(5);
            make.centerY.offset(0);
        }];
    }
    return _goodsCountView;
}

#pragma mark - UI搭建
- (void)setupUI{
    CGFloat headerBackViewY = kScreenH / 2;
    //遮盖
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.coverView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
    [self addSubview:self.coverView];
    self.coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.coverButton.frame = CGRectMake(0, 0, kScreenW, headerBackViewY);
    [self.coverButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.coverButton];


    //头部视图
    self.headerBackView = [[UIView alloc] init];
    self.headerBackView.backgroundColor = kWhiteColor;
    [self addSubview:self.headerBackView];
    [self.headerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(headerBackViewY);
    }];
   
    
    self.goodsNameLabel = [UILabel labelWithFont:15 textColor:LD16TextColor textAlignment:NSTextAlignmentLeft];
    [self.headerBackView addSubview:self.goodsNameLabel];
    self.goodsNameLabel.hidden = YES;
    self.goodsNameLabel.frame = CGRectMake(LDHPadding, LDVPadding, kScreenW - 2 * LDHPadding, 0);
    self.goodsImageView = [UIImageView new];
    [self.headerBackView addSubview:self.goodsImageView];
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(LDHPadding);
        make.top.equalTo(self.goodsNameLabel);
        make.width.height.offset(7 * LDHPadding);
        make.bottom.offset(-LDVPadding);
    }];
    
    self.goodsPriceLabel = [UILabel new];
    [self.headerBackView addSubview:self.goodsPriceLabel];
    [self.goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(LDHPadding);
        make.right.offset(LDHPadding);
        make.bottom.equalTo(self.goodsImageView.mas_centerY).offset(0);
    }];
    
    self.goodsTitleLabel = [UILabel new];
    self.goodsTitleLabel.font = LDFont(13);
    [self.headerBackView addSubview:self.goodsTitleLabel];
    [self.goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(LDHPadding);
        make.right.offset(LDHPadding);
        make.top.equalTo(self.goodsPriceLabel.mas_bottom).offset(LDVPadding);
    }];
    
    
    
    //底部视图
    self.bottomView.backgroundColor = kBlueColor;
    [self addSubview:self.bottomView];

    
    self.bottomScrollView = [[UIScrollView alloc] init];
    self.bottomScrollView.backgroundColor = kWhiteColor;
    [self addSubview:self.bottomScrollView];
    [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.headerBackView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    //容器视图
    self.bottomScrollViewContentView = [UIView new];
    self.bottomScrollViewContentView.backgroundColor = kWhiteColor;
    [self.bottomScrollView addSubview:self.bottomScrollViewContentView];
    [self.bottomScrollViewContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScreenW);
        make.top.left.bottom.right.offset(0);
    }];
    
    
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setupUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tagButtonClick:) name:@"" object:nil];
        
    }
    return self;
}
#pragma mark - 选择规格按钮点击
- (void)tagButtonClick:(NSNotification *)notice{
    
    NSArray * noticeArray = notice.object;
    
    int smallIndex = [noticeArray[0] intValue] - 100;
    int bigIndex = [noticeArray[1] intValue] - 100;
    
    NSString * smallString = self.tagArray[bigIndex][smallIndex];
    NSString * bigString = self.titleArray[bigIndex];
    
//    if(bigIndex >1)
    
    LDLog(@"%@",smallString)
    
    LDLog(@"%@",bigString)

}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark - 确认按钮懒加载

- (UIView *)bottomView{
    if (!_bottomView) {
        CGFloat H = YGNaviBarHeight + YGBottomMargin;
        CGFloat Y = kScreenH - H;
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Y, kScreenW, H)];
        
        UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:@"立即购买" selectedTitle:@"立即购买" normalTitleColor:kWhiteColor selectedTitleColor:kWhiteColor backGroundColor:LDMainColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:15];
        [sureButton setTitleEdgeInsets:UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0 )];
        sureButton.frame = _bottomView.bounds;
        [_bottomView addSubview:sureButton];
        [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
    
}
#pragma mark - 选择商品规格 确认按钮点击
- (void)sureButtonClick:(UIButton *)sureButton{
    
    [self removeFromSuperview];
    [self.delegate ChooseGoodsFatherViewSurePay:sureButton];
}
@end
