//
//  LoginView.h
//  FrienDo
//
//  Created by zhangkaifeng on 2017/1/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    loginWithCommonPageType, //登录
    loginWithNimbleType, //快捷登录
    loginWithThirdType, // 三方登录
    loginWithThirdSubType, // 三方登录
    loginWithThirdSubTypeNoAccountType, //三方手机号不存在登录
    loginWithRegistType, //注册
    loginWithGetBackPasswordType, // 找回密码
    loginWithGetBackPasswordSubType, // 找回密码子页面
} LoginWithTypes;

@protocol LoginViewDelegate <NSObject>

- (void)loginViewDidClickSureButtonDataDictionary:(NSMutableDictionary *)dict;

- (void)loginViewDidClickWeChatButton:(UIButton *)btn;

- (void)loginViewDidClickWithNimbleType;

- (void)getBackPassword;

- (void)registAction;

- (void)getVerifyCode;

- (void)pushProtocol;

@end

@interface LoginView : UIView

@property (nonatomic,assign) id<LoginViewDelegate> delegate;
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UITextField *verifyTextField;
@property (nonatomic,strong) UITextField *passwordTextField;
@property (nonatomic,strong) UITextField *confirmPasswordTextField;
@property (nonatomic,strong) UITextField *inviteCodeTextField;
@property (nonatomic, assign) LoginWithTypes            loginWithType;
@property (nonatomic, strong) UIButton      *verifyButton;

@end
