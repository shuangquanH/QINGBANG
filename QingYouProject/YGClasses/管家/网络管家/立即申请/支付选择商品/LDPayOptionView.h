//
//  LDPayOptionView.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/10.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LDPayOptionViewDelegate <NSObject>
@optional
/** 支付视图被移除 */
- (void)payOptionViewRemovedFromeSuperView;
/** 支付视图展示 */
- (void)payOptionViewDidSelectButton:(NSString *)leftString rightString:(NSString *)rightString;

@end




@interface LDPayOptionView : UIView
/** dail  */
@property (nonatomic,weak) id<LDPayOptionViewDelegate> delegate;
- (void)showPayOptionViewOn:(UIView *)superView;
@end
