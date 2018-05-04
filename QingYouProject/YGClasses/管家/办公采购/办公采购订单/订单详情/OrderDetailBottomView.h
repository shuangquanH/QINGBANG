//
//  OrderDetailBottomView.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderDetailBottomViewDelegate <NSObject>//协议
- (void)orderDetailBottomViewCancelBtnClick:(UIButton *)btn;//协议方法
- (void)orderDetailBottomViewPayBtnClick:(UIButton *)btn;//协议方法

@end

@interface OrderDetailBottomView : UIView
/** 刷新数据 */
//- (void)reloadDataWithOrderNumber:(NSArray *)orderNumberArray;
- (void)reloadDataWithTitleArry:(NSArray *)titleArry WithOrderNumber:(NSArray *)orderNumberArray ;
- (instancetype)initOrderDetailBottomViewWithY:(CGFloat)y leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle bottomNumber:(int)number;
@property (nonatomic, assign) id <OrderDetailBottomViewDelegate>delegate;
@end
