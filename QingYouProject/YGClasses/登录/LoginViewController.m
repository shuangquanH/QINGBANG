//
//  LoginViewController.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/1/6.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "YGPushSDK.h"
#import "ProjectApplyForWebDetailViewController.h"

@interface LoginViewController ()<LoginViewDelegate>
{
    LoginView *_loginView;
    
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    [self registerTimerNotification];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.statusBarStyle = UIStatusBarStyleDefault;
}

-(void)configUI
{
    _loginView = [[LoginView alloc]init];
    _loginView.loginWithType = self.loginWithType;
    _loginView.delegate = self;
    [self.view addSubview:_loginView];
    if (self.loginWithType == loginWithCommonPageType) {
        self.fd_prefersNavigationBarHidden = YES;
        UIButton    *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
        [backButton setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        [_loginView addSubview:backButton];
    } else {
        self.fd_prefersNavigationBarHidden = NO;
    }
}


//点击微信
- (void)loginViewDidClickWeChatButton:(UIButton *)btn
{
    //    1111+i
    UMSocialPlatformType platformType = UMSocialPlatformType_QQ;
    NSString *type;
    if (btn.tag == 1111) {
        platformType = UMSocialPlatformType_QQ;
        type = @"2";
    }
    if (btn.tag == 1112) {
        platformType = UMSocialPlatformType_WechatSession;
        type = @"1";
        
    }
    if (btn.tag == 1113) {
        platformType = UMSocialPlatformType_Sina;
        type = @"3";
        
    }
    self.channel = type;
    
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:nil];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        if (error)
        {
            [YGAppTool showToastWithText:@"登录失败"];
        }
        else
        {
            
            UMSocialUserInfoResponse *resp =result;
            // 第三方登录数据(为空表示平台未提供)
            // 授权数据
            
            self.thirdLoginDict = [[NSMutableDictionary alloc] init];
            
            // 用户数据
            NSLog(@" name: %@", resp.name);
            NSLog(@" iconurl: %@", resp.iconurl);
            
            // 第三方平台SDK原始数据
            NSLog(@" originalResponse: %@", resp.originalResponse);
            NSString *openid;
            if ([type isEqualToString:@"3"])
            {
                openid = [NSString stringWithFormat:@"%@",[resp.originalResponse objectForKey:@"id"]];
                [self.thirdLoginDict setValue:[NSString stringWithFormat:@"%@",[resp.originalResponse objectForKey:@"id"]] forKey:@"openid"];
            }else
            {
                NSLog(@" uid: %@", resp.uid);
                NSLog(@" openid: %@", resp.openid);
                NSLog(@" accessToken: %@"
                      , resp.accessToken);
                NSLog(@" refreshToken: %@", resp.refreshToken);
                NSLog(@" expiration: %@", resp.expiration);
                
                
                NSLog(@" gender: %@", resp.gender);
                openid = resp.openid;
                [self.thirdLoginDict setValue:resp.openid forKey:@"openid"];
            }
            
            [self.thirdLoginDict setValue:resp.name forKey:@"name"];
            [self.thirdLoginDict setValue:resp.iconurl forKey:@"img"];
            [self.thirdLoginDict setValue:type forKey:@"type"];
            
            //没有错误，请求服务器
            [self startPostWithURLString:REQUEST_otherLogin parameters:@{@"openid":openid,@"name":resp.name,@"img":resp.iconurl,@"type":type} showLoadingView:NO scrollView:nil];
            
            
        }
    }];
    
}

