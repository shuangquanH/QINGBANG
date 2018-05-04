//
//  SignUpSelectView.h
//  QingYouProject
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SignUpSelectViewDelegate <NSObject>//协议
- (void)SignUpSelectViewNextWay:(UIButton *)btn withPersonNum:(NSInteger)num;//协议方法
- (void)signUpSelectViewSurePayWay:(UIButton *)btn withIsFree:(BOOL)isFree withName:(NSString *)name withPhone:(NSString *)phone withArray:(NSArray *)arry;//协议方法

@end
@interface SignUpSelectView : UIView
@property (nonatomic, assign) id<SignUpSelectViewDelegate>delegate;//代理属性
-(void)signupInformationWithInfoArray:(NSArray *)infoArray;
-(void)pushOtherView;
-(void)reloadViewWithPrice:(NSString *)price withHour:(NSString *)hour withCount:(NSString *)count;

/** 商品数量UITextfield*/
//@property (nonatomic,strong) UITextField * goodsCountTextField;

@end
