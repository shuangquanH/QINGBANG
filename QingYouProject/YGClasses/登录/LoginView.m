//
//  LoginView.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/1/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LoginView.h"
#import "JKCountDownButton.h"
#import <SMS_SDK/SMSSDK.h>

@implementation LoginView
{
    UIView *_logoBaseView;
    UIView *_phoneBaseView;
    UIView *_passwordBaseView;
    UIView *_verifyBaseView;
    
    UIView *_confrimPasswordBaseView;
    UIView *_registProtoclBaseView;
    UIButton *_sureButton;
    UIButton *_backButton;
    UIImageView *_backgroundImageView;
    
    UIButton *_nimbleButton; //快捷登录
    UIButton *_getBackPasswordButton;
    UIButton *_registButton;
    UIImageView *_logoImageView;
    
    UIView *_inviteCodeBaseView;

}
- (instancetype)init
{
    self = [super init];
    if (self)
    {

        self.backgroundColor = colorWithYGWhite;
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

- (void)setLoginWithType:(LoginWithTypes)loginWithType
{
    _loginWithType = loginWithType;
    //背景图
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight)];
    _backgroundImageView.image = [UIImage imageNamed:@"login_bg.png"];
    _backgroundImageView.userInteractionEnabled = YES;
    [self addSubview:_backgroundImageView];

    switch (self.loginWithType) {
        case loginWithCommonPageType://登录
        {
//            [self createBackButtonWithBaseView:nil];
            [self createLoginViewWithBaseView:nil];
            [self createPhoneViewWithY:_logoImageView.y+_logoImageView.height];
            [self createPasswordViewWithBaseView:_phoneBaseView];
            [self createConfirmButtonWithBaseView:_passwordBaseView withTitle:@"登录"];
            [self createThirdLoginCodeViewWithBaseView:nil];
            break;
        }
        case loginWithNimbleType: //快捷登录
        {
            [self createPhoneViewWithY:10];
            [self createVerifyCodeViewWithBaseView:_phoneBaseView];
            [self createConfirmButtonWithBaseView:_verifyBaseView withTitle:@"登录"];

            break;
        }
        case loginWithThirdType: // 三方登录
        {
            [self createPhoneViewWithY:10];
            [self createConfirmButtonWithBaseView:_phoneBaseView withTitle:@"下一步"];

            break;
        }
        case loginWithThirdSubType: // 三方登录
        {
            [self createVerifyCodeViewWithBaseView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0)]];
            [self createPasswordViewWithBaseView:_verifyBaseView];
            [self createConfirmButtonWithBaseView:_passwordBaseView withTitle:@"登录"];
            
           break;
        }case loginWithThirdSubTypeNoAccountType: // 三方登录
        {
            [self createVerifyCodeViewWithBaseView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0)]];
            [self createPasswordViewWithBaseView:_verifyBaseView];
            [self createConfrimPasswordViewWithBaseView:_passwordBaseView];
            [self createInviteCodeViewWithBaseView:_confrimPasswordBaseView];
            [self createConfirmButtonWithBaseView:_inviteCodeBaseView withTitle:@"登录"];
            [self createProtocolView];

            break;
        }
        case loginWithRegistType://注册
        {
            [self createPhoneViewWithY:10];
            [self createVerifyCodeViewWithBaseView:_phoneBaseView];
            [self createPasswordViewWithBaseView:_verifyBaseView];
            [self createConfrimPasswordViewWithBaseView:_passwordBaseView];
            [self createInviteCodeViewWithBaseView:_confrimPasswordBaseView];
            [self createConfirmButtonWithBaseView:_inviteCodeBaseView withTitle:@"注册"];
            [self createProtocolView];
            break;
        }
        case loginWithGetBackPasswordType: // 找回密码
        {
            [self createPhoneViewWithY:10];
            [self createVerifyCodeViewWithBaseView:_phoneBaseView];
            [self createConfirmButtonWithBaseView:_verifyBaseView withTitle:@"下一步"];
            break;
        }
        case loginWithGetBackPasswordSubType: // 找回密码子页面
        {
            [self createPasswordViewWithBaseView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0)]];
            [self createConfrimPasswordViewWithBaseView:_passwordBaseView];
            [self createConfirmButtonWithBaseView:_confrimPasswordBaseView withTitle:@"登录"];
            break;
        }
    }
    
    if ([YGUserDefaults objectForKey:USERDEF_LOGINPHONE] && self.loginWithType == loginWithCommonPageType)
    {
        _phoneTextField.text = [YGUserDefaults objectForKey:USERDEF_LOGINPHONE];
    }
}
- (void)createProtocolView
{
    
    UIView *aggrementView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-50, YGScreenWidth, 40)];
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkButton.frame = CGRectMake(0, 10, 20, 20);
    checkButton.tag = 1994;
    [checkButton setImage:[UIImage imageNamed:@"nochoice_btn_gray"] forState:UIControlStateNormal];
    [checkButton setImage:[UIImage imageNamed:@"choice_btn_green"] forState:UIControlStateSelected];
    [checkButton addTarget:self action:@selector(isAgreeClick:) forControlEvents:UIControlEventTouchUpInside];
    [aggrementView addSubview:checkButton];
    
    UILabel *alreadyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 90, 20)];
    alreadyLabel.text = @"已阅读并同意";
    alreadyLabel.textAlignment = NSTextAlignmentRight;
    alreadyLabel.textColor = colorWithBlack;
    alreadyLabel.font = [UIFont systemFontOfSize:13.0];
    [alreadyLabel sizeToFit];
    alreadyLabel.frame = CGRectMake(alreadyLabel.x,alreadyLabel.y, alreadyLabel.width, 20);
    [aggrementView addSubview:alreadyLabel];
    
    UIButton *agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreementButton.frame = CGRectMake(alreadyLabel.x+alreadyLabel.width,alreadyLabel.y, 180, 20);
    agreementButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    agreementButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [agreementButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [agreementButton setTitle:@"《青网服务协议》" forState:UIControlStateNormal];
    [agreementButton addTarget:self action:@selector(protocolButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [agreementButton sizeToFit];
    agreementButton.frame = CGRectMake(agreementButton.x,agreementButton.y,agreementButton.width+20,30);
    [aggrementView addSubview:agreementButton];
    aggrementView.frame = CGRectMake(YGScreenWidth/2-(checkButton.width+alreadyLabel.width+agreementButton.width)/2, aggrementView.y, (checkButton.width+alreadyLabel.width+agreementButton.width), aggrementView.height);
    agreementButton.centery = alreadyLabel.centery;
    [self addSubview:aggrementView];
}
- (void)createConfirmButtonWithBaseView:(UIView *)baseView withTitle:(NSString *)title
{
    //确定
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(35,  baseView.y+baseView.height+25, YGScreenWidth - 70, 40)];
    _sureButton.layer.cornerRadius = _sureButton.height / 2;
    _sureButton.backgroundColor = colorWithMainColor;
    [_sureButton setTitle:title forState:UIControlStateNormal];
    _sureButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImageView addSubview:_sureButton];
}
- (void)createBackButtonWithBaseView:(UIView *)baseView
{
    //返回
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    [_backButton setImage:[UIImage imageNamed:@"login_back.png"] forState:UIControlStateNormal];
    _backButton.contentMode = UIViewContentModeCenter;
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImageView addSubview:_backButton];
}

