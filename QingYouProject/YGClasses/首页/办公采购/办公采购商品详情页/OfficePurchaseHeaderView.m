//
//  OfficePurchaseHeaderView.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OfficePurchaseHeaderView.h"
#import "NSString+SQAttributeString.h"

@interface OfficePurchaseHeaderView()<SDCycleScrollViewDelegate>
/** 轮播图  */
@property (nonatomic,strong) SDCycleScrollView * cycleScrollView;
/** 商品名称Label  */
@property (nonatomic,strong) UILabel * goodsNameLabel;
/** 商品价格Label  */
@property (nonatomic,strong) UILabel * goodsPriceLabel;
/** 快递费用Label  */
@property (nonatomic,strong) UILabel * deliveryLabel;
@end

@implementation OfficePurchaseHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma mark - UI设置
- (void)setupUI{
    
    //轮播图
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW, kScreenW) delegate:self placeholderImage:YGDefaultImgSquare];
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.autoScrollTimeInterval = 3;
    _cycleScrollView.backgroundColor = kClearColor;
    [self addSubview:self.cycleScrollView];
    
    
//    UIView * nav = [[UIView alloc] initWithFrame:CGRectMake(0, YGStatusBarHeight, kScreenW, YGNaviBarHeight)];
//    nav.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.0];
//    [self.cycleScrollView addSubview:nav];
//
//    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:@"back_white" selectedImage:@"back_white" normalTitle:nil selectedTitle:nil normalTitleColor:nil selectedTitleColor:nil backGroundColor:nil normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:0];
//    [nav addSubview:backButton];
//    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(0);
//        make.width.height.offset(YGNaviBarHeight);
//        make.centerY.offset(0);
//    }];
//    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    backButton.backgroundColor = kClearColor;
//    UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:@"share_white" selectedImage:@"share_white" normalTitle:nil selectedTitle:nil normalTitleColor:nil selectedTitleColor:nil backGroundColor:nil normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:0];
//    [nav addSubview:shareButton];
//    shareButton.backgroundColor = kClearColor;
//
//    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.offset(-LDHPadding);
//        make.width.height.offset(YGNaviBarHeight);
//        make.centerY.offset(0);
//    }];
//
//     self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:@"collect_white" selectedImage:@"collect_white" normalTitle:nil selectedTitle:nil normalTitleColor:nil selectedTitleColor:nil backGroundColor:nil normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:0];
//    [nav addSubview:self.collectionButton];
//    [self.collectionButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.collectionButton.backgroundColor = kClearColor;
//    [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(shareButton.mas_left).offset(-0);
//        make.width.height.offset(YGNaviBarHeight);
//        make.centerY.offset(0);
//    }];
    
    //商品名称
    self.goodsNameLabel = [UILabel ld_labelWithTextColor:LD16TextColor textAlignment:NSTextAlignmentLeft font:LDFont(15) numberOfLines:2];
    self.goodsNameLabel.frame = CGRectMake(LDHPadding, self.cycleScrollView.height + LDVPadding, kScreenW - 2 *LDHPadding, 0);
    self.goodsNameLabel.font = LDBoldFont(15);
    [self addSubview:self.goodsNameLabel];
   
    
    //商品价格
    self.goodsPriceLabel = [UILabel ld_labelWithTextColor:LD16TextColor textAlignment:NSTextAlignmentLeft font:LDFont(13) numberOfLines:1];
    [self addSubview:self.goodsPriceLabel];
    CGFloat maxY = CGRectGetMaxY(self.goodsNameLabel.frame);
    self.goodsPriceLabel.frame = CGRectMake(LDHPadding, maxY + LDVPadding, 30, 1.5 * LDVPadding);
    
    //底部分割线
    UIView * line = [UIView new];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(LDVPadding);
        make.top.equalTo(self.goodsPriceLabel.mas_bottom).offset(LDVPadding);
    }];
    
    
    //快递费用
    self.deliveryLabel = [UILabel ld_labelWithTextColor:LD9ATextColor textAlignment:NSTextAlignmentLeft font:LDFont(12) numberOfLines:1];
    [self addSubview:self.deliveryLabel];
    [self.deliveryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-LDHPadding);
        make.centerY.equalTo(self.goodsPriceLabel);
    }];

    
    //self.goodsPriceLabel.backgroundColor = kBlueColor;
    line.backgroundColor = LDEEPaddingColor;
    
}
- (void)reloadDataWith:(NSArray *)imageArray goodsName:(NSString *)goodsName goodsPrice:(NSString *)price deliveryPrice:(NSString *)deliveryPrice withisCollect:(NSString *)isCollect{
    
    self.cycleScrollView.imageURLStringsGroup = imageArray;

    self.goodsNameLabel.text = goodsName;
    self.deliveryLabel.text = [NSString stringWithFormat:@"快递:%@",deliveryPrice];
    if (price.length > 0) {
        self.goodsPriceLabel.attributedText = [price attributedStringFromNSString:price startLocation:1 forwardFont:LDFont(13) backFont:LDFont(15) forwardColor:LDFFTextColor backColor:LDFFTextColor];
    }else{

        LDLog(@"price为空")
    }

    [self.goodsNameLabel sizeToFit];

    [self.goodsPriceLabel sizeToFit];
    CGFloat priceY = CGRectGetMaxY(self.goodsNameLabel.frame);
    self.goodsPriceLabel.y = priceY + LDVPadding;
    self.height = CGRectGetMaxY(self.goodsPriceLabel.frame) + 2 * LDVPadding;
    
    if([isCollect isEqualToString:@"1"])
       [self.collectionButton setImage:[UIImage imageNamed:@"collect_green"] forState:UIControlStateNormal];
    
}
-(void)reloadDataWithisCollect:(NSString *)isCollect
{
    if([isCollect isEqualToString:@"1"])
        [self.collectionButton setImage:[UIImage imageNamed:@"collect_green"] forState:UIControlStateNormal];
    else
        [self.collectionButton setImage:[UIImage imageNamed:@"collect_white"] forState:UIControlStateNormal];
}
#pragma mark - 收藏按钮点击
- (void)shareButtonClick:(UIButton *)shareButton{
    [self.delegate OfficePurchaseHeaderViewShareButtonClick:shareButton];
}
#pragma mark - 退出按钮点击
- (void)backButtonClick:(UIButton *)backButton{
    [self.delegate OfficePurchaseHeaderViewBackButtonClick:backButton];

}
#pragma mark - 分享按钮点击
- (void)collectionButtonClick:(UIButton *)collectionButton{
    [self.delegate OfficePurchaseHeaderViewCollectButtonClick:collectionButton];
    
}
#pragma mark - 轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [self.delegate OfficePurchaseHeaderViewcycleScrollViewDidSelectItemAtIndex:index];
}
@end