- (void)loginViewDidClickWithNimbleType
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.loginWithType = loginWithNimbleType;
    vc.naviTitle = @"登录";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getBackPassword
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.loginWithType = loginWithGetBackPasswordType;
    vc.naviTitle = @"找回密码";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)registAction {
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.loginWithType = loginWithRegistType;
    vc.naviTitle = @"注册";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getVerifyCode
{
    [YGNetService showLoadingViewWithSuperView:self.view];
    _loginView.verifyButton.enabled = NO;
    
    if (self.loginWithType == loginWithThirdSubType ) {
        [self startPostWithURLString:REQUEST_sendSMS parameters:@{@"phone":self.phoneString,@"type":@"2"} showLoadingView:NO scrollView:nil];
        
    }else if(self.loginWithType == loginWithThirdSubTypeNoAccountType)
    {
        [self startPostWithURLString:REQUEST_sendSMS parameters:@{@"phone":self.phoneString,@"type":@"0"} showLoadingView:NO scrollView:nil];
        
    }else
    {
        [self startPostWithURLString:REQUEST_userCheck parameters:@{@"phone":_loginView.phoneTextField.text,@"type":@""} showLoadingView:NO scrollView:nil];
    }
    
}
//点击登录按钮
- (void)loginViewDidClickSureButtonDataDictionary:(NSMutableDictionary *)dict
{
    [YGNetService showLoadingViewWithSuperView:self.view];
    NSString *type = (self.loginWithType == loginWithRegistType )?@"0":(self.loginWithType == loginWithGetBackPasswordType?@"4":@"2");
    
    //下一步 忘记密码第一页点击下一步按钮走的是检查验证码
    if (self.loginWithType == loginWithGetBackPasswordType ) {
        [self startPostWithURLString:REQUEST_checkSMS parameters:@{@"phone":_loginView.phoneTextField.text,@"code":_loginView.verifyTextField.text,@"type":type} showLoadingView:NO scrollView:nil];
        
    }
    //下一步 三方登录第一页走检查该用户是否存在
    if (self.loginWithType == loginWithThirdType) {
        [dict setValue:self.channel forKey:@"type"];
        [self startPostWithURLString:REQUEST_userCheck parameters:dict showLoadingView:NO scrollView:nil];
        
    }
    //三方登录子页面 验证验证码确认按钮
    if (self.loginWithType == loginWithThirdSubType)
    {
        [self startPostWithURLString:REQUEST_checkSMS parameters:@{@"phone":self.phoneString,@"code":_loginView.verifyTextField.text,@"type":type} showLoadingView:NO scrollView:nil];
        
    }
    
    //无账号三方登录
    if (self.loginWithType == loginWithThirdSubTypeNoAccountType)
    {
        [dict setValue:self.phoneString forKey:@"phone"];
        [self startPostWithURLString:REQUEST_newUserRegistration parameters:dict showLoadingView:NO scrollView:nil];
    }
    
    if (self.loginWithType == loginWithGetBackPasswordSubType)
    {
        [dict setValue:self.phoneString forKey:@"phone"];
        [self startPostWithURLString:REQUEST_forgetPassword parameters:dict showLoadingView:NO scrollView:nil];
    }
    if (self.loginWithType == loginWithCommonPageType ) {
        
        [self startPostWithURLString:REQUEST_userLogin parameters:dict showLoadingView:NO scrollView:nil];
        
    }
    
    if (self.loginWithType == loginWithNimbleType ) { //快捷登录
        [self startPostWithURLString:REQUEST_smsLogin parameters:dict showLoadingView:NO scrollView:nil];
        //        [self startPostWithURLString:REQUEST_checkSMS parameters:dict showLoadingView:NO scrollView:nil];
        
    }
    
    if (self.loginWithType == loginWithRegistType) {
        [self startPostWithURLString:REQUEST_checkSMS parameters:@{@"phone":_loginView.phoneTextField.text,@"code":_loginView.verifyTextField.text,@"type":type} showLoadingView:NO scrollView:nil];
        
    }
}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    [YGNetService dissmissLoadingView];
    NSString *type = (self.loginWithType == loginWithRegistType )?@"0":(self.loginWithType == loginWithGetBackPasswordType?@"4":@"2");
    if ([URLString isEqualToString:REQUEST_otherLogin])
    {
        if ([responseObject[@"result"] isEqualToString:@"1"])
        {
            YGSingletonMarco.user = [YGUser mj_objectWithKeyValues:responseObject[@"user"]];
            //拿到新的就归档到本地
            [YGSingletonMarco archiveUser];
            [YGPushSDK registerSDKWithUserId:YGSingletonMarco.user.userId options:^(NSError *error) {
                
                
            }];
            [YGAppTool showToastWithText:@"登录成功"];
            
            [self back];
        }else
        {
            LoginViewController *vc = [[LoginViewController alloc] init];
            vc.loginWithType = loginWithThirdType;
            vc.thirdLoginDict = self.thirdLoginDict;
            vc.naviTitle = @"登录";
            vc.channel = self.channel;
            vc.phoneString = _loginView.phoneTextField.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    //查询用户是否已存在
    if ([URLString isEqualToString:REQUEST_userCheck])
    {
        //三方第一页面检查用户是否存在 存在的话跳下一夜 其他页面检查用户后发送验证码
        if (self.loginWithType == loginWithThirdType) {
            if ([responseObject[@"state"] isEqualToString:@"1"])
            {
                LoginViewController *vc = [[LoginViewController alloc] init];
                vc.loginWithType = loginWithThirdSubType;
                vc.thirdLoginDict = self.thirdLoginDict;
                vc.naviTitle = @"登录";
                vc.phoneString = parameters[@"phone"];
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                LoginViewController *vc = [[LoginViewController alloc] init];
                vc.loginWithType = loginWithThirdSubTypeNoAccountType;
                vc.thirdLoginDict = self.thirdLoginDict;
                vc.naviTitle = @"登录";
                vc.phoneString = parameters[@"phone"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        else{
            if (self.loginWithType == loginWithRegistType)
            {
                if ([responseObject[@"state"] isEqualToString:@"1"])
                {
                    [YGAppTool showToastWithText:@"手机号已注册"];
                    return;
                }
            }
            
            [self startPostWithURLString:REQUEST_sendSMS parameters:@{@"phone":_loginView.phoneTextField.text,@"type":type} showLoadingView:NO scrollView:nil];
            //            [self startPostWithURLString:REQUEST_checkSMS parameters:@{@"phone":_loginView.phoneTextField.text,@"code":_loginView.verifyTextField.text,@"type":type} showLoadingView:NO scrollView:nil];
        }
    }
    
    //发送验证码
    if ([URLString isEqualToString:REQUEST_sendSMS])
    {
        [[YGSingleton sharedManager] startTimerWithTime:60];
        [YGAppTool showToastWithText:@"验证码发送成功，请注意查收"];
        [_loginView.verifyTextField becomeFirstResponder];
    }
    //三方登录后返回进入页
    if ([URLString isEqualToString:REQUEST_Binding])
    {
        //请求服务器后如果请求成功
        //模拟点击登录成功
        YGSingletonMarco.user = [YGUser mj_objectWithKeyValues:responseObject[@"user"]];
        //拿到新的就归档到本地
        [YGSingletonMarco archiveUser];
        
        [YGPushSDK registerSDKWithUserId:YGSingletonMarco.user.userId options:^(NSError *error) {
            [YGAppTool showToastWithText:@"登录成功"];
        }];
        
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 3]animated:YES];
    }
    if ([URLString isEqualToString:REQUEST_userLogin])
    {
        //三方账号存在验证码正确登录后 绑定
        if (self.loginWithType == loginWithThirdSubType)//三方子页面
        {
            [self.thirdLoginDict setValue:self.phoneString forKey:@"phone"];
            
            [self startPostWithURLString:REQUEST_Binding parameters:self.thirdLoginDict showLoadingView:NO scrollView:nil];
            
        }else if (self.loginWithType == loginWithGetBackPasswordSubType) //找回密码子页面
        {
            //请求服务器后如果请求成功
            //模拟点击登录成功
            YGSingletonMarco.user = [YGUser mj_objectWithKeyValues:responseObject[@"user"]];
            //拿到新的就归档到本地
            [YGSingletonMarco archiveUser];
            
            [YGPushSDK registerSDKWithUserId:YGSingletonMarco.user.userId options:^(NSError *error) {
                [YGAppTool showToastWithText:@"登录成功"];
            }];
            NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 3]animated:YES];
        }
        else  if (self.loginWithType == loginWithRegistType)
        {
            //请求服务器后如果请求成功
            //模拟点击登录成功
            YGSingletonMarco.user = [YGUser mj_objectWithKeyValues:responseObject[@"user"]];
            //拿到新的就归档到本地
            [YGSingletonMarco archiveUser];
            
            [YGPushSDK registerSDKWithUserId:YGSingletonMarco.user.userId options:^(NSError *error) {
                [YGAppTool showToastWithText:@"登录成功"];
                
            }];
            NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
            
        }else//正常登录存储用户信息
        {
            //请求服务器后如果请求成功
            //模拟点击登录成功
            YGSingletonMarco.user = [YGUser mj_objectWithKeyValues:responseObject[@"user"]];
            //拿到新的就归档到本地
            [YGSingletonMarco archiveUser];
            
            [YGPushSDK registerSDKWithUserId:YGSingletonMarco.user.userId options:^(NSError *error) {
                [YGAppTool showToastWithText:@"登录成功"];
            }];
            [self back];
            
        }
    }
    
    if ([URLString isEqualToString:REQUEST_checkSMS]) //验证验证码
    {
        if (self.loginWithType == loginWithNimbleType ) { //快捷登录
            [self startPostWithURLString:REQUEST_smsLogin parameters:@{@"phone":_loginView.phoneTextField.text,@"mobileCode":_loginView.verifyTextField.text} showLoadingView:NO scrollView:nil];
            
        }
        if (self.loginWithType == loginWithGetBackPasswordType) //找回密码
        {
            LoginViewController *vc = [[LoginViewController alloc] init];
            vc.loginWithType = loginWithGetBackPasswordSubType;
            vc.naviTitle = @"找回密码";
            vc.phoneString = parameters[@"phone"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        //三方账号存在验证码正确 调起登录
        if (self.loginWithType == loginWithThirdSubType)//三方子页面
        {
            
            [self startPostWithURLString:REQUEST_userLogin parameters:@{@"phone":self.phoneString,@"mobileCode":_loginView.verifyTextField.text,@"passWord":_loginView.passwordTextField.text} showLoadingView:NO scrollView:nil];
            
        }
        if (self.loginWithType == loginWithGetBackPasswordSubType) //密码找回子页面
        {
            [self startPostWithURLString:REQUEST_forgetPassword parameters:@{@"phone":self.phoneString,@"mobileCode":_loginView.verifyTextField.text,@"newPassword":_loginView.passwordTextField.text} showLoadingView:NO scrollView:nil];
            
        }
        if (self.loginWithType == loginWithRegistType) //注册页面
        {
            NSString *code;
            if (self.loginWithType == loginWithRegistType)
            {
                if ([_loginView.inviteCodeTextField.text isEqualToString:@""])
                {
                    code = @"";
                }else
                {
                    code = _loginView.inviteCodeTextField.text;
                }
            }
            [self startPostWithURLString:REQUEST_newUserRegistration parameters:@{@"phone":_loginView.phoneTextField.text,@"mobileCode":_loginView.verifyTextField.text,@"passWord":_loginView.passwordTextField.text,@"code":code} showLoadingView:NO scrollView:nil];
            
        }
    }
    //忘记密码接口 之后调登录
    if ([URLString isEqualToString:REQUEST_forgetPassword])
    {
        [self startPostWithURLString:REQUEST_userLogin parameters:@{@"phone":self.phoneString,@"passWord":_loginView.passwordTextField.text} showLoadingView:NO scrollView:nil];
        
    }
    //新用户注册
    if ([URLString isEqualToString:REQUEST_newUserRegistration])
    {
        if (self.loginWithType == loginWithThirdSubTypeNoAccountType) {
            //三方没账号注册之后先绑定  绑定之后三方登录
            
            [self.thirdLoginDict setValue:self.phoneString forKey:@"phone"];
            
            [self startPostWithURLString:REQUEST_Binding parameters:self.thirdLoginDict showLoadingView:NO scrollView:nil];
            
            
        }else
        {
            
            [self startPostWithURLString:REQUEST_userLogin parameters:@{@"phone":_loginView.phoneTextField.text,@"passWord":_loginView.passwordTextField.text} showLoadingView:NO scrollView:nil];
        }
        
    }
    if ([URLString isEqualToString:REQUEST_smsLogin])
    {
        YGSingletonMarco.user = [YGUser mj_objectWithKeyValues:responseObject[@"user"]];
        //拿到新的就归档到本地
        [YGSingletonMarco archiveUser];
        [YGPushSDK registerSDKWithUserId:YGSingletonMarco.user.userId options:^(NSError *error) {
            [YGAppTool showToastWithText:@"登录成功"];
            
        }];
        
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
    }
    
}

- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
    [YGNetService dissmissLoadingView];
    _loginView.verifyButton.enabled = YES;
    
}
- (void)commonTimerCountingDownWithLeftSeconds:(NSInteger)seconds
{
    [_loginView.verifyButton setTitleColor:colorWithPlaceholder forState:UIControlStateNormal];
    _loginView.verifyButton.layer.borderColor = colorWithPlaceholder.CGColor;
    [_loginView.verifyButton setTitle:[NSString stringWithFormat:@"重新获取(%lu)", (unsigned long) seconds] forState:UIControlStateNormal];
}

- (void)commonTimerDidFinishCountDown
{
    _loginView.verifyButton.enabled = YES;
    [_loginView.verifyButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    _loginView.verifyButton.layer.borderColor = colorWithMainColor.CGColor;
    
    [_loginView.verifyButton setTitle:@"发送验证码" forState:UIControlStateNormal];
}
- (void)pushProtocol
{
    [YGNetService YGPOST:REQUEST_getUserAgreement parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        ProjectApplyForWebDetailViewController *vc = [[ProjectApplyForWebDetailViewController alloc] init];
        vc.naviTitleString = @"青网协议";
        vc.contentUrl = responseObject[@"userAgreement"];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error) {
        
    }];
    
}
@end
