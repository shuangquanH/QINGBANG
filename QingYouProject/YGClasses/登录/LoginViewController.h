//
//  LoginViewController.h
//  FrienDo
//
//  Created by zhangkaifeng on 2017/1/6.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "LoginView.h"
#import "SQChooseGardenVC.h"

@interface LoginViewController : RootViewController
@property (nonatomic, assign) LoginWithTypes            loginWithType;
@property (nonatomic, strong) NSString                  *phoneString; //找回密码、三方登录子页面带数据
@property (nonatomic, strong) NSMutableDictionary            *thirdLoginDict;
@property (nonatomic, copy)  NSString                   *channel;


/** 登录成功后选择园区  */
@property (nonatomic, strong) SQChooseGardenVC       *chooseGardenVC;


@end