#pragma 登录页面
- (void)createLoginViewWithBaseView:(UIView *)baseView
{

    //注册
    _registButton = [[UIButton alloc] initWithFrame:CGRectMake(YGScreenWidth-48, KSTATU_HEIGHT, 40, 40)];
    [_registButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    _nimbleButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    _registButton.contentMode = UIViewContentModeCenter;
    [_registButton addTarget:self action:@selector(registButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImageView addSubview:_registButton];
    
    //logo
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.frame = CGRectMake(0,YGScreenHeight*0.07+20, YGScreenWidth, YGScreenHeight*0.18);
    [_backgroundImageView addSubview:_logoImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:_logoImageView.bounds];
    titleLabel.text = @"欢迎来到青邦";
    titleLabel.font = KFONT(68);
    titleLabel.textColor = KCOLOR(@"1b1817");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_logoImageView addSubview:titleLabel];
    
    
    //快捷登录
    _nimbleButton = [[UIButton alloc] initWithFrame:CGRectMake(YGScreenWidth / 2-110, _logoImageView.y+_logoImageView.height+200, 100, 45)];
//    _nimbleButton = [[UIButton alloc] initWithFrame:CGRectMake(YGScreenWidth / 2-110, YGScreenHeight*0.6, 100, 45)];
    [_nimbleButton setTitle:@"快捷登录" forState:UIControlStateNormal];
    _nimbleButton.contentMode = UIViewContentModeRight;
    [_nimbleButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    _nimbleButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    [_nimbleButton addTarget:self action:@selector(nimbleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImageView addSubview:_nimbleButton];
    
    //左线
    UIImageView *leftLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YGScreenWidth / 2, _nimbleButton.y, 1, 20)];
    leftLineImageView.centery = _nimbleButton.centery;
    leftLineImageView.backgroundColor = colorWithLine;
    [_backgroundImageView addSubview:leftLineImageView];
    
    //确定
    _getBackPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(YGScreenWidth / 2+10, _nimbleButton.y, 100, 45)];
    [_getBackPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [_getBackPasswordButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    _getBackPasswordButton.contentMode = UIViewContentModeLeft;
    _getBackPasswordButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    [_getBackPasswordButton addTarget:self action:@selector(getBackPasswordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImageView addSubview:_getBackPasswordButton];
}

#pragma 手机号
- (void)createPhoneViewWithY:(CGFloat)baseY
{
    //baseview
    _phoneBaseView = [[UIView alloc] initWithFrame:CGRectMake(15, baseY+10, YGScreenWidth-30, 50)];
    [_backgroundImageView addSubview:_phoneBaseView];
    //手机号图
    UIImageView *phoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_phone_icon_black"]];
    [phoneImageView sizeToFit];
    phoneImageView.frame = CGRectMake(10, 10, phoneImageView.width, phoneImageView.height);
//    phoneImageView.centery = _phoneBaseView.centery;
    [_phoneBaseView addSubview:phoneImageView];
    
    //手机号text
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(phoneImageView.x + phoneImageView.width + 15, 10, YGScreenWidth - phoneImageView.x - phoneImageView.width - phoneImageView.width-30, 30)];
    _phoneTextField.centery = phoneImageView.centery;
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTextField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _phoneTextField.textColor = colorWithBlack;
    _phoneTextField.placeholder = @"手机号";
    [_phoneTextField setValue:colorWithPlaceholder forKeyPath:@"_placeholderLabel.textColor"];
    _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [_phoneBaseView addSubview:_phoneTextField];
    
    //线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _phoneTextField.y + _phoneTextField.height + 10, _phoneBaseView.width, 0.5)];
    lineView.backgroundColor = colorWithLine;
    [_phoneBaseView addSubview:lineView];

}

#pragma 验证码
- (void)createVerifyCodeViewWithBaseView:(UIView *)baseView
{
    //baseview
    _verifyBaseView = [[UIView alloc] initWithFrame:CGRectMake(15, baseView.y+baseView.height+10, YGScreenWidth-30, 50)];
    [_backgroundImageView addSubview:_verifyBaseView];
    //验证码图
    UIImageView *verifyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_captcha_icon_black"]];
    [verifyImageView sizeToFit];
    verifyImageView.frame = CGRectMake(10, 10, verifyImageView.width, verifyImageView.height);
//    verifyImageView.centery = _verifyBaseView.centery;
    [_verifyBaseView addSubview:verifyImageView];
    
    //验证码text
    _verifyTextField = [[UITextField alloc] initWithFrame:CGRectMake(verifyImageView.x + verifyImageView.width + 15, 10, _verifyBaseView.width - verifyImageView.width - verifyImageView.width - 130, 30)];
    _verifyTextField.centery = verifyImageView.centery;
    _verifyTextField.font =  [UIFont systemFontOfSize:YGFontSizeBigOne];
    _verifyTextField.textColor = colorWithBlack;
    _verifyTextField.placeholder = @"验证码";
    [_verifyTextField setValue:colorWithPlaceholder forKeyPath:@"_placeholderLabel.textColor"];
    _verifyTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_verifyBaseView addSubview:_verifyTextField];
    
    //发送验证码

    _verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verifyButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_verifyButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    _verifyButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _verifyButton.frame = CGRectMake(_verifyBaseView.width -110, 0, 100, 45);
    _verifyButton.layer.cornerRadius = 5;
    _verifyButton.layer.borderColor = colorWithMainColor.CGColor;
    _verifyButton.layer.borderWidth = 1;
    [_verifyButton addTarget:self action:@selector(verifyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_verifyBaseView addSubview:_verifyButton];
    
    //线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _verifyTextField.y + _verifyTextField.height + 10, _verifyBaseView.width, 0.5)];
    lineView1.backgroundColor = colorWithLine;
    [_verifyBaseView addSubview:lineView1];
}

#pragma 密码
- (void)createPasswordViewWithBaseView:(UIView *)baseView
{
    //baseview
    _passwordBaseView = [[UIView alloc] initWithFrame:CGRectMake(15, baseView.y+baseView.height+10, YGScreenWidth-30, 50)];
    [_backgroundImageView addSubview:_passwordBaseView];
    //手机号图
    UIImageView *phoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password_icon_black"]];
    [phoneImageView sizeToFit];
    phoneImageView.frame = CGRectMake(10, 10, phoneImageView.width, phoneImageView.height);
//    phoneImageView.centery = _passwordBaseView.centery;
    [_passwordBaseView addSubview:phoneImageView];
    
    //密码text
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(phoneImageView.x + phoneImageView.width + 15, 0, YGScreenWidth - phoneImageView.x - phoneImageView.width - phoneImageView.width-30, 30)];
    _passwordTextField.centery = phoneImageView.centery;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _passwordTextField.textColor = colorWithBlack;
    _passwordTextField.placeholder = @"密码";
    [_passwordTextField setValue:colorWithPlaceholder forKeyPath:@"_placeholderLabel.textColor"];
    _passwordTextField.keyboardType = UIKeyboardTypeDefault;
    [_passwordBaseView addSubview:_passwordTextField];
    
    //线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _passwordTextField.y + _passwordTextField.height + 15, _passwordBaseView.width, 0.5)];
    lineView.backgroundColor = colorWithLine;
    [_passwordBaseView addSubview:lineView];
    
}
#pragma 确认密码
- (void)createConfrimPasswordViewWithBaseView:(UIView *)baseView
{
    //baseview
    _confrimPasswordBaseView = [[UIView alloc] initWithFrame:CGRectMake(15, baseView.y+baseView.height+10, YGScreenWidth-30, 50)];
    [_backgroundImageView addSubview:_confrimPasswordBaseView];
    //手机号图
    UIImageView *phoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password_icon_black"]];
    [phoneImageView sizeToFit];
    phoneImageView.frame = CGRectMake(10, 10, phoneImageView.width, phoneImageView.height);
//    phoneImageView.centery = _confrimPasswordBaseView.centery;
    [_confrimPasswordBaseView addSubview:phoneImageView];
    
    //手机号text
    _confirmPasswordTextField= [[UITextField alloc] initWithFrame:CGRectMake(phoneImageView.x + phoneImageView.width + 15, 0, YGScreenWidth - phoneImageView.x - phoneImageView.width - phoneImageView.width-30, 30)];
    _confirmPasswordTextField.centery = phoneImageView.centery;
    _confirmPasswordTextField.secureTextEntry = YES;
    _confirmPasswordTextField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _confirmPasswordTextField.textColor = colorWithBlack;
    _confirmPasswordTextField.placeholder = @"确认密码";
    [_confirmPasswordTextField setValue:colorWithPlaceholder forKeyPath:@"_placeholderLabel.textColor"];
    _confirmPasswordTextField.keyboardType = UIKeyboardTypeDefault;
    [_confrimPasswordBaseView addSubview:_confirmPasswordTextField];
    
    //线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _confirmPasswordTextField.y + _confirmPasswordTextField.height + 15, _confrimPasswordBaseView.width, 0.5)];
    lineView.backgroundColor = colorWithLine;
    [_confrimPasswordBaseView addSubview:lineView];
    
}
#pragma 邀请码
- (void)createInviteCodeViewWithBaseView:(UIView *)baseView
{
    //baseview
    _inviteCodeBaseView = [[UIView alloc] initWithFrame:CGRectMake(15, baseView.y+baseView.height+10, YGScreenWidth-30, 50)];
    [_backgroundImageView addSubview:_inviteCodeBaseView];
    //手机号图
    UIImageView *phoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_invitationcode"]];
    [phoneImageView sizeToFit];
    phoneImageView.frame = CGRectMake(10, 10, phoneImageView.width, phoneImageView.height);
    //    phoneImageView.centery = _confrimPasswordBaseView.centery;
    [_inviteCodeBaseView addSubview:phoneImageView];
    
    //手机号text
    _inviteCodeTextField= [[UITextField alloc] initWithFrame:CGRectMake(phoneImageView.x + phoneImageView.width + 15, 0, YGScreenWidth - phoneImageView.x - phoneImageView.width - phoneImageView.width-30, 30)];
    _inviteCodeTextField.centery = phoneImageView.centery;
    _inviteCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inviteCodeTextField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _inviteCodeTextField.textColor = colorWithBlack;
    _inviteCodeTextField.placeholder = @"输入邀请码（非必填）";
    [_inviteCodeTextField setValue:colorWithPlaceholder forKeyPath:@"_placeholderLabel.textColor"];
    [_inviteCodeBaseView addSubview:_inviteCodeTextField];
    
    //线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _inviteCodeTextField.y + _inviteCodeTextField.height + 15, _inviteCodeBaseView.width, 0.5)];
    lineView.backgroundColor = colorWithLine;
    [_inviteCodeBaseView addSubview:lineView];
}
#pragma 三方登录
- (void)createThirdLoginCodeViewWithBaseView:(UIView *)baseView
{
    //baseview
    UIView *bottomBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, YGScreenHeight - YGBottomMargin-(YGScreenWidth-60)/3-YGStatusBarHeight, YGScreenWidth, (YGScreenWidth-60)/3)];
    [self addSubview:bottomBaseView];
    
    NSArray *titleArray = @[@{@"title":@"QQ",@"icon":@"login_qq"},@{@"title":@"微信",@"icon":@"login_wechat"},@{@"title":@"微博",@"icon":@"login_sinablog"}];
    for (int i = 0; i<3; i++) {
        //baseview
        UIView *thirdBaseView = [[UIView alloc] initWithFrame:CGRectMake(30+(YGScreenWidth-60)/3*i, 0, (YGScreenWidth-60)/3, (YGScreenWidth-60)/3)];
        [bottomBaseView addSubview:thirdBaseView];
        
        //微信按钮
        UIButton *WeChatButton = [[UIButton alloc] init];
        [WeChatButton setImage:[UIImage imageNamed:titleArray[i][@"icon"]] forState:UIControlStateNormal];
        [WeChatButton sizeToFit];
        WeChatButton.y = 0;
        WeChatButton.centerx = thirdBaseView.width / 2;
        WeChatButton.tag = 1111+i;
        [WeChatButton addTarget:self action:@selector(WeChatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [thirdBaseView addSubview:WeChatButton];
        
        //文字
        UILabel *WeChatLabel = [[UILabel alloc] init];
        WeChatLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        WeChatLabel.textColor = colorWithDeepGray;
        WeChatLabel.text = titleArray[i][@"title"];
        [WeChatLabel sizeToFitHorizontal];
        WeChatLabel.centerx = thirdBaseView.width / 2;
        WeChatLabel.y = WeChatButton.y + WeChatButton.height + 8;
        [thirdBaseView addSubview:WeChatLabel];
    }
    
    
    bottomBaseView.y = YGScreenHeight - bottomBaseView.height;

}
#pragma 点击事件


- (void)verifyButtonAction
{
    if (self.loginWithType  == loginWithThirdSubType || self.loginWithType  == loginWithThirdSubTypeNoAccountType)
    {
        [self.delegate getVerifyCode];
    }else
    {
        //手机号
        if (_phoneTextField.text.length == 0)
        {
            [YGAppTool showToastWithText:@"请输入手机号！"];
            [_phoneTextField becomeFirstResponder];
            return;
        }
        //验证手机号合法性
        if ([YGAppTool isNotPhoneNumber:_phoneTextField.text])
        {
            return;
        }
        [self.delegate getVerifyCode];
    }
}

- (void)sureButtonClick
{
    [self endEditing:YES];
    
    if (self.loginWithType == loginWithRegistType || self.loginWithType == loginWithThirdSubTypeNoAccountType) {
        UIButton *checkButton = [self viewWithTag:1994];
        if (checkButton.selected == NO) {
            [YGAppTool showToastWithText:@"请勾选《青网服务协议》!"];
            return ;
        }
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //如果是登录首页 直接填手机号掉代理密码登录
    if (self.loginWithType == loginWithCommonPageType) {
        //手机号
        if (_phoneTextField.text.length == 0)
        {
            [YGAppTool showToastWithText:@"请输入手机号！"];
            [_phoneTextField becomeFirstResponder];
            return;
        }
        //手机号
        if ([YGAppTool isNotPhoneNumber:_phoneTextField.text])
        {
            [_phoneTextField becomeFirstResponder];
            return;
        }
        //密码
        if (_passwordTextField.text.length == 0)
        {
            return;
        }
        [dict setValue:_phoneTextField.text forKey:@"phone"];
        [dict setValue:_passwordTextField.text forKey:@"passWord"];
        [self.delegate loginViewDidClickSureButtonDataDictionary:dict];
    }

   
    if (
        self.loginWithType == loginWithGetBackPasswordType //如果是找回密码首页下一步 填手机号 验证码后 验证验证码是否正确
        || self.loginWithType == loginWithRegistType //如果注册页面 填手机号 验证码 密码 确认密码后 两次密码输入相同 验证验证码是否正确 然后掉起注册接口
        || self.loginWithType == loginWithThirdType  //如果是三方页面登录 直接填手机号验证手机号账户是否存在
        || self.loginWithType == loginWithNimbleType //如果是快捷登录 直接填手机号验证手机号账户是否存在 不存在先注册
        )
    {
        //手机号
        if (_phoneTextField.text.length == 0)
        {
            [YGAppTool showToastWithText:@"请输入手机号！"];
            [_phoneTextField becomeFirstResponder];
            return;
        }
        //手机号
        if ([YGAppTool isNotPhoneNumber:_phoneTextField.text])
        {
            [_phoneTextField becomeFirstResponder];
            return;
        }
        [dict setValue:_phoneTextField.text forKey:@"phone"];
        if (self.loginWithType == loginWithThirdType ) //验证手机号账户是否存在
        {
            [self.delegate loginViewDidClickSureButtonDataDictionary:dict];
        }
    }
    //如果是三方子页面登录 验证验证码 密码三方登录后 绑定
    if (self.loginWithType == loginWithThirdSubType)
    {
        //密码
        if (_passwordTextField.text.length == 0)
        {
            return;
        }
        [dict setValue:_passwordTextField.text forKey:@"passWord"];
    }
    //如果是三方 无手机号账户 子页面登录 验证验证码 密码 确认密码 三方登录后 绑定
    if (self.loginWithType == loginWithThirdSubTypeNoAccountType)
    {
        //密码
        if (_passwordTextField.text.length == 0)
        {
            [YGAppTool showToastWithText:@"请输入密码!"];
            return;
        }
        //确认密码
        if (_confirmPasswordTextField.text.length == 0)
        {
            [YGAppTool showToastWithText:@"请输入确认密码!"];

            return;
        }
        if (![_confirmPasswordTextField.text isEqualToString:_passwordTextField.text]) {
            [YGAppTool showToastWithText:@"两次密码输入不一致！"];
            return;

        }
        [dict setValue:_passwordTextField.text forKey:@"passWord"];
    }
    

    if (
        self.loginWithType == loginWithGetBackPasswordSubType //如果是找回密码下一步登录按钮 两边密码一致是否正确
        || self.loginWithType == loginWithRegistType
        )
    {
        //密码
        if (_passwordTextField.text.length == 0)
        {
            [YGAppTool showToastWithText:@"请输入密码！"];
            return;
        }
        //密码
        if (_confirmPasswordTextField.text.length == 0)
        {
            
            [YGAppTool showToastWithText:@"请输入确认密码！"];
            return;
        }
        if (![_confirmPasswordTextField.text isEqualToString:_passwordTextField.text])
        {
            [YGAppTool showToastWithText:@"两次密码输入不一致！"];
            return;

        }
        //如果是找回密码下一步登录按钮 两边密码一致是否正确 调起忘记密码接口 登录
        if (self.loginWithType == loginWithGetBackPasswordSubType) {
            [dict setValue:_passwordTextField.text forKey:@"newPassword"];
            [self.delegate loginViewDidClickSureButtonDataDictionary:dict];
        }else
        {
            [dict setValue:_passwordTextField.text forKey:@"passWord"];
        }
    }

    if (
        self.loginWithType == loginWithNimbleType         //如果是快捷登录 手机号验证手机号账户是否存在 不存在先注册
        || self.loginWithType == loginWithThirdSubType    //如果是三方子页面登录 验证验证码 密码三方登录后 绑定
        || self.loginWithType == loginWithThirdSubTypeNoAccountType  //如果是三方 无手机号账户 子页面登录 验证验证码 密码 确认密码 三方登录后 绑定
        || self.loginWithType == loginWithGetBackPasswordType        //如果是找回密码下一步 验证验证码是否正确 条下一页
        || self.loginWithType == loginWithRegistType
        )
    {
        //验证码
        if (![YGAppTool isVerifiedWithText:_verifyTextField.text name:@"验证码" maxLength:8 minLength:1 shouldEmpty:NO])
        {
            [_verifyTextField becomeFirstResponder];
            return;
        }
        
        [dict setValue:_verifyTextField.text forKey:@"mobileCode"];
        
        //请求服务器
        [_delegate loginViewDidClickSureButtonDataDictionary:dict];
            
    }
}
//是否已阅读并同意《青网服务协议》
-(void)isAgreeClick:(UIButton *)button
{
    button.selected = !button.selected;
}
- (void)backButtonClick
{
    
}
- (void)protocolButtonAction
{
    [self.delegate pushProtocol];
}
- (void)registButtonClick
{
    [self.delegate registAction];
}

- (void)nimbleButtonClick
{
    [self.delegate loginViewDidClickWithNimbleType];

}
- (void)getBackPasswordButtonClick
{
    [self.delegate getBackPassword];
}
- (void)WeChatButtonClick:(UIButton *)btn
{
//    1111+i
    [self endEditing:YES];
    [_delegate loginViewDidClickWeChatButton:btn];
}
@end
