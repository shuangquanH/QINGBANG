//
//  PasswordModifilyViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PasswordModifilyViewController.h"

@interface PasswordModifilyViewController ()
{
    UIView *_passwordBaseView;
}
@property(nonatomic,strong)UITextField *passwordTextField;

@end

@implementation PasswordModifilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"密码设置";
    [self configUI];
}

-(void)configUI
{
    //提示文字
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, YGScreenWidth, 20)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = colorWithLightGray;
    tipLabel.font = [UIFont systemFontOfSize:14.0];
    tipLabel.text = @"请设置6-20位密码";
    [self.view addSubview:tipLabel];
    
    [self createPasswordViewWithBaseView];
}

#pragma 密码
- (void)createPasswordViewWithBaseView
{
    //baseview
    _passwordBaseView = [[UIView alloc] initWithFrame:CGRectMake(15, 100, YGScreenWidth - 30, 50)];
    [self.view addSubview:_passwordBaseView];
    //手机号图
    UIImageView *phoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password_icon_black"]];
    [phoneImageView sizeToFit];
    phoneImageView.frame = CGRectMake(10, 10, phoneImageView.width, phoneImageView.height);
    //    phoneImageView.centery = _passwordBaseView.centery;
    [_passwordBaseView addSubview:phoneImageView];
    
    //手机号text
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(phoneImageView.x + phoneImageView.width + 15, 0, YGScreenWidth - phoneImageView.x - phoneImageView.width - 30, 30)];
    _passwordTextField.centery = phoneImageView.centery;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTextField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _passwordTextField.textColor = colorWithBlack;
    _passwordTextField.placeholder = @"密码";
    [_passwordTextField setValue:colorWithPlaceholder forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordBaseView addSubview:_passwordTextField];
    
    //线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _passwordTextField.y + _passwordTextField.height + 15, _passwordBaseView.width, 0.5)];
    lineView.backgroundColor = KCOLOR_LINE;
    [_passwordBaseView addSubview:lineView];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(15, 200, YGScreenWidth - 30, 40);
    nextButton.backgroundColor = colorWithMainColor;
    nextButton.layer.cornerRadius = 20;
    nextButton.clipsToBounds = YES;
    [nextButton setTitle:@"完成" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}

//完成
-(void)nextClick:(UIButton *)button
{
    //检验输入的密码对不对
    if(_passwordTextField.text.length < 6 || _passwordTextField.text.length > 20)
    {
        [YGAppTool showToastWithText:@"请输入6-20位密码"];
        return ;
    }
    [YGNetService YGPOST:@"updatePassword" parameters:@{@"userId":YGSingletonMarco.user.userId,@"newPassword":_passwordTextField.text} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        [YGAppTool showToastWithText:@"修改成功!"];
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
