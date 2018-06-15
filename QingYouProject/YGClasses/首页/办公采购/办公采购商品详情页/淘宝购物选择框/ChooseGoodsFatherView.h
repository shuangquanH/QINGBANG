//
//  ChooseGoodsFatherView.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfficePurchaseDetailShowModel.h"
@protocol ChooseGoodsFatherViewDelegate <NSObject>//协议
- (void)ChooseGoodsFatherViewSurePay:(UIButton *)btn;//协议方法
@end

@interface ChooseGoodsFatherView : UIView
- (void)reloadChooseGoodsFatherView:(NSArray *)titleArray tagArray:(NSArray *)tagArray withCommodityModel:(OfficePurchaseDetailCommodityModel *)Commoditymodel;
- (void)reloadHeaderDataPrice:(NSString *)price Image:(NSString *)imageName detailTitle:(NSString *)detailTitle;

@property (nonatomic, strong) NSString *commodityID;
@property (nonatomic, assign) id<ChooseGoodsFatherViewDelegate>delegate;//代理属性
/** 商品数量UITextfield*/
@property (nonatomic,strong) UITextField * goodsCountTextField;
@end


