//
//  RushPurchaseDetailPopView.h
//  QingYouProject
//
//  Created by nefertari on 2017/12/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RushPurchaseCommodityModel.h"

@protocol RushPurchaseDetailPopViewDelegate <NSObject>//协议
- (void)chooseGoodsWithCategoriesViewSurePaywithCommoditySizeId:(NSString *)commoditySizeId andCommoditySizeSum:(NSString *)commoditySizeSum andRushPurchaseCommodityModel:(RushPurchaseCommodityModel *)commodityModel;//协议方法
@end
@interface RushPurchaseDetailPopView : UIView
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSArray * labelList;
@property (nonatomic, strong) NSString * detailStr;
@property (nonatomic, strong) NSString * pageType;

@property (nonatomic, assign) id <RushPurchaseDetailPopViewDelegate>delegate;
- (void)createFrame:(CGRect)frame withInfoNSArry:(NSArray *)arry;
@end
