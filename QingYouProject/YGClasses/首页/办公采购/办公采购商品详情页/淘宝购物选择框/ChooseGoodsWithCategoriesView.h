//
//  ChooseGoodsWithCategoriesView.h
//  QingYouProject
//
//  Created by apple on 2017/12/11.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseGoodsWithCategoriesViewDelegate <NSObject>//协议
- (void)chooseGoodsWithCategoriesViewSurePaywitDict:(NSDictionary *)dict;//协议方法
@end

@interface ChooseGoodsWithCategoriesView : UIView
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSArray * labelList;
@property (nonatomic, strong) NSString * detailStr;
@property (nonatomic, strong) NSString * pageType;

@property (nonatomic, assign) id <ChooseGoodsWithCategoriesViewDelegate>delegate;
- (void)createFrame:(CGRect)frame withInfoNSArry:(NSArray *)arry;

@end
