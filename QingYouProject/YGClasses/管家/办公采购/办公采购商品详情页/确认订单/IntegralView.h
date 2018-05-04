//
//  IntegralView.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IntegralViewDelegate <NSObject>

- (void)integralViewRightButtonDidClick:(UIButton *)coverButton;

@end


@interface IntegralView : UIView
/** 右侧Button  */
@property (nonatomic,strong) UIButton * rightButton;
/** 点击事件代理  */
@property (nonatomic,weak) id<IntegralViewDelegate> delegate;
- (void)reloadDataWithLetfTitle:(NSString *)leftTitle detailTitle:(NSString *)detailTitle lineTopColor:(UIColor *)lineTopColor lineBottomColor:(UIColor *)lineBottomColor;
@end
